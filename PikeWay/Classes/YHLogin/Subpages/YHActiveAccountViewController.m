//
//  YHActiveAccountViewController.m
//  PikeWay
//
//  Created by YHIOS002 on 16/8/9.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHActiveAccountViewController.h"
#import "YHUICommon.h"
#import "IQKeyboardManager.h"
#import <SMS_SDK/SMSSDK.h>
#import "YHUtils.h"
#import "YHVerifyCodeManager.h"
#import "YHRegisterChooseJobMainViewController.h"
#import "YHNetManager.h"
#import "YHSetPasswd.h"
#import "YHCacheManager.h"
#import "YHThirdPModel.h"
#import "MBProgressHUD.h"
#import "YHError.h"
#import "YHUserInfoManager.h"
#import "UIBarButtonItem+Extension.h"
#import "YHNetManager+Login.h"
#import "YHNetManager+Profile.h"

#define kGetVerifyCodeCDTime    60      // 60秒

@interface YHActiveAccountViewController ()<UITableViewDelegate,UITableViewDataSource>{
    NSTimer         *_timerForGetVerifyCodeCD;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *CellForHeader;
@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNum;        //手机号
@property (weak, nonatomic) IBOutlet UIButton *btnSendVerifyCode; //发送验证码
@property (weak, nonatomic) IBOutlet UITextField *tfVerifyCode;      //验证码输入框
@property (weak, nonatomic) IBOutlet UIButton *btnActive;         //激活按钮
@property (weak, nonatomic) IBOutlet UIView *viewContariner;


@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (assign,nonatomic) int nGetVerifyCodeCDTime; //倒计时

@end

@implementation YHActiveAccountViewController

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

#pragma mark - initUI
- (void)setupNavigationBar{
    self.title = @"激活账号";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self selector:@selector(onBack:)];
}

- (void)initUI{
    
    [self setupNavigationBar];
    //tableviewList
    self.tableview.rowHeight =  240.0f;
    
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
    
    //激活按钮
    self.btnActive.layer.cornerRadius = 3;
    self.btnActive.layer.masksToBounds = YES;
    self.btnActive.enabled = NO;
    self.btnActive.backgroundColor = kGrayColor;
    
    //发送验证码
    self.btnSendVerifyCode.layer.cornerRadius = 3;
    self.btnSendVerifyCode.layer.masksToBounds = YES;
    self.btnSendVerifyCode.enabled = NO;
    self.btnSendVerifyCode.backgroundColor = kGrayColor;
    
}



#pragma mark - NSNotification

- (void)textFiledEditChanged:(NSNotification *)aNotifi{
    
    if (!self.tfPhoneNum.text.length) {
        self.btnSendVerifyCode.enabled = NO;
        self.btnSendVerifyCode.backgroundColor = kGrayColor;
    }
    else{
        

        if (_nGetVerifyCodeCDTime == kGetVerifyCodeCDTime)
        {
            self.btnSendVerifyCode.enabled = YES;
            self.btnSendVerifyCode.backgroundColor = kBlueColor;
        }
       
    }
    
    if (!self.tfPhoneNum.text.length || !self.tfVerifyCode.text.length) {
        self.btnActive.enabled = NO;
        self.btnActive.backgroundColor = kGrayColor;
    }
    else{
        self.btnActive.enabled = YES;
        self.btnActive.backgroundColor = kBlueColor;
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return _CellForHeader;
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

/**
 *  向MobSDK获取手机验证码
 */
- (void)getVerifyCode{
    
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
                            phoneNumber:self.tfPhoneNum.text
                                   zone:@"86"
                               customIdentifier:nil //自定义短信模板标识
                                 result:^(NSError *error)
     {
         
         if (!error)
         {
             postHUDTips([NSString stringWithFormat:@"验证码已经发送到%@的手机",_tfPhoneNum.text],self.view);
             
             [[YHVerifyCodeManager shareInstance] storageLoginByThridPartyAcountVCDate];
             
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

#pragma mark - 网络请求
//请求绑定手机号
- (void)requestBindPhone{

    __weak typeof(self)weakSelf = self;
    [MBProgressHUD hideHUDForView:kRootViewController.view animated:YES];
    [[YHNetManager sharedInstance] postBindPhone:self.tfPhoneNum.text platform:_platform thridPartyUid:_snsAccount.uid verifyCode:self.tfVerifyCode.text complete:^(BOOL success, id obj) {
        [MBProgressHUD hideHUDForView:kRootViewController.view animated:YES];
        
        [[YHVerifyCodeManager shareInstance] resetLoginByThridPartyAcountVCDate];
        if (success)
        {
            //0.重置验证码错误次数
            [YHError sharedInstance].verifyCodeErrorCount = 0;
            
            [[YHVerifyCodeManager shareInstance] resetRegisterVCDate];
            
            //1.本地缓存第三方账号信息
            YHThirdPModel *model = [[YHThirdPModel alloc] initWithsnsAccount:_snsAccount];
            [[YHCacheManager shareInstance] cacheThirdPartyAccount:model];
            
            //2.提示
            postHUDTips(@"激活成功",self.view);
            YHUserInfo *userInfo = obj;
            //QQ头像做税道头像，QQ昵称做税道临时名称
            if (_snsAccount) {
                userInfo.userName    = _snsAccount.name;
                userInfo.avatarUrl   = [NSURL URLWithString:_snsAccount.iconurl] ;
            }
           
            //3.更新用户偏好设置信息
            [[YHUserInfoManager sharedInstance] loginSuccessWithUserInfo:userInfo];
            
            //4.修改头像和姓名
            if (_snsAccount) {
                [self requestEditUserInfo:userInfo retryCount:1];
            }
            
            //5.弹框设置登录密码
            YHSetPasswd *spwView =[[YHSetPasswd alloc] init];
            [spwView onSureBlock:^(NSString *passwd) {
             
                [MBProgressHUD showHUDAddedTo:kRootViewController.view animated:YES];
                
                //网络请求设置密码
                [[YHNetManager sharedInstance] postThridPartyLoginAndSetPasswd:passwd complete:^(BOOL success, id obj) {
                    [MBProgressHUD hideHUDForView:kRootViewController.view animated:YES];
                    if(success){
                        
                    //1.通知环信去注册
                    [[NSNotificationCenter defaultCenter] postNotificationName:Event_Register_Success object:nil userInfo:@{
                                                                                                                            @"phone":weakSelf.tfPhoneNum.text,
                                                                                                                            @"passwd":passwd
                                                                                                                            }];
                        
                       //2.进入选择行业
                    YHRegisterChooseJobMainViewController *vc =[[YHRegisterChooseJobMainViewController alloc] init];
                        [weakSelf.navigationController pushViewController:vc animated:YES ];
                        
                        
                    }
                    else{
                        
                        if (isNSDictionaryClass(obj))
                        {
                            //服务器返回的错误描述
                            NSString *msg  = obj[kRetMsg];
                            
                            postTips(msg, @"第三方登陆设置密码失败");
                            
                        }
                        else
                        {
                            //AFN请求失败的错误描述
                            postTips(obj, @"第三方登陆设置密码失败");
                        }

                    }
                }];
            }];
            [spwView show];
            
            
        }else
        {
            
            if (isNSDictionaryClass(obj))
            {
                //服务器返回的错误代码
                NSString *code = obj[kRetCode];
                NSString *msg  = obj[kRetMsg];
                if ([code isEqualToString:kErrorVerifyCode]) {
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
                else{
                    postTips(msg, @"注册失败");
                }
                
            }
            else
            {
                //AFN请求失败的错误描述
                postTips(obj, @"注册失败");
            }
            
        }
        
    }];
}

//检查手机是否已经注册
- (void)checkPhoneWhetherExsit:(NetManagerCallback)complete
{
    [[YHNetManager sharedInstance] getVerifyphoneNum:_tfPhoneNum.text complete:^(BOOL success, id obj) {
        complete(success, obj);
    }];
}

//请求修改个人信息
- (void)requestEditUserInfo:(YHUserInfo *)userInfo retryCount:(int)retryCount{
    __weak typeof(self)weakSelf = self;
    [[YHNetManager sharedInstance] postEditMyCardWithUserInfo:userInfo complete:^(BOOL success, id obj) {
        if(success){
            DDLog(@"成功修改头像和姓名");
            //修改用户信息的头像和姓名
            [YHUserInfoManager sharedInstance].userInfo.avatarUrl = userInfo.avatarUrl;
            [YHUserInfoManager sharedInstance].userInfo.userName  = userInfo.userName;
        }
        else{
            DDLog(@"修改头像和姓名失败:%@",obj);
            if (retryCount > 2) {
                
            }
            else{
                [weakSelf requestEditUserInfo:userInfo retryCount:retryCount+1];
            }
        
        }
    }];

}

#pragma mark - Action
- (IBAction)onBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}

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
    
    [YHError sharedInstance].verifyCodeErrorCount = 0;
    
    
    //3.向服务器验证手机号是否存在
    __weak typeof(self) weakSelf = self;
    [weakSelf checkPhoneWhetherExsit:^(BOOL success, id obj) {
        
        if (success)
        {
            
            //手机号可以进行注册
            [weakSelf getVerifyCode];
            
        }
        else
        {
            
            [weakSelf resetTimerAndVerifyCodeBtn];
            if (isNSDictionaryClass(obj))
            {
                
                NSString *code = obj[kRetCode];
                NSString *msg  = obj[kRetMsg];
                if ([code isEqualToString:kErrorPhoneNumExist])
                {
            
                    postTips(@"该手机号号码已被占用，请选择其他手机号", @"");
                }
                else
                {
                   
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


//激活账号
- (IBAction)onActiveAccount:(id)sender {
    
    
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
    
    if ([[YHVerifyCodeManager shareInstance] isExpiredLoginByThridPartyAcountVerifyCode]) {
        postTips(@"验证已失效，请重新获取", nil);
        return;
    }
    
    if([YHNetManager sharedInstance].currentNetWorkStatus == YHNetworkStatus_NotReachable){
        postHUDTips(kNetWorkFailTips, self.view);
        return;
    }
    
    [self.view endEditing:YES];
    
    [self requestBindPhone];
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
