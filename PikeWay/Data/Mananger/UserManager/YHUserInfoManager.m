//
//  YHUserInfoManager.m
//  PikeWay
//
//  Created by kun on 16/4/25.
//  Copyright © 2016年 YHSoft. All rights reserved.
//  用户信息管理

#import "YHUserInfoManager.h"
#import "YHNetManager+Login.h"
#import "FMDatabase.h"
#import "FMDatabaseQueue.h"
#import "YHNetManager.h"
//#import "JPUSHService.h"
#import "YHCacheManager.h"
#import "YHNetManager.h"
#import "YHAppInfoManager.h"
#import "SqlManager.h"
#import "STMURLCache.h"
#import "YHNetManager+Profile.h"

//令牌有效时长
static long const tokenValidDuration = 3600 * 24 * 30; //一个月

//检查数据库操作是否失败
#define YHDBCheckIfErr(x)													\
	do {																	\
		BOOL __err = x;														\
		if (!__err)															\
		{																	\
			DErrLog(@"数据库 err %d, %@", [db lastErrorCode], [db lastError]);	\
		}																	\
	} while (0)

@interface YHUserInfoManager ()

@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation YHUserInfoManager

- (instancetype)init
{
	self = [super init];

	if (!self)
	{
		return nil;
	}

	return self;
}

+ (instancetype)sharedInstance
{
	static YHUserInfoManager *g_ins = nil;
	static dispatch_once_t onceToken;

	dispatch_once(&onceToken, ^{
		g_ins = [YHUserInfoManager new];
	});
	return g_ins;
}

#pragma mark - Getter
- (YHUserInfo *)userInfo
{
	if (!_userInfo)
	{
		_userInfo = [YHUserInfo new];
	}
	_userInfo.isSelfModel = YES;
	return _userInfo;
}

- (BOOL)bindQQSuccess{
   return  [[NSUserDefaults standardUserDefaults] boolForKey:@"bindQQSuccess"];
}

- (BOOL)bindSinaSuccess{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:@"bindSinaSuccess"];
}

- (BOOL)bindWechatSuccess{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:@"bindWechatSuccess"];
}

//- (NSArray<YHChatListModel *> *)chatListArray{
//    if (!_chatListArray) {
//        _chatListArray = [NSArray new];
//    }
//    return _chatListArray;
//}

#pragma mark - Setter
- (void)setBindQQSuccess:(BOOL)bindQQSuccess{
    [[NSUserDefaults standardUserDefaults] setBool:bindQQSuccess forKey:@"bindQQSuccess"];
}

- (void)setBindSinaSuccess:(BOOL)bindSinaSuccess{
    [[NSUserDefaults standardUserDefaults] setBool:bindSinaSuccess forKey:@"bindSinaSuccess"];
}

- (void)setBindWechatSuccess:(BOOL)bindWechatSuccess{
    [[NSUserDefaults standardUserDefaults] setBool:bindWechatSuccess forKey:@"bindWechatSuccess"];
}

#pragma mark - Private

//请求我的名片信息(备注：因为登录成功就返回uid,token,mobliePhone三个关键字段.请求名片详情从这里开始开始)
- (void)_requestMyCardDetail
{
	__weak typeof(self) weakSelf = self;

    [[YHNetManager sharedInstance] getMyCardDetailComplete:^(BOOL success, id obj) {
        if (success){
            
            DDLog(@"获取我的名片成功:%@", obj);
            
            //1.更新当前用户单例信息
            YHUserInfo *retObj = obj;
            retObj.companyInfo = weakSelf.userInfo.companyInfo;
            weakSelf.userInfo  = retObj;
            weakSelf.userInfo.companyID = [[NSUserDefaults standardUserDefaults] objectForKey:kEnterpriseId];
            
            if (weakSelf.userInfo.userName){
                
                [[NSUserDefaults standardUserDefaults] setObject:weakSelf.userInfo.userName forKey:IM_SendMessage_Name];
            }
            
            if (weakSelf.userInfo.avatarUrl){
                
                [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@", weakSelf.userInfo.avatarUrl] forKey:IM_SendMessage_AvatarUrlString];
            }
            
            weakSelf.userInfo.updateStatus = updateFinish;
            
            //2.更新数据库登录用户信息
            [[SqlManager sharedInstance] updateUserInfoWithItems:nil complete:^(BOOL success, id obj) {
                if (success) {
                    DDLog(@"更新数据库登录用户信息成功,%@",obj);
                }else{
                    DDLog(@"更新数据库登录用户信息失败,%@",obj);
                }
            }];
            
        }
        else
        {
            if (isNSDictionaryClass(obj)){
                //服务器返回的错误描述
                NSString *msg = obj[kRetMsg];
                
                postTips(msg, @"获取我的名片失败");
            }
            else{
                //AFN请求失败的错误描述
                postTips(obj, @"获取我的名片失败");
            }
            
            weakSelf.userInfo.updateStatus = updateFailure;
            
        }
    }];


    
}

//从UserDefaults中清除登录信息
- (void)_clearLoginInfoFromUserDefaults{
    //1.清除“已登录”标志
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginOAuth];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kTaxAccount];
    [[NSUserDefaults standardUserDefaults] setObject:@(0) forKey:kAccessTokenDate];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kAccessToken];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kUserUid];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kEnterpriseId];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:kVerificationCode_WrongCount];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IM_SendMessage_Name];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:IM_SendMessage_AvatarUrlString];
}

//从社交平台中解除授权信息
- (void)_clearAuthFromSocialPlatFrom{
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_Sina completion:^(id result, NSError *error){
        DDLog(@"ret %@", result);
    }];
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_QQ completion:^(id result, NSError *error){
        DDLog(@"ret %@", result);
    }];
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatSession completion:^(id result, NSError *error){
        DDLog(@"ret %@", result);
    }];
    
    [[UMSocialManager defaultManager] cancelAuthWithPlatform:UMSocialPlatformType_WechatTimeLine completion:^(id result, NSError *error){
        DDLog(@"ret %@", result);
    }];
}

#pragma mark - Pubic
//是否已有用户登录过
- (BOOL)hasLoggedin
{
	return [[NSUserDefaults standardUserDefaults] boolForKey:kLoginOAuth];
}

//登录成功
- (void)loginSuccessWithUserInfo:(YHUserInfo *)userInfo
{
	//1.更新当前用户单例信息
	self.userInfo = userInfo;
	self.isHandleringTokenExpried = NO;
  
	//2.更新用户的偏好设置
	[self updateUserPreference:userInfo];

	//3.请求我的名片信息
	[self _requestMyCardDetail];
    

}


//处理Token失效
- (void)handleTokenUnavailable{
    //1.清除“已登录”标志
    [self _clearLoginInfoFromUserDefaults];
    
    //2.解除社交账号授权
    [self _clearAuthFromSocialPlatFrom];
    
    //3.清除用户单例信息
    _userInfo = nil;
    
    //4.清除消息角标
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    YHUnReadMsg *unRead = [YHUnReadMsg new];
//    [[YHIMHandler sharedInstance] setBadgeModelIfNeed:unRead];
}

//退出账号
- (void)logout
{
	//1.清除“已登录”标志
    [self _clearLoginInfoFromUserDefaults];

    
    //2.解除社交账号授权
    [self _clearAuthFromSocialPlatFrom];
    

	//3.登出清除全部聊天记录
	[[YHCacheManager shareInstance] clearCacheWhenLogout];
    [[SqlManager sharedInstance] clearCacheWhenLogout];
	[[NSUserDefaults standardUserDefaults] synchronize];
    
    //4.清除用户单例信息
    _userInfo = nil;
    
    //5.清除网页缓存
    //清网页URLCache缓存
    if([[NSURLCache sharedURLCache] isKindOfClass:[STMURLCache class]]){
        STMURLCache *sCache =  (STMURLCache *)[NSURLCache sharedURLCache];
        [sCache clearCache];
    }
    
    //清网页协议缓存
    if([YHAppInfoManager shareInstanced].webCacheUseURLProtocol){
        STMURLCacheModel *sModel = [STMURLCacheModel shareInstance];
        [sModel deleteCacheFolder];
    }
   
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
	//6.发出“账号退出”通知 (备注：放在最后)
	[[NSNotificationCenter defaultCenter] postNotificationName:Event_Logout object:nil];

	
}

//验证令牌是否有效
- (void)valideUserTokenComplete:(void (^)(BOOL isOK, id Obj))callback
{
	// 验证token是否有效
	[[YHNetManager sharedInstance] postValidateTokenWithUserInfo:self.userInfo complete:^(BOOL success, id obj) {
		if (success)
		{
			DDLog(@"Token 有效,可以继续使用");
			callback(YES, @"Token 有效,可以继续使用");
		}
		else
		{
			if (isNSDictionaryClass(obj))
			{
	            //服务器返回的错误描述
				[[NSUserDefaults standardUserDefaults] setBool:NO forKey:kLoginOAuth];
				[[NSUserDefaults standardUserDefaults] synchronize];
				callback(NO, obj);
			}
			else
			{
	            //AFN请求失败的错误描述
				callback(NO, obj);
			}
		}
	}];
}

//是否完善个人信息
- (BOOL)hasCompleteUserInfo
{
	if (!self.userInfo.company.length || !self.userInfo.userName.length || !self.userInfo.job.length || !self.userInfo.industry.length)
	{
		return NO;
	}
	return YES;
}

- (void)checkUpdate
{
	[[YHNetManager sharedInstance] postCheckUpdateComplete:^(BOOL success, id obj) {
		if (success)
		{
			if (isNSDictionaryClass(obj))
			{
				NSDictionary *dictObj = obj;
				NSInteger newVersionNum = [dictObj[@"versionNumber"] integerValue];
				NSString *upgradeLog = dictObj[@"upgradeLog"];
				NSString *upgradeUrlStr = dictObj[@"downloadUrl"];

                NSURL *upgradeUrl;
                if (upgradeUrlStr) {
                    upgradeUrl = [NSURL URLWithString:upgradeUrlStr];
                }

				if (upgradeUrl)
				{
					NSString *title = [NSString stringWithFormat:@"发现新版本 %ld", (long)newVersionNum];
                    //kun调试
//                    [YHAlertView showWithTitle:title message:upgradeLog cancelButtonTitle:@"以后再说" otherButtonTitle:@"前往更新" clickButtonBlock:^(YHAlertView * _Nonnull alertView, NSInteger buttonIndex) {
//                        if (buttonIndex == 1)
//                        {
//                            [[UIApplication sharedApplication] openURL:upgradeUrl];
//                        }
//                    }];
//					[YHUtils showAlertWithTitle:title message:upgradeLog okTitle:@"前往更新" cancelTitle:@"以后再说" inViewController:[UIApplication sharedApplication].keyWindow.rootViewController dismiss:^(BOOL resultYes) {
//						if (resultYes)
//						{
//							[[UIApplication sharedApplication] openURL:upgradeUrl];
//						}
//					}];
				}
			}
			else
			{
				DDLog(@"%@", obj);
			}
		}
		else
		{
			if (isNSDictionaryClass(obj))
			{
	            //服务器报错
				NSString *msg = obj[kRetMsg];
				postTips(msg, @"检查更新失败");
			}
			else
			{
	            //AFN请求失败
				DDLog(@"检查更新失败:%@", obj);
			}
		}
	}];
}




- (void)getAppBaseInfoComplete:(NetManagerCallback)complete
{
//    WeakSelf
//    [[YHNetManager sharedInstance] getAboutComplete:^(BOOL success, id obj)
//    {
//        if (success)
//        {
//            DDLog(@"获取关于内容成功：%@", obj);
//            NSDictionary *baseInfo = obj[@"base_info"];
//
//            //1.保存网页时间戳,(若不相同就重新从服务器获取网页数据)
//            float webCacheTimestamp  = [baseInfo[@"timestamp"] floatValue];
//            float localTimestamp     = [[NSUserDefaults standardUserDefaults] floatForKey:kWebCacheTimestamp];
//            if (webCacheTimestamp != localTimestamp) {
//                //清除网页缓存
//                if([[NSURLCache sharedURLCache] isKindOfClass:[STMURLCache class]]){
//                    STMURLCache *sCache = (STMURLCache *)[NSURLCache sharedURLCache];
//                    [sCache clearCache];
//                }
//            }
//            [[NSUserDefaults standardUserDefaults] setFloat:webCacheTimestamp forKey:kWebCacheTimestamp];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//
//            //2.公司网页 和 关于我们
//            weakSelf.companyWeb    = baseInfo[@"website"];
//            weakSelf.aboutArray    = obj[@"features"];
//        }
//        else
//        {
//            if (isNSDictionaryClass(obj))
//            {
//                //服务器返回的错误描述
//                NSString *msg = obj[kRetMsg];
//
//                postTips(msg, @"获取关于内容失败");
//            }
//            else
//            {
//                //AFN请求失败的错误描述
//                postTips(obj, @"获取关于内容失败");
//            }
//        }
//
//        complete(success, obj);
//    }];
}

//提交启动日志
- (void)commitBootLoggingComplete:(void(^)(BOOL success,id obj))complete{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[YHNetManager sharedInstance] postCommitBootLoggingComplete:^(BOOL success, id obj) {
            if(success){
                DDLog(@"提交启动日志成功:%@",obj);
            }else{
                DDLog(@"提交启动日志失败:%@",obj);
            }
        }];
    });
    
   
}


//直接登录
- (void)loginDirectly
{
	//1.取出本地的uid,token
	NSString *uid = [[NSUserDefaults standardUserDefaults] stringForKey:kUserUid];
    NSString *enterpriseId = [[NSUserDefaults standardUserDefaults] stringForKey:kEnterpriseId];
	NSString *accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:kAccessToken];
	NSString *mobilePhone = [[NSUserDefaults standardUserDefaults] stringForKey:kMobilePhone];
    DDLog(@"*******直接登录时**********\n uid=%@;\n accessToken=%@;\n mobilePhone=%@;",uid,accessToken,mobilePhone);
    
	//2.赋值用户信息单例
	self.userInfo.uid = uid;
	self.userInfo.accessToken = accessToken;
	self.userInfo.mobilephone = mobilePhone;
    self.userInfo.isRegister  = YES;
    self.userInfo.companyID   = enterpriseId;
    
    //kun调试
//    [JPUSHService setTags:nil alias:accessToken fetchCompletionHandle:^(int iResCode, NSSet *iTags, NSString *iAlias) {
//        DDLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, iTags, iAlias);
//    }];


    WeakSelf
	[self isTokenValideComplete:^(BOOL tokenValid) {
		if (tokenValid){
            
			[weakSelf checkUpdate];
			[weakSelf getAppBaseInfoComplete:^(BOOL isOK, id obj) {}];
            
//			BOOL isAutoLogin = [EMClient sharedClient].options.isAutoLogin;
//
//			if (!isAutoLogin)
//			{
//				NSString *password = [uid stringByAppendingString:IM_Login_Key];
//				password = [YHUtils md5HexDigest:password];
//				NSString *newuid = [uid stringByReplacingOccurrencesOfString:@"-" withString:@""];
//				[LoginManager doLoginWithTheUserName:newuid andThePassword:password];
//			}
            
        }
        
		else{
            
			[[NSNotificationCenter defaultCenter] postNotificationName:Event_Token_Unavailable object:nil];
		}
	}];
    
    
    //从DB中获取账号信息
    [[SqlManager sharedInstance] getLoginUserInfoWithUid:uid complete:^(BOOL success, id obj) {
        
        if (success) {
            weakSelf.userInfo = obj;
            weakSelf.userInfo.isRegister = YES;
            weakSelf.userInfo.updateStatus = updateFinish;//发通知,用户信息更新成功
            weakSelf.userInfo.companyID     = enterpriseId;
        }else{
            DDLog(@"can not find login userInfo from DB");
            [self _requestMyCardDetail];
        }
        
    }];
    
//    //从DB中获取聊天列表
//    [[SqlManager sharedInstance] queryChatListTableWithUserInfo:nil fuzzyUserInfo:nil complete:^(BOOL success, id obj) {
//        if (success) {
//            DDLog(@"%@",obj);
//            NSArray *retObj = obj;
//            if (retObj.count) {
//                weakSelf.chatListArray = retObj;
//            }else{
//
//                //没有缓存就去服务器请求
//                [[YHNetManager sharedInstance] postFetchChatListWithTimestamp:nil type:QChatType_All complete:^(BOOL success, id obj) {
//                    if (success) {
//                        NSArray *retObj = obj;
//                        if (retObj.count) {
//                            //数据写入缓存
//                            [[SqlManager sharedInstance] updateChatListModelArr:obj uid:[YHUserInfoManager sharedInstance].userInfo.uid complete:^(BOOL success, id obj) {
//                                if (success) {
//                                    DDLog(@"更新聊天列表数据成功,%@",obj);
//                                }else{
//                                    DDLog(@"更新聊天列表数据失败,%@",obj);
//                                }
//                            }];
//                        }
//
//                    }else{
//                        DDLog(@"请求聊天列表失败,%@",obj);
//                    }
//                }];
//            }
//    }}];

}

- (BOOL)isTokenExpired
{
	//取出
	NSInteger ts = [[NSUserDefaults standardUserDefaults] integerForKey:kAccessTokenDate];

	if (ts == 0)
	{
		ts = [[NSDate date] timeIntervalSince1970];
		[[NSUserDefaults standardUserDefaults] setObject:@(ts) forKey:kAccessTokenDate];
	}

	//旧时间日期
	NSDate *oDate = [NSDate dateWithTimeIntervalSince1970:ts];
	//时间间隔
	NSTimeInterval distance = [[NSDate date] timeIntervalSinceDate:oDate];

	if (distance > tokenValidDuration)
	{
		return YES;
	}
	return NO;
}


- (void)isTokenValideComplete:(void (^)(BOOL))complete
{
	//1.判断token是否过期,是就重新登录
	if ([self isTokenExpired])
	{
		complete(NO);
		return;
	}

	//2.token是否有效
	[self valideUserTokenComplete:^(BOOL success, id obj) {
		if ([obj isKindOfClass:[NSError class]]){
	        //网络错误不算是token失效,让用户登录进去
			complete(YES);
		}
		else{
			complete(success);
		}
	}];
}

#pragma mark - Private

/**
 *  更新用户的偏好设置
 *
 *  @param userInfo 用户Model
 */
- (void)updateUserPreference:(YHUserInfo *)userInfo
{
	//1.条件判断
	if (!userInfo.uid)
	{
		userInfo.uid = @"0";
	}

	if (!userInfo.accessToken)
	{
		userInfo.accessToken = @"";
	}

	if (!userInfo.mobilephone)
	{
		userInfo.mobilephone = @"";
	}

	//2.进行保存操作
	//保存“手机”
	[[NSUserDefaults standardUserDefaults] setObject:userInfo.mobilephone forKey:kMobilePhone];
	//保存"已登录标记"
	[[NSUserDefaults standardUserDefaults] setBool:YES forKey:kLoginOAuth];
	//保存“用户Id”
	[[NSUserDefaults standardUserDefaults] setObject:userInfo.uid forKey:kUserUid];
    //保存"企业用户ID"
    [[NSUserDefaults standardUserDefaults] setObject:userInfo.companyID forKey:kEnterpriseId];
	//保存“令牌”
	[[NSUserDefaults standardUserDefaults] setObject:userInfo.accessToken forKey:kAccessToken];
	//保存“token登录时间点”
	NSInteger ts = [[NSDate date] timeIntervalSince1970];
	[[NSUserDefaults standardUserDefaults] setObject:@(ts) forKey:kAccessTokenDate];
	[[NSUserDefaults standardUserDefaults] synchronize];
}




@end
