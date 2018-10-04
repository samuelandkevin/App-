//
//  YHError.m
//  PikeWay
//
//  Created by kun on 2018/10/3.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import "YHError.h"

/**
 *  服务器返回的错误代码
 */
const NSString *kErrorSystem           = @"10001";      //系统错误
const NSString *kErrorParameters       = @"10002";      //参数错误
const NSString *kErrorMissingParameter = @"10003";      //缺少必要参数
const NSString *kErrorUserAccontUnavailable = @"20001"; //用账号无效
const NSString *kErrorUserNameOrPasswd = @"20002";      //用户名或密码错误
const NSString *kErrorVerifyCode       = @"20003";      //验证码错误
const NSString *kErrorRegisterFail     = @"20004";      //注册失败
const NSString *kErrorPhoneNumExist    = @"20005";      //手机号已经存在
const NSString *kErrorUserNameExist    = @"20006";      //用户名已经存在
const NSString *kErrorOldPasswd        = @"20007";      //旧密码错误
const NSString *kErrorAppisNotExist    = @"20008";      //应用不存在
const NSString *kErrorDataDictisNotExist = @"20009";    //数据字典不存在
const NSString *kErrorRequest          = @"40000";      //错误的请求
const NSString *kErrorTokenUnavailable = @"40001";      //token失效
const NSString *kErrorApiIsNotExist    = @"40004";      //接口不存在
const NSString *kErrorRequestMethod    = @"40005";      //请求方式错误（get/post）
const NSString *kErrorMediaTypeUnsupport = @"40015";    //不支持当前媒体类型
const NSString *kErrorServerInteral    = @"50001";      //服务器内部错误

@implementation YHError

+ (YHError*)sharedInstance {
    static YHError  *g_sharedInstance = nil;
    static dispatch_once_t pre = 0;
    dispatch_once(&pre, ^{
        g_sharedInstance = [[YHError alloc] init];
    });
    
    return g_sharedInstance;
}
@end
