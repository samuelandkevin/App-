//
//  UILabel+Extension.m
//  PikeWay
//
//  Created by kun on 2018/10/3.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import "UILabel+Extension.h"
#import <UIKit/UIKit.h>


@implementation UILabel (Extension)

+ (UILabel *)getTitleViewWithTitle:(NSString *)title{
    NSUInteger kBarTitleTag = 100001;
    //设置导航栏标题颜色
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:0.871 alpha:1.000];
    shadow.shadowOffset =  CGSizeMake(0.5, 0.5);
    NSDictionary *attributes =@{ NSForegroundColorAttributeName:[UIColor whiteColor],
                                 NSFontAttributeName:[UIFont systemFontOfSize:18],
                                 NSShadowAttributeName:shadow
                                 };
    
    NSString *aTitle = @"";
    if (title) {
        aTitle = title;
    }
    NSAttributedString *aString = [[NSAttributedString alloc] initWithString:aTitle attributes:attributes];
    
    UILabel *v = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-160, 30)];
    v.tag = kBarTitleTag;
    v.textColor = [UIColor whiteColor];
    v.attributedText =  aString;
    v.textAlignment  = NSTextAlignmentCenter;
    v.text = title;
    return v;
}

@end
