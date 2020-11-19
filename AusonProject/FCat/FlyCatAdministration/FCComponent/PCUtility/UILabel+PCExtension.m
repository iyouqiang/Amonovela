
//
//  UILabel+PCExtension.m
//  PurCowExchange
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UILabel+PCExtension.h"

@implementation UILabel (PCExtension)

+ (UILabel *)labelWithText:(NSString *)text textColor:(UIColor *)textColor fontSize:(float)fontSize bgColor:(UIColor *)bgColor{
    
    UILabel *label = [[UILabel alloc] init];
    label.textAlignment = NSTextAlignmentLeft;
    [label setText:text];
    [label setTextColor:textColor];
    [label setFont:[UIFont systemFontOfSize:fontSize]];
    [label setBackgroundColor:bgColor];
    
    return label;
}



@end
