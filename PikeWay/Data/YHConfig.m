//
//  YHConfig.m
//  PikeWay
//
//  Created by YHIOS002 on 16/4/22.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHConfig.h"
#import <SMS_SDK/SMSSDK.h>
#import "YHNetManager.h"
#import <UMSocialCore/UMSocialCore.h>
#import "UMMobClick/MobClick.h"
#import "WXApi.h"
#import "UIImageView+WebCache.h"
#import "STMURLCache.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import "YHAppInfoManager.h"


const int   kDynamciTextMaxLength             = 150; //发动态长度
const int   lengthForEveryRequest             = 20;  //每次请求n条
const int   kVerifyCodeValidDuration          = 120; //验证码有效时长
//Mob短信平台
NSString * const kMobAppKey                   = @"11f71aa828ed0";
NSString * const kMobAppSecret                = @"a64321f5ede1e37b5e2f47b070f4f272";
//友盟
NSString * const kUmengAppkey                 = @"58a575bb310c931f440006d1";//之前是：5735a329e0f55a1d170034ed

//微信开发平台
NSString * const kWXAppId = @"wxe8e8240e8bf2c3a3";
NSString * const kWXAppSecret = @"ae5ac01d111423d950d5d0a056fb8e0d";

//腾讯开放平台
NSString * const kQQAppId = @"1105361751";
NSString * const kQQAppSecret = @"U6BpxVgHIAjUKIu0";

//百度地图
NSString * const kBMKAppId = @"KwEeqnpDZu7kQfsUuY39xuNZkPpNGnu7";

#pragma mark - Public

void configLaunchOptions(){
    [[YHNetManager sharedInstance] startMonitoring];
    configWebViewCache();
    configSysFont();
}

void configAllThirdSDK(){
    configUmengSDK();
    configMobSDK();
    configSDWebImage();
    configWXSDK();
    configBMK();
}

void configMobSDK() {
    [SMSSDK registerApp:kMobAppKey withSecret:kMobAppSecret];
}

void configSDWebImage(){
    [[SDImageCache sharedImageCache] setMaxMemoryCountLimit:32];
    [[SDImageCache sharedImageCache] setMaxMemoryCost:8192000];
}

void configWXSDK(){
     [WXApi registerApp:kWXAppId ];
}

void configBMK(){
    // 要使用百度地图，请先启动BaiduMapManager
    BMKMapManager *mapManager = [[BMKMapManager alloc] init];
    // 如果要关注网络及授权验证事件，请设定     generalDelegate参数
    BOOL ret = [mapManager start:kBMKAppId  generalDelegate:nil];
    if (!ret){
        DDLog(@"BMKMapManager start failed!");
    }
    
}

void configUmengSDK() {
   
    //配置友盟统计
    UMConfigInstance.appKey    = kUmengAppkey;
    UMConfigInstance.channelId = @"App Store";
    UMConfigInstance.ePolicy   = BATCH;
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [MobClick setAppVersion:version];
    
    
//    [UMSocialLog hiddenNotInstallPlatforms:nil];
    

#ifdef HH_DEBUG
    [[UMSocialManager defaultManager] openLog:NO];
    [MobClick setLogEnabled:NO];
#else
    
#endif
    
    //设置友盟社会化组件appkey
    [[UMSocialManager defaultManager] setUmSocialAppkey:kUmengAppkey];

    //设置微信AppId、appSecret，分享url
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:kWXAppId appSecret:kWXAppSecret redirectURL:@"http://mobile.umeng.com/social"];

    
    //设置手机QQ 的AppId，Appkey，和分享URL，需要#import "UMSocialQQHandler.h"
     [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:kQQAppId  appSecret:nil redirectURL:@"http://www.umeng.com/social"];
    
    //设置新浪的appId和appKey
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    

}

void configEaseMobSDK(){

}

void configSysFont(){
//    [UILabel setupGlobalFont];
//    [UITextField setupGlobalFont];
}

void configWebViewCache(){
    //webView离线缓存
//    [NSURLProtocol registerClass:[RNCachingURLProtocol class]];
    //webView加载缓存
    
    NSString *whiteListStr = @"apps.gtax.cn|testapp.gtax.cn";
    NSMutableArray *whiteLists = [NSMutableArray arrayWithArray:[whiteListStr componentsSeparatedByString:@"|"]];
    NSString *userAgent  = [YHAppInfoManager shareInstanced].userAgent;
    BOOL useURLProtocol  = NO;
    NSUInteger cacheTime = 24*60*60;
    [YHAppInfoManager shareInstanced].webCacheUseURLProtocol = useURLProtocol;
    
    [STMURLCache create:^(STMURLCacheMk *mk) {
        mk.whiteListsHost(whiteLists).whiteUserAgent(userAgent).isUsingURLProtocol(useURLProtocol).cacheTime(cacheTime);
    }];
  
    
}
