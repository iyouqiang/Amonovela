//
//  APIOrder_preplace.m
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIOrder_preplace.h"

@implementation APIOrder_preplace
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
    
    //下单预置信息
    return @"/api/order/preplace";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
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
