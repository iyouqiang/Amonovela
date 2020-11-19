//
//  APIOrder_cancel.m
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIOrder_cancel.h"

@implementation APIOrder_cancel
{
    NSString *_orderId;
    NSString *_exchangeName;
    NSString *_symbol;
}

-(instancetype)initWithOrderId:(NSString *)orderId exchangeName:(NSString *)exchangeName symbol:(NSString *)symbol{
    
    if (self = [super init]) {
        _orderId = orderId;
        _symbol = symbol;
        _exchangeName = exchangeName;
    }
    
    return self;
}

- (NSString *)requestUrl{
    
    //取消订单
    return @"/api/order/cancel";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_orderId forKey:@"orderId"];
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
