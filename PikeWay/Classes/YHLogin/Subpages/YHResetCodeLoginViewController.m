//
//  YHResetCodeLoginViewController.m
//  PikeWay
//
//  Created by YHIOS002 on 16/4/28.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHResetCodeLoginViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import "YHNetManager.h"
#import "IQKeyboardManager.h"
#import "YHNetManager.h"
#import "YHVerifyCodeManager.h"
#import "MBProgressHUD.h"
#import "YHUtils.h"
#import "YHError.h"
#import "YHNetManager+Profile.h"
#import "YHNetManager+Login.h"
#import "YHUserInfoManager.h"
#import "UIBarButtonItem+Extension.h"

#define kGetVerifyCodeCDTime 60 // 60秒
@interface YHResetCodeLoginViewController () <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate
>{
	NSTimer *_timerForGetVerifyCodeCD;
}

@property (strong, nonatomic) IBOutlet UITableViewCell *cellForResetCode; //重置密码cell
@property (weak, nonatomic) IBOutlet UIView *viewContainer;               //容器

@property (weak, nonatomic) IBOutlet UIButton *btnResetCode;        //重置密码按钮
@property (weak, nonatomic) IBOutlet UITextField *tfPhoneNum;       //手机号
@property (weak, nonatomic) IBOutlet UIButton *btnVerify;           //验证
@property (weak, nonatomic) IBOutlet UITextField *tfVerifyCode;     //验证码输入框
@property (weak, nonatomic) IBOutlet UITextField *tfNewPasswd;      //新密码输入框
@property (weak, nonatomic) IBOutlet UIButton *btnShowPasswd;       //显示/隐藏新密码按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cstTbvTop; //tableview顶部距离约束

@property (assign, nonatomic) int nGetVerifyCodeCDTime;    //倒计时
@property (strong, nonatomic) MBProgressHUD *loginLoading; //显示loading
@property (weak, nonatomic) IBOutlet UITableView *tableViewList;
@end

@implementation YHResetCodeLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])
	{
		_timerForGetVerifyCodeCD = NULL;
		_nGetVerifyCodeCDTime = kGetVerifyCodeCDTime;
	}
	return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
	//1.initUI
	[self  initUI];

	//2.监听通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
												 name:@"UITextFieldTextDidChangeNotification"
											   object:self.tfPhoneNum];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
												 name:@"UITextFieldTextDidChangeNotification"
											   object:self.tfVerifyCode];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
												 name:@"UITextFieldTextDidChangeNotification"
											   object:self.tfNewPasswd];
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - Setter
- (MBProgressHUD *)loginLoading
{
	if (!_loginLoading)
	{
		_loginLoading = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
		_loginLoading.labelText = @"重置中...";
		[self.navigationController.view addSubview:_loginLoading];
	}
	return _loginLoading;
}

#pragma mark - init
- (void)setupNavigationBar{
    self.title = @"重置密码";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self selector:@selector(onBack:)];
}

- (void)initUI
{
    [self setupNavigationBar];
	//输入容器边框颜色
	self.viewContainer.layer.borderColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor;
	self.viewContainer.layer.borderWidth = 0.5;
	self.viewContainer.layer.cornerRadius = 1;
	self.viewContainer.layer.masksToBounds = YES;

	//设置输入框左视图
	UIView *leftViewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	self.tfPhoneNum.leftView = leftViewPhone;
	self.tfPhoneNum.leftViewMode = UITextFieldViewModeAlways;

	UIView *leftViewVeriCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	self.tfVerifyCode.leftView = leftViewVeriCode;
	self.tfVerifyCode.leftViewMode = UITextFieldViewModeAlways;

	UIView *leftViewNewCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	self.tfNewPasswd.leftView = leftViewNewCode;
	self.tfNewPasswd.leftViewMode = UITextFieldViewModeAlways;

	//验证码
	self.btnVerify.layer.cornerRadius = 2;
	self.btnVerify.layer.masksToBounds = YES;
    self.btnVerify.enabled = NO;
    
	//重置密码
	self.btnResetCode.layer.cornerRadius = 3;
	self.btnResetCode.layer.masksToBounds = YES;
	self.btnResetCode.enabled = NO;
	self.btnResetCode.backgroundColor = RGBCOLOR(196, 197, 198);

	//tableview
	self.tableViewList.rowHeight = 286.0f;

}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return _cellForResetCode;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == _tfPhoneNum)
	{
		if (!isValidePhoneFormat(self.tfPhoneNum.text))
		{
			postHUDTips(@"手机号填写不正确,仅支持大陆手机号码", self.view);
			return NO;
		}
		else
		{
			[_tfVerifyCode becomeFirstResponder];
			return YES;
		}
	}
	else if (textField == _tfVerifyCode)
	{
		[_tfNewPasswd becomeFirstResponder];
		return YES;
	}
	else if (textField == _tfNewPasswd)
	{
		if (!isValidePassword(_tfNewPasswd.text))
		{
			postHUDTips(@"新密码请输入6-20位数字或字符", self.view);
			return NO;
		}
		[_tfNewPasswd resignFirstResponder];
		return NO;
	}

	return YES;
}

#pragma mark - Action

- (IBAction)onBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 *  点击"重置密码"
 *
 *  @param sender btn
 */
- (IBAction)onResetPasswd:(UIButton *)sender
{
	
	//1.判断手机格式
	if (!isValidePhoneFormat(self.tfPhoneNum.text))
	{
		postHUDTips(@"手机号填写不正确,仅支持大陆手机号码", self.view);
		return;
	}

	//验证码格式
	if (!self.tfVerifyCode.text.length)
	{
		postTips(@"验证码不能为空", @"");
		return;
	}

	//密码格式
	if (!isValidePassword(self.tfNewPasswd.text))
	{
		postHUDTips(@"新密码请输入6-20位数字或字符", self.view);
		return;
	}
    
    if ([[YHVerifyCodeManager shareInstance] isExpiredResetPasswdLoginVerifyCode]) {
         postTips(@"验证已失效，请重新获取", nil);
        return;
    }

	if ([YHNetManager sharedInstance].currentNetWorkStatus == YHNetworkStatus_NotReachable)
	{
		postHUDTips(kNetWorkFailTips, self.view);
		return;
	}
    
	[self.view endEditing:YES];
	//2.显示Loading
	[self.loginLoading showAnimated:YES];

	//3.向服务器进行重置密码登录
	__weak typeof(self) weakSelf = self;

	[[YHNetManager sharedInstance] postLoginWithPhoneNum:weakSelf.tfPhoneNum.text verifyCode:weakSelf.tfVerifyCode.text newPasswd:weakSelf.tfNewPasswd.text complete:^(BOOL success, id obj) {
		if (success)
		{
    
            [YHError sharedInstance].verifyCodeErrorCount = 0;
            [[YHVerifyCodeManager shareInstance] resetRPLoginVCDate];
            
	        //0.重置密码成功,loading文案相应变化
			weakSelf.loginLoading.labelText = @"登录中";
	        //1.重置密码后,调用登录接口。
			[weakSelf requestLoginWithPhoneNum:weakSelf.tfPhoneNum.text passwd:weakSelf.tfNewPasswd.text];
		}
		else
		{
			[weakSelf.loginLoading hideAnimated:YES];

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
                    postTips(msg, @"重置密码登录失败");
                }
              
                
            }
            else
            {
                //AFN请求失败的错误描述
                postTips(obj, @"重置密码登录失败");
            }
			
		}
	}];
}

//密码输入方式
- (IBAction)showPasswd:(UIButton *)sender
{
	sender.selected = !sender.selected;
	NSString *passwd = self.tfNewPasswd.text;
	self.tfNewPasswd.secureTextEntry = (sender.selected) ? NO : YES;
	self.tfNewPasswd.text = @" ";
	self.tfNewPasswd.text = passwd;
}

/**
 *  点击"验证"按钮
 *
 *  @param sender btn
 */
- (IBAction)onVerifyPhone:(id)sender
{
	//0.手机格式是否正确
	if (!isValidePhoneFormat(self.tfPhoneNum.text))
	{
		postHUDTips(@"手机号填写不正确,仅支持大陆手机号码", self.view);
		return;
	}

	if ([YHNetManager sharedInstance].currentNetWorkStatus == YHNetworkStatus_NotReachable)
	{
		postHUDTips(kNetWorkFailTips, self.view);
		return;
	}
    
    [YHError sharedInstance].verifyCodeErrorCount = 0;

	//1.倒计时开始
	[self coolDownForGetVerificationCode];
	self.btnResetCode.backgroundColor = RGBACOLOR(197, 198, 199, 1.0);

	//2.手机输入框不能编辑
	self.tfPhoneNum.enabled = NO;
	self.btnVerify.enabled = NO;
	self.btnVerify.backgroundColor = RGBCOLOR(196, 197, 198);

	[self.view endEditing:YES];
    
	//3.向服务器验证手机号是否已注册
    [[YHNetManager sharedInstance] getVerifyphoneNum:_tfPhoneNum.text complete:^(BOOL success, id obj) {
       
        
        if (success)
        {
            //此手机可以进行注册
            postTips(@"手机号不存在", @"");
        }
        else
        {
            
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
                    [self resetTimerAndVerifyCodeBtn];
                    postTips(msg, @"检查手机号失败");
                }
                
            }
            else
            {
                [self resetTimerAndVerifyCodeBtn];
                 postTips(obj, @"检查手机号失败");
            }
            
        }
    }];
    
}

#pragma mark - NSNotification

- (void)textFiledEditChanged:(NSNotification *)aNotifi
{
	if (!self.tfPhoneNum.text.length || !self.tfVerifyCode.text.length || !self.tfNewPasswd.text.length)
	{
		self.btnResetCode.enabled = NO;
		self.btnResetCode.backgroundColor = kGrayColor;
	}
	else
	{
		self.btnResetCode.enabled = YES;
		self.btnResetCode.backgroundColor = kBlueColor;
	}

	if (!self.tfPhoneNum.text.length)
	{
		self.btnVerify.enabled = NO;
		self.btnVerify.backgroundColor = kGrayColor;
	}
	else
	{
		self.btnVerify.enabled = YES;
		self.btnVerify.backgroundColor = kBlueColor;
	}
    
}

#pragma mark - Life

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    if (isiPad) {
        [[IQKeyboardManager sharedManager] setEnable:NO];
        [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    }
   
}

- (void)viewWillDisappear:(BOOL)animated
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self.view endEditing:YES];
	[super viewWillDisappear:animated];
     [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    DDLog(@"%s vc dealloc",__FUNCTION__);
}

#pragma mark - KeyBoard
- (void)keyboardWillShow:(NSNotification *)aNotification
{
	// get keyboard size and loctaion
	CGRect kbRect;

	[[aNotification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] getValue:&kbRect];
	NSNumber *duration = [aNotification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
	NSNumber *curve = [aNotification.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey];

	UIView *activeView = self.tfNewPasswd;

	if (!activeView)
	{
		return;
	}

	CGPoint keyboardOriginInActiveField = [activeView convertPoint:kbRect.origin fromView:[UIApplication sharedApplication].keyWindow];

	float ret = activeView.frame.size.height - keyboardOriginInActiveField.y;

	if (ret > 0)
	{
		[UIView animateWithDuration:[duration floatValue] delay:0 options:[curve integerValue] animations:^{
			self.cstTbvTop.constant = -ret;
			[self.view layoutIfNeeded];
		} completion:NULL];
	}
}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{
	[UIView animateWithDuration:0.3 animations:^{
		self.cstTbvTop.constant = 0;
		[self.view layoutIfNeeded];
	}];
}

#pragma mark - Private

- (void)coolDownForGetVerificationCode
{
	if (!_timerForGetVerifyCodeCD)
	{
		_timerForGetVerifyCodeCD = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(onCDTimer:) userInfo:nil repeats:YES];
		[_timerForGetVerifyCodeCD fire];
		_btnVerify.enabled = NO;
	}
}

- (void)onCDTimer:(NSTimer *)theTimer
{
	_nGetVerifyCodeCDTime -= 1;
	[_btnVerify setTitle:[NSString stringWithFormat:@"(%d%@)", _nGetVerifyCodeCDTime, @"s"] forState:UIControlStateDisabled];

	if (_nGetVerifyCodeCDTime == 0)
	{
		[theTimer invalidate];
		_timerForGetVerifyCodeCD = NULL;
		[_btnVerify setTitle:[NSString stringWithFormat:@"(%d%@)", kGetVerifyCodeCDTime, @"s"] forState:UIControlStateDisabled];
		_btnVerify.enabled = YES;
		_nGetVerifyCodeCDTime = kGetVerifyCodeCDTime;
		self.tfPhoneNum.enabled = YES;
	}
}

//重置定时器和发送验证码
- (void)resetTimerAndVerifyCodeBtn
{
    [_timerForGetVerifyCodeCD invalidate];
    _timerForGetVerifyCodeCD = NULL;
    _nGetVerifyCodeCDTime = kGetVerifyCodeCDTime;
    
    [_btnVerify setTitle:@"重新验证" forState:UIControlStateNormal];
    [_btnVerify setTitle:@"验证" forState:UIControlStateDisabled];
    _btnVerify.enabled = YES;
    _btnVerify.backgroundColor = kBlueColor;
    
    self.tfPhoneNum.enabled  = YES;

}

#pragma mark - 网络请求


/**
 *  向MobSDK获取手机验证码
 */
- (void)getVerifyCode
{
	[SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
							phoneNumber:self.tfPhoneNum.text
								   zone:@"86"
                               customIdentifier:nil //自定义短信模板标识
								 result:^(NSError *error)
	{
		if (!error)
		{
			postHUDTips([NSString stringWithFormat:@"验证码已经发送到%@的手机", _tfPhoneNum.text], self.view);
            
            [[YHVerifyCodeManager shareInstance] storageRPLoginVCDate];
		}
		else
		{
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"获取验证码失败"
															message:[NSString stringWithFormat:@"%@", [error.userInfo objectForKey:@"getVerificationCode"]]
														   delegate:nil
												  cancelButtonTitle:@"确定"
												  otherButtonTitles:nil, nil];
			[alert show];
		}
	}];
}

//登录
- (void)requestLoginWithPhoneNum:(NSString *)phoneNum passwd:(NSString *)passwd
{
	__weak typeof(self) weakSelf = self;

	[[YHNetManager sharedInstance] postLoginWithPhoneNum:phoneNum passwd:passwd complete:^(BOOL success, id obj) {
		[weakSelf.loginLoading hide:YES];

		if (success)
		{
            
            [YHError sharedInstance].verifyCodeErrorCount = 0;
            
	        //0.提示
			postHUDTips(@"登录成功", weakSelf.view);
            
	        //1.更新用户偏好设置信息
			[[YHUserInfoManager sharedInstance] loginSuccessWithUserInfo:obj];

	        //2.0.5秒后跳转到工作圈
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
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
                    postTips(msg, @"登录失败");
                }
  
                
            }
            else
            {
                //AFN请求失败的错误描述
                postTips(obj, @"登录失败");
            }

		}
	}];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	[self.view endEditing:YES];
}

/*
 * #pragma mark - Navigation
 *
 *  // In a storyboard-based application, you will often want to do a little preparation before navigation
 *  - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 *   // Get the new view controller using [segue destinationViewController].
 *   // Pass the selected object to the new view controller.
 *  }
 */

@end
