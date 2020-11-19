//
//  UITextField+PCExtension.h
//  PurCowExchange
//
//  Created by Frank on 2018/8/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (PCExtension)

+ (UITextField *)textFieldWithPlaceholder:(NSString *)placeholder fontSize:(float)fontSize textColor:(UIColor *)textColor borderColor:(UIColor *)borderColor bgColor:(UIColor *)bgcolor;


@end
