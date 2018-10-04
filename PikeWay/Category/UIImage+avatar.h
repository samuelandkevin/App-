//
//  UIImage+avatar.h
//  PikeWay
//
//  Created by YHIOS002 on 16/4/30.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (avatar)

/**
 *  圆角头像
 *
 *  @param radius 角度半径
 *
 *  @return UIImage图片
 */
- (UIImage *)imageWithCornerRadius:(CGFloat)radius;
@end
