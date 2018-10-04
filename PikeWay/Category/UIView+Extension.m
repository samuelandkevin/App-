//
//  UIView+Extension.m
//  PikeWay
//
//  Created by YHIOS002 on 2017/7/15.
//  Copyright © 2017年 YHSoft. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)

- (void)removeAllSubviews {
    //[self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    while (self.subviews.count) {
        [self.subviews.lastObject removeFromSuperview];
    }
}

@end
