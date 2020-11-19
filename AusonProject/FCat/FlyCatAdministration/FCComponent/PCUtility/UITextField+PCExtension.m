
//
//  UITextField+PCExtension.m
//  PurCowExchange
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UITextField+PCExtension.h"
#import "UIFont+Extension.h"
#import "PCStyleDefinition.h"

@implementation UITextField (PCExtension)

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder fontSize:(float)fontSize textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor bgColor:(UIColor *)bgcolor{
    
    UITextField *textField = [[UITextField alloc] init];
    textField.leftViewMode =  UITextFieldViewModeAlways;
    textField.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 0)];
    textField.font = [UIFont font_customTypeSize:fontSize];
    textField.textColor = textColor;
    textField.placeholder = placeholder;
    textField.layer.borderColor = borderColor.CGColor;
    textField.backgroundColor = bgcolor;
    
    return textField;
}


@end
