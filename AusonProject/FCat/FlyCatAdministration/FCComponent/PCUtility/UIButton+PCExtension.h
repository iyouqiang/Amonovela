//
//  UIButton+PCExtension.h
//  PurCowExchange
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (PCExtension)

+ (UIButton *)butonWithImage:(NSString *)imageStr title:(NSString *)title titleFont:(float)titleFont titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor;

@end
