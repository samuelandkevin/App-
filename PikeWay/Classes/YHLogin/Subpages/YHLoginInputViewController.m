//
//  YHLoginInputViewController.m
//  PikeWay
//
//  Created by YHIOS002 on 16/4/20.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHLoginInputViewController.h"
#import "YHRegisterByPhoneNumViewController.h"
#import "YHNetManager+Login.h"
#import "YHUserInfoManager.h"
#import "YHUtils.h"
#import "YHActionSheet.h"
#import "YHVerifyCodeLoginViewController.h"
#import "YHResetCodeLoginViewController.h"
#import "RegexKitLite.h"
#import "IQKeyboardManager.h"
#import "YHNetManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMSocialQQHandler.h"
#import "YHActiveAccountViewController.h"
#import "YHSetPasswd.h"
#import "YHThirdPModel.h"
#import "YHCacheManager.h"
#import "MBProgressHUD.h"
#import "YHAnimatedBtn.h"
#import "UIView+MyPosition.h"
#import "YHError.h"
#import "UIBarButtonItem+Extension.h"

@interface YHLoginInputViewController () <UITextFieldDelegate,UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *tfAccount; //账号
@property (weak, nonatomic) IBOutlet UITextField *tfPasswd;  //密码
@property (weak, nonatomic) IBOutlet UIButton *btnLogin;     //登录
@property (strong, nonatomic) YHAnimatedBtn *viewLogin;

@property (weak, nonatomic) IBOutlet UIView *viewContariner;
@property (weak, nonatomic) IBOutlet UIButton *btnRegister;
@property (weak, nonatomic) IBOutlet UIButton *btnForgetCode;

/*社交账号View*/
@property (weak, nonatomic) IBOutlet UIView *viewBottom;

@property (weak, nonatomic) IBOutlet UIButton *btnQQ;
@property (weak, nonatomic) IBOutlet UIButton *btnWechat;
@property (weak, nonatomic) IBOutlet UIButton *btnSina;
@property (weak, nonatomic) IBOutlet UILabel *labelQQ;
@property (weak, nonatomic) IBOutlet UILabel *labelWechat;
@property (weak, nonatomic) IBOutlet UILabel *labelSina;


@property (strong, nonatomic) MBProgressHUD *loginLoading; //登录Loading
@end

@implementation YHLoginInputViewController


- (void)viewDidLoad
{
	[super viewDidLoad];
	// Do any additional setup after loading the view from its nib.
   
	//1.initUI
	[self initUI];

	//2.监听通知
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
												 name:@"UITextFieldTextDidChangeNotification"
											   object:self.tfAccount];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFiledEditChanged:)
												 name:@"UITextFieldTextDidChangeNotification"
											   object:self.tfPasswd];
    

}

- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

#pragma mark - init

- (void)setupNavigationBar{
    self.title = @"登录";
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithTarget:self selector:@selector(onBack:)];
}

- (void)initUI
{
    [self setupNavigationBar];
    
	//输入容器边框颜色
	self.viewContariner.layer.borderColor = [UIColor colorWithRed:233 / 255.0 green:233 / 255.0 blue:233 / 255.0 alpha:1.0].CGColor;
	self.viewContariner.layer.borderWidth = 0.5;
	self.viewContariner.layer.cornerRadius = 1;
	self.viewContariner.layer.masksToBounds = YES;

	//设置输入框左视图
	UIView *leftViewPhone = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	self.tfAccount.leftView = leftViewPhone;
	self.tfAccount.leftViewMode = UITextFieldViewModeAlways;


    
	UIView *leftViewCode = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
	self.tfPasswd.leftView = leftViewCode;
	self.tfPasswd.leftViewMode = UITextFieldViewModeAlways;

	//登录按钮
//    self.btnLogin.hidden = NO;
	self.btnLogin.layer.cornerRadius = 3;
	self.btnLogin.layer.masksToBounds = YES;
	self.btnLogin.enabled = NO;
	self.btnLogin.backgroundColor = RGBCOLOR(196, 197, 198);

    _viewLogin = [[YHAnimatedBtn alloc] initWithFrame:CGRectMake(15, _viewContariner.bottom+30, SCREEN_WIDTH-30, 41)];
    _viewLogin.title = @"登录";
//    _viewLogin.hidden = YES;
    WeakSelf
    _viewLogin.onLoginBlock = ^(){
        [weakSelf onLogin:nil];
    };
    [self.view addSubview:_viewLogin];
    
    //立即注册
    [self.btnRegister setTitleColor:kBlueColor forState:UIControlStateNormal];
    
    //忘记密码
    [self.btnForgetCode setTitleColor:kBlueColor forState:UIControlStateNormal];
   
    //QQ
    BOOL isQQInstalled  = [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ];
    self.btnQQ.hidden   = isQQInstalled? NO:YES;
    self.labelQQ.hidden = isQQInstalled? NO:YES;
    
    //Sina
    
    //Wechat
    BOOL isWechatInstalled = NO;
    if([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]] || [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]){
        isWechatInstalled = YES;
    }
    self.btnWechat.hidden   = isWechatInstalled? NO:YES;
    self.labelWechat.hidden = isWechatInstalled? NO:YES;
    
    
    if (!isQQInstalled && !isWechatInstalled) {
        self.viewBottom.hidden = YES;
    }
    else
        self.viewBottom.hidden = NO;
    
    
    self.btnWechat.hidden   = YES;
    self.btnSina.hidden     = YES;
    self.labelWechat.hidden = YES;
    self.labelSina.hidden   = YES;
    
}

#pragma mark - Setter
- (MBProgressHUD *)loginLoading
{
	if (!_loginLoading)
	{
		_loginLoading = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
		_loginLoading.label.text = @"正在登录...";
		[self.navigationController.view addSubview:_loginLoading];
	}
	return _loginLoading;
}


#pragma mark - Action
- (IBAction)onBack:(id)sender {
   
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

//登录
- (IBAction)onLogin:(id)sender
{
	//手机账号格式
	if (!isValideTaxAccountFormat(self.tfAccount.text))
	{
//		postHUDTips(@"手机号或用户名不正确", self.view);
        postTips(@"手机号或用户名不正确", nil);
		return;
	}

	if (!isValidePassword(self.tfPasswd.text))
	{
//		postHUDTips(@"登录密码请输入6-20位数字或字符", self.view);
        postTips(@"登录密码请输入6-20位数字或字符",nil);
		return;
	}

	if ([YHNetManager sharedInstance].currentNetWorkStatus == YHNetworkStatus_NotReachable)
	{
//		postHUDTips(kNetWorkFailTips, self.view);
        postTips(kNetWorkFailTips,nil);
		return;
	}

	[self.view endEditing:YES];
	//2.显示Loading
//	[self.loginLoading show:YES];
    
    WeakSelf
    [self.viewLogin showLoadingComplete:^{
        
        [[YHNetManager sharedInstance] postLoginWithPhoneNum:weakSelf.tfAccount.text passwd:weakSelf.tfPasswd.text complete:^(BOOL success, id obj) {
            //取消Loading
            //		[weakSelf.loginLoading hide:YES];
            
            
            if (success)
            {
                [weakSelf.viewLogin hideLoading];
                
                DDLog(@"登录成功:%@", obj);
                YHUserInfo *userInfo = obj;
                
                NSString *uid = userInfo.uid;
                NSString *password = [uid stringByAppendingString:IM_Login_Key];
                password = [YHUtils md5HexDigest:password];
                uid = [uid stringByReplacingOccurrencesOfString:@"-" withString:@""];
                
                //0.提示
                //			postHUDTips(@"登录成功", self.view);
                
                //1.更新用户偏好设置信息
                [[YHUserInfoManager sharedInstance] loginSuccessWithUserInfo:obj];
                
                //2.跳转到首页
                [[NSNotificationCenter defaultCenter] postNotificationName:Event_Login_Success object:nil];
                [weakSelf.navigationController dismissViewControllerAnimated:YES completion:NULL];
                
            }
            else
            {
                [weakSelf.viewLogin reset];
                if (isNSDictionaryClass(obj))
                {
                    NSString *code = obj[kRetCode];
                    NSString *msg = obj[kRetMsg];
                    
                    if ([code isEqualToString:kErrorUserNameOrPasswd] || [code isEqualToString:kErrorUserAccontUnavailable])
                    {
                        postTips(@"手机号或税道账号和登录密码不匹配", @"");
                    }
                    else
                    {
                        postTips(msg, @"登录失败");
                    }
                }
                else
                {
                    postTips(obj, @"登录失败");
                }
            }
        }];
    }];
  
   

	

	//调试
//    //进入RootVC
//    [[NSNotificationCenter defaultCenter] postNotificationName:Event_EnterRootVC object:self userInfo:nil];
}

//忘记密码
- (IBAction)onForgetCode:(id)sender
{
	//1.收起键盘
	[self.view endEditing:YES];

	//2.显示选项
	__weak typeof(self) weakSelf = self;

	YHActionSheet *sheet = [[YHActionSheet alloc] initWithCancelTitle:@"取消" otherTitles:@[@"通过短信重置密码登录"]];

	[sheet show];
	[sheet dismissForCompletionHandle:^(NSInteger clickedIndex, BOOL isCancel) {
		if (!isCancel)
		{
			if (clickedIndex == 0)
			{
	            //点击“通过短信验证码登录”
//                YHVerifyCodeLoginViewController *vc = [[YHVerifyCodeLoginViewController alloc] init];
//                [weakSelf.navigationController pushViewController:vc animated:YES];
//            }
//            else{
	            //点击“通过短信重置密码登录”
				YHResetCodeLoginViewController *vc = [[YHResetCodeLoginViewController alloc] init];
				[weakSelf.navigationController pushViewController:vc animated:YES];
			}
		}
	}];
}

//立即注册
- (IBAction)onRegister:(id)sender
{
	YHRegisterByPhoneNumViewController *vc = [[YHRegisterByPhoneNumViewController alloc] init];

	[self.navigationController pushViewController:vc animated:YES];
}

//密码输入方式
- (IBAction)showPasswd:(UIButton *)sender
{
	sender.selected = !sender.selected;
	NSString *passwd = self.tfPasswd.text;
	self.tfPasswd.secureTextEntry = (sender.selected) ? NO : YES;
	self.tfPasswd.text = @" ";
	self.tfPasswd.text = passwd;
}

- (IBAction)onLoginByQQ:(id)sender {

    WeakSelf
    if ( [[UMSocialManager defaultManager] isInstall:UMSocialPlatformType_QQ] ){
       
       //读取缓存qq账号信息
       NSMutableDictionary *dictCache = [[YHCacheManager shareInstance] getCacheThirdPartyAccountDict];
       YHThirdPModel *model   = dictCache[@"qq"];
        
        if (!model) {
            //未授权
            
            [[UMSocialManager defaultManager] getUserInfoWithPlatform:UMSocialPlatformType_QQ currentViewController:weakSelf completion:^(id result, NSError *error) {
                NSString *message = nil;
                
                if(error){
                    message = @"Auth fail";
                    postTips(message, nil);
                }
                else{
                    if ([result isKindOfClass:[UMSocialUserInfoResponse class]]) {
                        UMSocialUserInfoResponse *resp = result;
                     
                        
                        // 第三方平台SDK源数据,具体内容视平台而定
                      DDLog(@"AuthOriginalResponse: %@", resp.originalResponse);
                        message = [NSString stringWithFormat:@"result: %d\n uid: %@\n accessToken: %@\n",(int)error.code,resp.uid,resp.accessToken];
                        [weakSelf _loginBysnsPlatform:resp];
                        
                    }
                    else{
                        DDLog(@"Auth fail with unknow error");
                        message = @"Auth fail";
                    }
                }
            }];
    
        }
        else{
            //已授权
            UMSocialUserInfoResponse *snsAccount = [UMSocialUserInfoResponse new];
            snsAccount.platformType = model.platformType;
            snsAccount.name     = model.userName;
            snsAccount.uid      = model.usid;
            snsAccount.iconurl  = model.iconURL;
            [self _loginBysnsPlatform:snsAccount];
        }

    }
    else {
        postTips(@"未安装QQ客户端",nil);
    }
    

}

- (IBAction)onLoginByWechat:(id)sender {
    
}

- (IBAction)onLoginBySina:(id)sender {
    
}



#pragma mark - Private

- (void)_loginBysnsPlatform:(UMSocialUserInfoResponse *)snsAccount{
    WeakSelf
    [MBProgressHUD showHUDAddedTo:kRootViewController.view animated:YES];
    [[YHNetManager sharedInstance] postVerifyThirdPartyWithUid:snsAccount.uid platform:PlatformType_QQ complete:^(BOOL success, id obj) {
        
        [MBProgressHUD hideHUDForView:kRootViewController.view animated:YES];
        
        if (success)
        {
            //验证成功直接登录
            DDLog(@"QQ登录成功:%@", obj);
            
            YHThirdPModel *model = [[YHThirdPModel alloc] initWithsnsAccount:snsAccount];
            [[YHCacheManager shareInstance] cacheThirdPartyAccount:model];
            
            YHUserInfo *userInfo = obj;
            NSString *uid = userInfo.uid;
            NSString *password = [uid stringByAppendingString:IM_Login_Key];
            password = [YHUtils md5HexDigest:password];
            uid = [uid stringByReplacingOccurrencesOfString:@"-" withString:@""];
            
            //0.提示
            postHUDTips(@"登录成功", self.view);
            
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
                
                if([obj[@"code"] intValue] == 30002)
                {
                   //第一次用此方式登录请绑定手机号
                     [self _goTobindPhonePageWithsnsAccount:snsAccount];
                }
                
            }
            else{
                postTips(obj, nil);
            }
        }
        
    }];
    
}

- (void)_goTobindPhonePageWithsnsAccount:(UMSocialUserInfoResponse*)snsAccount{
    YHActiveAccountViewController *vc = [[YHActiveAccountViewController alloc] init];
    vc.platform = PlatformType_QQ;
    vc.snsAccount = snsAccount;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - Life
- (void)viewDidAppear:(BOOL)animated
{
	// 设置账号
	NSString *strAccount = [[NSUserDefaults standardUserDefaults] objectForKey:kMobilePhone];

	if (strAccount && strAccount.length > 0)
	{
		_tfAccount.text = strAccount;
	}
    
	[super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	self.tfAccount.text = [[NSUserDefaults standardUserDefaults] objectForKey:kMobilePhone];

	//状态栏显示,从欢迎页跳进此页面显示
	[UIApplication sharedApplication].statusBarHidden = NO;
	[super viewWillAppear:animated];
    
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated
{

	[super viewWillDisappear:animated];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	DDLog(@"%s vc dealloc", __FUNCTION__);
}

#pragma mark - TextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
//	self.activeView = _btnLogin;
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == _tfAccount)
	{
		[_tfPasswd becomeFirstResponder];
	}
	else if (textField == _tfPasswd)
	{
		[_tfAccount resignFirstResponder];
		// 默认是登录操作
		[self onLogin:nil];
	}
	return YES;
}

#pragma mark - Keyboard Event

- (void)keyboardWasShown:(NSNotification *)aNotification
{}

- (void)keyboardWillBeHidden:(NSNotification *)aNotification
{}

#pragma mark - NSNotification

- (void)textFiledEditChanged:(NSNotification *)aNotifi
{
	if (!self.tfAccount.text.length || !self.tfPasswd.text.length)
	{
		self.btnLogin.enabled = NO;
		self.btnLogin.backgroundColor = RGBCOLOR(196, 197, 198);
        [_viewLogin setNormal];
	}
	else
	{
		self.btnLogin.enabled = YES;
		self.btnLogin.backgroundColor = kBlueColor;
        [_viewLogin setSelected];
	}
    
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
