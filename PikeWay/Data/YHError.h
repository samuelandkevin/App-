//
//  YHError.h
//  PikeWay
//
//  Created by kun on 2018/10/3.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 *  服务器返回的错误代码
 */
FOUNDATION_EXTERN const NSString *kErrorSystem ;                 //系统错误
FOUNDATION_EXTERN const NSString *kErrorParameters;              //参数错误
FOUNDATION_EXTERN const NSString *kErrorMissingParameter;        //缺少必要参数
FOUNDATION_EXTERN const NSString *kErrorUserAccontUnavailable;   //用账号无效
FOUNDATION_EXTERN const NSString *kErrorUserNameOrPasswd;        //用户名或密码错误
FOUNDATION_EXTERN const NSString *kErrorVerifyCode;              //验证码错误
FOUNDATION_EXTERN const NSString *kErrorRegisterFail;            //注册失败
FOUNDATION_EXTERN const NSString *kErrorPhoneNumExist;           //手机号已经存在
FOUNDATION_EXTERN const NSString *kErrorUserNameExist;           //用户名已经存在
FOUNDATION_EXTERN const NSString *kErrorOldPasswd;               //旧密码错误
FOUNDATION_EXTERN const NSString *kErrorAppisNotExist;           //应用不存在
FOUNDATION_EXTERN const NSString *kErrorDataDictisNotExist;      //数据字典不存在
FOUNDATION_EXTERN const NSString *kErrorRequest;                 //错误的请求
FOUNDATION_EXTERN const NSString *kErrorTokenUnavailable;        //token失效
FOUNDATION_EXTERN const NSString *kErrorApiIsNotExist;           //接口不存在
FOUNDATION_EXTERN const NSString *kErrorRequestMethod;           //请求方式错误（get/post）
FOUNDATION_EXTERN const NSString *kErrorMediaTypeUnsupport;      //不支持当前媒体类型
FOUNDATION_EXTERN const NSString *kErrorServerInteral;           //服务器内部错误

NS_ASSUME_NONNULL_BEGIN

@interface YHError : NSObject

+ (YHError *) sharedInstance;

@property(nonatomic,assign) int verifyCodeErrorCount; //验证码输入错误的次数
@property(nonatomic,assign) int  resetCodeErrorCount; //重置密码输错次数

@end

NS_ASSUME_NONNULL_END
