//
//  YHThirdPModel.m
//  PikeWay
//
//  Created by YHIOS002 on 16/8/24.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import "YHThirdPModel.h"
#import <objc/runtime.h>
#import "YHSerializeKit.h"

@implementation YHThirdPModel

- (instancetype)initWithsnsAccount:(UMSocialUserInfoResponse *)snsAccount{
    if (self = [super init]) {

        _platformType = snsAccount.platformType;
        _userName     = snsAccount.name;
        _usid         = snsAccount.uid;
        _iconURL      = snsAccount.iconurl;
    }
    return self;
}

YHSERIALIZE_CODER_DECODER();

YHSERIALIZE_COPY_WITH_ZONE();
@end
