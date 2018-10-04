//
//  YHTipsView.h
//  PikeWay
//
//  Created by YHIOS002 on 16/6/14.
//  Copyright © 2016年 YHSoft. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface YHTipsView : UIView

@property (nonatomic,strong) NSString *tips;

- (void)showTouchHide:(BOOL)touchHide msg:(NSString *)msg;

@end
