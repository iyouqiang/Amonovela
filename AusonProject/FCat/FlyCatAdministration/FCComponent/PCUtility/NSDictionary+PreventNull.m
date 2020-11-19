//
//  NSDictionary+PreventNull.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "NSDictionary+PreventNull.h"

@implementation NSDictionary (PreventNull)

- (void)setPreventNullValue:(id)value forKey:(NSString *)key
{
    if (key.length == 0 && key == nil) {
        return;
    }
    
    if (value == nil || [value isEqual:[NSNull null]]) {
        return;
    }
    
    [self setValue:value forKey:key];
}

@end

@implementation NSMutableArray (PreventNull)

- (void)setPreventNullValue:(id)value forKey:(NSString *)key
{
    if (value == nil || [value isEqual:[NSNull null]]) {
        return;
    }
    
    if (key.length == 0 && key == nil) {
        return;
    }
    
    [self setValue:value forKey:key];
}

@end
