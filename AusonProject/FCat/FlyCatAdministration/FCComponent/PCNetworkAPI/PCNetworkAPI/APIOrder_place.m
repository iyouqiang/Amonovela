//
//  APIOrder_place.m
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIOrder_place.h"

@implementation APIOrder_place
{
    NSString *_exchangeName;
    NSString *_amount;
    NSString *_price;
    NSString *_symbol;
    NSString *_side;
}

- (instancetype)initWithExchangeName:(NSString *)exchangeName amount:(NSString *)amount price:(NSString *)price symbol:(NSString *)symbol side:(NSString *)side{
    
    if (self = [super init]) {
        _exchangeName = exchangeName;
        _amount = amount;
        _price = price;
        _symbol = symbol;
        _side = side;
    }
    
    return self;
}


- (NSString *)requestUrl{
    
    return @"/api/order/place";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (id)requestArgument{
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_exchangeName forKey:@"exchangeName"];
    [parameter setPreventNullValue:_amount forKey:@"amount"];
    [parameter setPreventNullValue:_price forKey:@"price"];
    [parameter setPreventNullValue:_symbol forKey:@"symbol"];
    [parameter setPreventNullValue:_side forKey:@"side"];
     [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    return parameter;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    return [PCCookieManager requestHeaderToken];
}

@end
