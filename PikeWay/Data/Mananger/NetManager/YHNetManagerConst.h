//
//  YHNetManagerConst.h
//  PikeWay
//
//  Created by kun on 2018/10/3.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSuccessCode 999  //请求成功状态码
#define iOSPlatform @(1) //iOS平台
#define kParseError  @"cannot parse data -3840"
#define kReqTimeOutInterval 20    //请求超时时间
#define kServerReturnEmptyData @"返回空数据" //服务器返回空数据
#define kNetWorkFailTips            @"网络链接失败,请检查网络设置"   //断网提示
#define kNetWorkReqTimeOutTips      @"请求超时,请稍后重试"         //请求超时提示

//回调时数据是否NSString类型
#define isNSStringClass(a, ret)\
{\
ret = ([(a) isKindOfClass:[NSString class]])?(a):(@" ");\
}

//所有公共服务的接口都必须传递 “app_id”:
#define TaxTaoAppId @"6f76a5fbf03a412ebc7ddb785d1a8b10"//税道APPId
#define kRequiedKeyAndValue @("app_id"):(TaxTaoAppId)


/**********枚举类型************/
typedef void(^NetManagerCallback)(BOOL success, id obj);
typedef NSURLSessionTask YHURLSessionTask;

/**
 *  上传进度回调
 *
 *  @param bytesWritten      已上传的大小
 *  @param totalBytesWritten 总上传大小
 */
typedef void (^YHUploadProgress)(int64_t bytesWritten,
                                 int64_t totalBytesWritten);

typedef NS_ENUM(NSInteger ,YHNetworkStatus){
    YHNetworkStatus_Unknown      = -1,
    YHNetworkStatus_NotReachable = 0,
    YHNetworkStatus_ReachableViewWWAN,
    YHNetworkStatus_ReachableViaWiFi
};
typedef void(^YHNetWorkStatusChange)(YHNetworkStatus status);
//登录的平台
typedef NS_ENUM(int,PlatformType){
    PlatformType_QQ,
    PlatformType_Wechat,
    PlatformType_Sina
};
