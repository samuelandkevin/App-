//
//  UIImage+YHCompress.h
//  PikeWay
//
//  Created by kun on 2018/5/9.
//  Copyright © 2018年 YHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (YHCompress)
/*
 *  压缩图片方法(先压缩质量再压缩尺寸)
 */
-(NSData *)compressWithLengthLimit:(NSUInteger)maxLength;
/*
 *  压缩图片方法(压缩质量)
 */
-(NSData *)compressQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩质量二分法)
 */
-(NSData *)compressMidQualityWithLengthLimit:(NSInteger)maxLength;
/*
 *  压缩图片方法(压缩尺寸)
 */
-(NSData *)compressBySizeWithLengthLimit:(NSUInteger)maxLength;
@end
