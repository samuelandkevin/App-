//
//  YHConfig.h
//  PikeWay
//
//  Created by YHIOS002 on 16/4/22.
//  Copyright © 2016年 YHSoft. All rights reserved.
//  配置文件

#import <Foundation/Foundation.h>

@interface YHConfig : NSObject

extern const int   kDynamciTextMaxLength;   //发动态长度
extern const int   lengthForEveryRequest;   //每次请求n条
extern const int   kVerifyCodeValidDuration;//验证码有效时长
extern NSString * const kUmengAppkey;
extern NSString * const kWXAppId;
extern NSString * const kBMKAppId;

/**
 * 配置启动选项
 */
void configLaunchOptions(void);
/**
 *  配置所有SDK
 */
void configAllThirdSDK(void);
/**
 *  配置MobSDK
 */
void configMobSDK(void);
/**
 *  配置友盟SDK
 */
void configUmengSDK(void);
/**
 *  配置SDWebImage
 */
void configSDWebImage(void);
/**
 *  配置微信SDK
 */
void configWXSDK(void);
/**
 *  配置百度地图SDK
 */
void configBMK(void);
/**
 *  配置系统字体
 */
void configSysFont(void);

/**
 * 配置网页缓存(离线缓存+加载缓存)
 */
void configWebViewCache(void);
@end
