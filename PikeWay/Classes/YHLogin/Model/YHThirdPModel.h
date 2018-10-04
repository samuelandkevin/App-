//
//  YHThirdPModel.h
//  PikeWay
//
//  Created by YHIOS002 on 16/8/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//  第三方账号Model

#import <Foundation/Foundation.h>
#import <UMSocialCore/UMSocialCore.h>


@interface YHThirdPModel : NSObject<NSCopying>


/**
 微博平台名称,例如"sina"、"tencent",定义在`UMSocialSnsPlatformManager.h`
 */
@property (nonatomic, assign) UMSocialPlatformType platformType;

/**
 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 用户在微博的id号
 */
@property (nonatomic, copy) NSString *usid;

/**
 用户微博头像的url
 */
@property (nonatomic, copy) NSString *iconURL;


- (instancetype)initWithsnsAccount:(UMSocialUserInfoResponse *)snsAccount;
@end
