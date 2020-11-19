

//
//  APIOrder_allcurrentorders.m
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIOrder_allcurrentorders.h"

@implementation APIOrder_allcurrentorders
{
    NSString *_offset;
    NSString *_limit;
}
- (instancetype)initWithOffset:(NSString *)offset limit:(NSString *)limit{
    
    if (self = [super init]) {
        
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _offset = offset;
        _limit = limit;
    }
    
    return self;
}

- (NSString *)requestUrl{
    return @"/api/order/allcurrentorders";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    
     NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_offset forKey:@"offset"];
    [parameter setPreventNullValue:_limit forKey:@"limit"];
    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    return parameter;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    return [PCCookieManager requestHeaderToken];
}



@end
