//
//  YHActiveAccountViewController.h
//  PikeWay
//
//  Created by YHIOS002 on 16/8/9.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <UMSocialCore/UMSocialCore.h>
#import "YHNetManager.h"

@interface YHActiveAccountViewController : UIViewController

@property (strong,nonatomic) UMSocialUserInfoResponse *snsAccount;
@property (assign,nonatomic) PlatformType platform;
@end
