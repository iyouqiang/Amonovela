//
//  UIFont+Extension.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/25.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIFont (Extension)

/// 因为数字字体
+ (UIFont *)font_DINProBoldTypeSize:(CGFloat)size;

/// 中文字体
+ (UIFont *)font_PingFangSCTypeSize:(CGFloat)size;

+ (UIFont *)font_mediumTypeSize:(CGFloat)size;

@end
