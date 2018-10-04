//
//  YHNetManager.h
//  PikeWay
//
//  Created by kun on 16/6/9.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHNetManager.h"
#import "YHUserInfo.h"

@interface YHNetManager (Login)


#pragma mark - 请求相应的接口
/**
 *  验证手机号码是否已注册
 *
 *  @param phoneNum 手机号码
 *  @param complete 结果回调
 */
- (void)getVerifyphoneNum:(NSString *)phoneNum complete:(NetManagerCallback)complete;

/**
 *  注册
 *
 *  @param phoneNum 手机号
 *  @param veriCode 验证码
 *  @param passwd   密码
 *  @param complete 结果回调
 */
- (void)postRegisterWithPhoneNum:(NSString *)phoneNum veriCode:(NSString *)veriCode passwd:(NSString *)passwd complete:(NetManagerCallback)complete;

/**
 *  验证token是否有效
 *
 *  @param userInfo 用户信息
 *  @param complete 结果回调
 */
- (void)postValidateTokenWithUserInfo:(YHUserInfo *)userInfo complete:(NetManagerCallback)complete;

/**
 *  登录
 *
 *  @param phoneNum 手机号
 *  @param passwd   密码 （方法内部已实现MD5加密）
 *  @param complete 成功失败回调
 */
- (void)postLoginWithPhoneNum:(NSString *)phoneNum passwd:(NSString *)passwd complete:(NetManagerCallback)complete;


/**
 *  短信验证码登录（忘记密码）
 *
 *  @param phoneNum   手机号
 *  @param verifyCode 验证码
 *  @param complete   成功失败回调
 */
- (void)postLoginWithPhoneNum:(NSString *)phoneNum verifyCode:(NSString *)verifyCode complete:(NetManagerCallback)complete;


/**
 *  重置密码后登录 （忘记密码）
 *
 *  @param phoneNum   手机号
 *  @param verifyCode 验证码
 *  @param newPasswd  新密码
 *  @param complete   成功失败回调
 */
- (void)postLoginWithPhoneNum:(NSString*)phoneNum verifyCode:(NSString *)verifyCode newPasswd:(NSString*)newPasswd complete:(NetManagerCallback)complete;

/**
 *  退出登录
 *
 *  @param complete 成功失败回调
 */
- (void)postLogoutComplete:(NetManagerCallback)complete;

/**
 *  批量校验手机号是否已注册
 *
 *  @param phoneNums 手机号数组
 *  @param complete  成功失败回调
 */
- (void)postVerifyPhonesAreRegistered:(NSArray *)phoneNums complete:(NetManagerCallback)complete;

/**
 *  验证第三方账号登录是否有效
 *
 *  @param uid      第三方uid
 *  @param platform 平台类型
 *  @param complete 成功：直接登录.  失败：30002 第一次用此方式登录请绑定手机号
 */
- (void)postVerifyThirdPartyWithUid:(NSString *)uid platform:(PlatformType)platform complete:(NetManagerCallback)complete;

/**
 *  第三方账号登录绑定手机号
 *
 *  @param phone         手机号
 *  @param platform      平台类型
 *  @param thridPartyUid 第三方uid
 *  @param verifyCode    验证码
 *  @param complete      成功失败回调
 */
- (void)postBindPhone:(NSString *)phone platform:(PlatformType)platform thridPartyUid:(NSString *)thridPartyUid verifyCode:(NSString *)verifyCode complete:(NetManagerCallback)complete
;

/**
 *  第三方绑定手机后设置密码
 *
 *  @param passwd   密码
 *  @param complete 成功失败回调
 */
- (void)postThridPartyLoginAndSetPasswd:(NSString *)passwd complete:(NetManagerCallback)complete;

/**
 *  税道网页登录
 *
 *  @param QRCodeId 二维码的Id
 *  @param complete 成功失败回调
 */
- (void)postLoginByWebPage:(NSString *)QRCodeId complete:(NetManagerCallback)complete;


/**
 提交启动日志

 @param complete 成功失败回调
 */
- (void)postCommitBootLoggingComplete:(NetManagerCallback)complete;



/**
 财税+扫描登录

 @param QRCodeId 二维码的Id
 @param complete 成功失败回调
 */
- (void)postLoginByTaxQRCode:(NSString *)QRCodeId complete:(NetManagerCallback)complete;
@end
