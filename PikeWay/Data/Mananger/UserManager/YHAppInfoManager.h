//
//  YHAppInfo.h
//  PikeWay
//
//  Created by YHIOS002 on 16/12/2.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(int,AppPage){
    AppPage_Other = 0,     //其他页面
    AppPage_ChatDetail,    //聊天详情页
};

@interface YHAppInfoManager : NSObject

@property (nonatomic, assign)BOOL canOpenSideMenu;//可以打开侧边栏
@property (nonatomic, copy)  NSString *userAgent;
@property (nonatomic, assign)BOOL webCacheUseURLProtocol;//网页缓存使用协议加载（默认是使用NSURLCache加载）
@property (nonatomic, assign)BOOL reviewPass;
@property (nonatomic, assign)AppPage appPage;//app在页面的位置
@property (nonatomic, copy)  NSString *sessionUserId;//正在会话的用户Id

+ (instancetype)shareInstanced;


- (void)canOpenSideMenu:(void(^)(BOOL canOpen,id obj))complete;

- (void)reviewStatus:(void(^)(BOOL pass))complete;

@end
