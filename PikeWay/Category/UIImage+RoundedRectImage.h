//
//  UIImage+RoundedRectImage.h
//  PikeWay
//
//  Created by YHIOS002 on 16/4/18.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (RoundedRectImage)

+ (UIImage *)createRoundedRectImage:(UIImage *)image withSize:(CGSize)size withRadius:(NSInteger)radius;

@end
