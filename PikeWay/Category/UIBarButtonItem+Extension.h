//
//  UIBarButtonItem+Extension.h
//  PikeWay
//
//  Created by kun on 2018/10/3.
//  Copyright © 2018年 yhsoft. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (Extension)
/*
 *默认的左返回按钮
 */
+ (UIBarButtonItem *)backItemWithTarget:(id)target selector:(SEL)selector;

/**********UIBarButtonItem为文字的设置**********/
+ (UIBarButtonItem *)leftItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)leftItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector block:(void(^)(UIButton *btn))block;

+ (UIBarButtonItem *)rightItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector;
+ (UIBarButtonItem *)rightItemWithTitle:(NSString *)title target:(id)target selector:(SEL)selector block:(void(^)(UIButton *btn))block;


/**********UIBarButtonItem为图片的设置**********/
/*
 *通用leftBarItem imgName:图片名 target:目标对象 selector:相应方法
 */
+ (UIBarButtonItem *)leftItemWithImgName:(NSString *)imgName target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)leftItemWithImgName:(NSString *)imgName target:(id)target selector:(SEL)selector block:(void(^)(UIButton *btn))block;

/*
 *通用rightBarItem imgName:图片名 target:目标对象 selector:相应方法
 */
+ (UIBarButtonItem *)rightItemWithImgName:(NSString *)imgName target:(id)target selector:(SEL)selector;

+ (UIBarButtonItem *)rightItemWithImgName:(NSString *)imgName target:(id)target selector:(SEL)selector block:(void(^)(UIButton *btn))block;

@end

NS_ASSUME_NONNULL_END
