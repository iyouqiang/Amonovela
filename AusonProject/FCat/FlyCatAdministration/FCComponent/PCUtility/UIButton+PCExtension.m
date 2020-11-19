

//
//  UIButton+PCExtension.m
//  PurCowExchange
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UIButton+PCExtension.h"
#import "UIFont+Extension.h"

@implementation UIButton (PCExtension)

+ (UIButton *)butonWithImage:(NSString *)imageStr title:(NSString *)title titleFont:(float)titleFont titleColor:(UIColor *)titleColor bgColor:(UIColor *)bgColor{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont font_customTypeSize:titleFont]];
    
    if (imageStr.length > 0) {
        [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    }
    
    [button setBackgroundColor:bgColor];
    
    return button;
}


@end
