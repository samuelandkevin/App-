//
//  YHSetPasswd.h
//  PikeWay
//
//  Created by YHIOS002 on 16/8/23.
//  Copyright © 2016年 YHSoft. All rights reserved.
//  设置密码

#import <UIKit/UIKit.h>

typedef void(^OnSureBlock)(NSString *passwd);

@interface YHSetPasswd : UIView

- (void)show;
- (void)onSureBlock:(OnSureBlock)sureBlock;
@end
