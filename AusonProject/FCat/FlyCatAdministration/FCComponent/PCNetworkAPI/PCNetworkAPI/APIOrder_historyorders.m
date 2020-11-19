//
//  APIOrder_historyorders.m
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIOrder_historyorders.h"

@implementation APIOrder_historyorders
{
    NSString *_offset;
    NSString *_limit;
    NSString *_exchangeAccount;
    NSString *_symbol;
}

- (instancetype)initWithExchangeAccount:(NSString *)exchangeAccount symbol:(NSString *)symbol offset:(NSString *)offset limit:(NSString *)limit{
    
    if (self = [super init]) {
        
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _offset = offset;
        _limit = limit;
        _exchangeAccount = exchangeAccount;
        _symbol = symbol;
    }
    
    return self;
}

- (NSString *)requestUrl{
    return @"/api/order/historyorders";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_offset forKey:@"offset"];
    [parameter setPreventNullValue:_limit forKey:@"limit"];
    [parameter setPreventNullValue:_exchangeAccount forKey:@"exchangeAccount"];
    [parameter setPreventNullValue:_symbol forKey:@"symbol"];
    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    return parameter;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    return [PCCookieManager requestHeaderToken];
}


@end
