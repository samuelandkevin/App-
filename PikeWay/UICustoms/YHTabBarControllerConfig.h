//
//  YHTabBarControllerConfig.h
//  PikeWay
//
//  Created by kun on 2018/10/4.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"
NS_ASSUME_NONNULL_BEGIN

@interface YHTabBarControllerConfig : NSObject
@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;
@property (nonatomic, copy) NSString *context;
@end

NS_ASSUME_NONNULL_END
