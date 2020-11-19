//
//  UINavigationBar+CustomStyle.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/14.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (CustomStyle)

/** 设置背景色 */
- (void)at_setBackgroundColor:(UIColor *)backgroundColor;

/** 设置线条颜色 */
- (void)at_setBottomLineColor:(UIColor *)color;

/** 设置背景图片 */
- (void)at_setBackgroundImage:(UIColor *)backgroundImage;

/** 设置线条图片 */
- (void)at_setBottomLineImage:(UIImage *)image;

/** 设置内容透明度 */
- (void)at_setContentAlpha:(CGFloat)alpha;

/** 设置线条透明度 */
- (void)at_setBottomLineAlpha:(CGFloat)alpha;

/** 设置字体样式 */
- (void)at_setNavigationtitleTextAttributes:(NSDictionary *)AttributeDic;

@end
