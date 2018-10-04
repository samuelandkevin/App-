//
//  YHUICommon.h
//  PikeWay
//
//  Created by kun on 2018/10/2.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

#ifndef YHUICommon_h
#define YHUICommon_h

#define kGreenColor kBlueColor                       //绿色主调
#define kBlueColor  RGB16(0x4290d7)                  //蓝色主调

#define kNavigationBarColor         [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1.0]                 // 51/255.0
#define kRankTop3LabelColor         [UIColor colorWithRed:253/255.0 green:81/255.0 blue:81/255.0 alpha:1.0];
#define kHHGrayUIColor(x)          [UIColor colorWithRed:x/255.0 green:x/255.0 blue:x/255.0 alpha:1.0]
#define RGB16(rgbValue)\
\
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 \
alpha:1.0]


#define KEYWINDOW [UIApplication sharedApplication].keyWindow
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define isiPad [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad

#ifdef __cplusplus
extern "C" {
#endif
    
#pragma mark - Public
    //显示提示,自动消失
    void postTips(id msg, NSString *title );
    //显示提示,点击才消失
    void postTipsTouchHide(id msg, NSString *title);
    
#pragma mark - Private
    void handleTips(id msg,NSString *title,BOOL touchHide);
    void showTips(id msg,BOOL touchHide);
    
    /**
     显示HUD的提示
     @param view 可以为nil,为nil时使用keywindow显示
     */
    void postHUDTips( NSString *msg ,UIView *view );
    void postHUDTipsWithHideDelay( NSString *msg ,UIView *view, float delay);
    void postHUDTipsWithImage( NSString *msg, UIView *view, UIImage *image );
    void postHUDTipsWithHideDelayAndImage( NSString *msg, UIView *view, float delay, UIImage *image );
    
    /** 显示一个activityIndicator下面一行字 不会消失*/
    id showHUDWithText( NSString *msg, UIView *view);
    /** 只显示一行字的HUD 不会消失*/
    id showHUDTextOnly( NSString *msg, UIView *view);
    
#ifdef __cplusplus
};
#endif

#endif
