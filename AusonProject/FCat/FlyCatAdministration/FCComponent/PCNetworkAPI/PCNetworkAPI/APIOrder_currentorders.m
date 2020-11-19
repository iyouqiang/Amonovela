
//
//  APIOrder_currentorders.m
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIOrder_currentorders.h"

@implementation APIOrder_currentorders

{
    NSString *_exchangeName;
    NSString *_symbol;
}

- (instancetype)initWithEXchangeName:(NSString *)exchangeName symbol:(NSString *)symbol{
    
    if (self = [super init]) {
        
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _exchangeName = exchangeName;
        _symbol = symbol;
    }
    
    return self;
}

- (NSString *)requestUrl {
    
    //当前委托(指定交易对)
    return @"/api/order/currentorders";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_exchangeName forKey:@"exchangeName"];
    [parameter setPreventNullValue:_symbol forKey:@"symbol"];
    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    
    return parameter;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    return [PCCookieManager requestHeaderToken];
}

@end
