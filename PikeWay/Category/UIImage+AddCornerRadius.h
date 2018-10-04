//
//  UIImage+AddCornerRadius.h
//  DotaSimulator
//
//  Created by lanou on 16/3/2.
//  Copyright © 2016年 莫锹文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AddCornerRadius)

- (nullable UIImage *)ds_imageWithCornerRadius:(CGFloat)radius;


- (nullable UIImage *)ds_imageWithCornerAngle:(CGFloat)radius;



/**
 Create and return a pure color image with the given color and size.
 
 @param color  The color.
 @param size   New image's type.
 */
+ (nullable UIImage *)imageWithColor:(nullable UIColor *)color size:(CGSize)size;

- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius;
- (nullable UIImage *)imageByRoundCornerRadius:(CGFloat)radius
                          borderWidth:(CGFloat)borderWidth
                          borderColor:(nullable UIColor *)borderColor;
@end
