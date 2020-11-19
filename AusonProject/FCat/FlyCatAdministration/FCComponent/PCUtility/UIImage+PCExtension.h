//
//  UIImage+PCExtension.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/14.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PCExtension)

/** 颜色转为图片 */
+ (UIImage *)at_imageWithColor:(UIColor *)color withSize:(CGSize)size;

/** 获取 APP 启动图 */
+ (UIImage *)at_launchImageForOrientation:(UIDeviceOrientation)orientation;

/** 获取 APP Logo */
+ (UIImage *)at_APPLocalIcon;

+ (UIImage *)screenShotView:(UIView *)view;

@end
