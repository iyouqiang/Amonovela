//
//  UIFont+Extension.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/25.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UIFont+Extension.h"

@implementation UIFont (Extension)

+ (UIFont *)font_customTypeSize:(CGFloat)size
{
    if (@available(iOS 9.0, *)) {
     
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
    }else {
        return [UIFont systemFontOfSize:size];
    }
}

+ (UIFont *)font_mediumTypeSize:(CGFloat)size
{
    if (@available(iOS 9.0, *)) {
        
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
    }else {
        return [UIFont boldSystemFontOfSize:size];
    }
    
}

@end
