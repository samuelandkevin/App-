//
//  YHVerifyCodeLoginViewController.m
//  PikeWay
//
//  Created by YHIOS002 on 16/4/28.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHVerifyCodeLoginViewController.h"
#import "YHNetManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "YHUserInfoManager.h"
#import "YHUICommon.h"
#import "YHUtils.h"
#import "IQKeyboardManager.h"
#import "YHVerifyCodeManager.h"
#import "MBProgressHUD.h"
#import "YHError.h"
#import "YHNetManager+Login.h"

#define kGetVerifyCodeCDTime    60      // 60秒

@interface YHVerifyCodeLoginViewController ()<UITextFieldDelegate,UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UITableViewDataSource>{
    NSTimer         *_timerForGetVerifyCodeCD;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *cellforLogin;//登录Cell
@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNum;//手机号
@property (weak, nonatomic) IBOutlet UIButton *btnSendVerifyCode; //发送验证码
@property (weak, nonatomic) IBOutlet UITextField *tfVerifyCode;//验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;//登录按钮
@property (weak, nonatomic) IBOutlet UIView *viewContariner;
@property (strong,nonatomic)UITableView  *tableViewList;
@property (assign,nonatomic) int nGetVerifyCodeCDTime; //倒计时
@property (strong,nonatomic)MBProgressHUD *loginLoading;        //正在登录Loading
@end

@implementation YHVerifyCodeLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        _timerForGetVerifyCodeCD    = NULL;
        _nGetVerifyCodeCDTime       = kGetVerifyCodeCDTime;
    }
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
   
    [self initUI];
    
    //2.监听通知
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.tfPhoneNum];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:self.tfVerifyCode];
}

#pragma mark - Setter
- (MBProgressHUD *)loginLoading{
    if (!_loginLoading) {
        _loginLoading = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
        _loginLoading.labelText = @"正在登录...";
        [self.navigationController.view addSubview:_loginLoading];
    }
    return _loginLoading;
}

#pragma mark - initUI
- (void)initUI{
    //tableviewList
    UITableView *tableViewList = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableViewList.delegate   = self;
    tableViewList.dataSource = self;
    tableViewList.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:tableViewList];
    self.tableViewList.rowHeight =  220.0f;
    
    //输入容器边框颜色
    self.viewContariner.layer.borderColor   = [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0].CGColor;
    self.viewContariner.layer.borderWidth   = 0.5;
    self.viewContariner.layer.cornerRadius  = 1;
    self.viewContariner.layer.masksToBounds = YES;
    
    //设置输入框左视图
    UIView *leftViewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.tfPhoneNum.leftView = leftViewPhone;
    self.tfPhoneNum.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *leftViewCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.tfVerifyCode.leftView     = leftViewCode;
    self.tfVerifyCode.leftViewMode =UITextFieldViewModeAlways;
    
    //登录按钮
    self.btnLogin.layer.cornerRadius = 3;
    self.btnLogin.layer.masksToBounds = YES;
    self.btnLogin.enabled = NO;
    self.btnLogin.backgroundColor = kGrayColor;
    
    //发送验证码
    self.btnSendVerifyCode.layer.cornerRadius = 3;
    self.btnSendVerifyCode.layer.masksToBounds = YES;
    self.btnSendVerifyCode.enabled = NO;
    self.btnSendVerifyCode.backgroundColor = kGrayColor;
    
}

#pragma mark - Touch

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITextFieldDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _cellforLogin;
}

#pragma mark - 网络请求

//检查手机是否已经注册
- (void)checkPhoneWhetherExsit:(NetManagerCallback)complete
{
    [[YHNetManager sharedInstance] getVerifyphoneNum:_tfPhoneNum.text complete:^(BOOL success, id obj) {
        complete(success, obj);
    }];
}


- (void)loginByVerifyCode:(NSString *)verifyCode phoneNum:(NSString *)phoneNum complete:(NetManagerCallback)complete{
    
    //短信登录
    [[YHNetManager sharedInstance] postLoginWithPhoneNum:phoneNum verifyCode:verifyCode complete:^(BOOL success, id obj) {
        complete(success,obj);
        
    }];
}

#pragma mark - Private

- (void)coolDownForGetVerificationCode {
    if (!_timerForGetVerifyCodeCD) {
        _timerForGetVerifyCodeCD = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onCDTimer:) userInfo:nil repeats:YES];
        _btnSendVerifyCode.enabled = NO;
    }
}

- (void)onCDTimer:(NSTimer *)theTimer {
    _nGetVerifyCodeCDTime -= 1;
    [_btnSendVerifyCode setTitle:[NSString stringWithFormat:@"%@(%d)", @"获取验证码", _nGetVerifyCodeCDTime] forState:UIControlStateDisabled];
    if (_nGetVerifyCodeCDTime == 0) {
        [theTimer invalidate];
        _timerForGetVerifyCodeCD = NULL;
        [_btnSendVerifyCode setTitle:@"重新验证" forState:UIControlStateNormal];
        [_btnSendVerifyCode setTitle:[NSString stringWithFormat:@"%@(%d)", @"获取验证码", kGetVerifyCodeCDTime] forState:UIControlStateDisabled];
        _btnSendVerifyCode.enabled = YES;
        _nGetVerifyCodeCDTime = kGetVerifyCodeCDTime;
        self.btnSendVerifyCode.backgroundColor = kBlueColor;
        self.tfPhoneNum.enabled  = YES;
    }
}

#pragma mark - Action
//发送验证码
- (IBAction)onSendVerifyCode:(id)sender {
    
   
    //0.手机格式是否正确
    if(!isValidePhoneFormat(self.tfPhoneNum.text))
    {
        postHUDTips(@"手机号填写不正确,仅支持大陆手机号码", self.view);
        return;
    }
    
    if([YHNetManager sharedInstance].currentNetWorkStatus == YHNetworkStatus_NotReachable){
        postHUDTips(kNetWorkFailTips, self.view);
        return;
    }
    
    //1.倒计时开始
    [self coolDownForGetVerificationCode];
     self.btnSendVerifyCode.backgroundColor = kGrayColor;
    
    //2.手机输入框不能编辑
    self.tfPhoneNum.enabled = NO;
    
    
    //3.向服务器验证手机号是否存在
    __weak typeof(self) weakSelf = self;
    [weakSelf checkPhoneWhetherExsit:^(BOOL success, id obj) {
        
        if (success) {
            
            //手机号可以进行注册
            postTips(@"手机号不存在", @"");
            
        }else{
            
            
            if (isNSDictionaryClass(obj))
            {
                
                NSString *code = obj[kRetCode];
                NSString *msg  = obj[kRetMsg];
                if ([code isEqualToString:kErrorPhoneNumExist])
                {
                    DDLog(@"手机号已经存在");
                    [self getVerifyCode];
                }
                else
                {
                    [weakSelf resetTimerAndVerifyCodeBtn];
                    postTips(msg, @"检查手机号失败");
                }
                
            }
            else
            {
                [weakSelf resetTimerAndVerifyCodeBtn];
                postTips(obj, @"检查手机号失败");
            }
           
        }
    }];
    
}

//重置定时器和发送验证码
- (void)resetTimerAndVerifyCodeBtn{
    [_timerForGetVerifyCodeCD invalidate];
    _timerForGetVerifyCodeCD = NULL;
    _nGetVerifyCodeCDTime = kGetVerifyCodeCDTime;
    
    [_btnSendVerifyCode setTitle:@"重新验证" forState:UIControlStateNormal];
    [_btnSendVerifyCode setTitle:@"验证" forState:UIControlStateDisabled];
    _btnSendVerifyCode.enabled = YES;
    _btnSendVerifyCode.backgroundColor = kBlueColor;
    
    self.tfPhoneNum.enabled  = YES;
}

/**
 *  向MobSDK获取手机验证码
 */
- (void)getVerifyCode{
   
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.tfPhoneNum.text  zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error)
        {
            postHUDTips([NSString stringWithFormat:@"验证码已经发送到%@的手机",_tfPhoneNum.text],self.view);
            
            [[YHVerifyCodeManager shareInstance] storageLoginVCDate];
        }
        else
        {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"获取验证码失败"
                                                            message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
    
}


/**
 *  点击登录
 *
 *  @param sender
 */
- (IBAction)onLogin:(id)sender
{
    //0.手机格式是否正确
    if(!isValidePhoneFormat(self.tfPhoneNum.text))
    {
        postHUDTips(@"手机号填写不正确,仅支持大陆手机号码", self.view);
        return;
    }
    
    //1.验证码格式是否正确
    if (!self.tfVerifyCode.text.length)
    {
        postTips(@"",@"验证码不能为空");
        return;
    }
    
    if ([[YHVerifyCodeManager shareInstance] isExpiredLoginVerifyCode]) {
        postTips(@"验证已失效，请重新获取", nil);
        return;
    }
    
    if([YHNetManager sharedInstance].currentNetWorkStatus == YHNetworkStatus_NotReachable){
        postHUDTips(kNetWorkFailTips, self.view);
        return;
    }
    
    [self.view endEditing:YES];
    
    //2.显示Loading
    [self.loginLoading showAnimated:YES];
    __weak typeof (self)weakSelf = self;
    [self loginByVerifyCode:self.tfVerifyCode.text phoneNum:self.tfPhoneNum.text complete:^(BOOL success, id obj) {
        [weakSelf.loginLoading hideAnimated:YES];
        
        if (success) {
            DDLog(@"手机验证码登录成功");
            
            [YHError sharedInstance].verifyCodeErrorCount = 0;
            
            [[YHVerifyCodeManager shareInstance] resetLoginVCDate];
            
            //0.提示
            postHUDTips(@"验证成功",self.view);
            
            //1.更新用户偏好设置信息
            [[YHUserInfoManager sharedInstance] loginSuccessWithUserInfo:obj];
            
            //2.1秒后跳转到工作圈
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [[NSNotificationCenter defaultCenter] postNotificationName:Event_Login_Success object:nil];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:NULL];
            });
           
        }
        else
        {
            
            if (isNSDictionaryClass(obj))
            {
              
                NSString *code = obj[kRetCode];
                NSString *msg  = obj[kRetMsg];
                
                if([code isEqualToString:kErrorVerifyCode])
                {
                    //验证码错误
                    if ([YHError sharedInstance].verifyCodeErrorCount >= 3)
                    {
                        postTips(@"验证码输错三次，请重新获取", @"");
                    }
                    else
                    {
                        postTips(@"验证码错误,请重新输入", @"");
                    }
                    
                    [YHError sharedInstance].verifyCodeErrorCount +=1;
 
                }
                else
                {
                    postTips(msg, @"手机验证码登录失败");
                }
                
            }
            else
            {
                //AFN请求失败的错误描述
                postTips(obj, @"手机验证码登录失败");
            }
          
        }
        
    }];
}

#pragma mark - NSNotification

- (void)textFiledEditChanged:(NSNotification *)aNotifi{
    
    if (!self.tfPhoneNum.text.length) {
        self.btnSendVerifyCode.enabled = NO;
        self.btnSendVerifyCode.backgroundColor = kGrayColor;
    }
    else{
        self.btnSendVerifyCode.enabled = YES;
        self.btnSendVerifyCode.backgroundColor = kBlueColor;
    }
    
    if (!self.tfPhoneNum.text.length || !self.tfVerifyCode.text.length) {
        self.btnLogin.enabled = NO;
        self.btnLogin.backgroundColor = kGrayColor;
    }
    else{
        self.btnLogin.enabled = YES;
        self.btnLogin.backgroundColor = kBlueColor;
    }
    
}

#pragma mark - Life

- (void)viewWillAppear:(BOOL)animated{
   
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
   
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.view endEditing:YES];
    [super viewWillDisappear:animated];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLog(@"%s vc dealloc",__FUNCTION__);
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
