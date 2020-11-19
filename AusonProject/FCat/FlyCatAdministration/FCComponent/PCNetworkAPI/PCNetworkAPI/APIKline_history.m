//
//  APIKline_history.m
//  PurCowExchange
//
//  Created by Yochi on 2018/8/15.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIKline_history.h"

@implementation APIKline_history
{
    NSString *_symbol;
    NSString *_resolution;
    NSString *_exchangeName;
    NSString *_interval;
}

/**
 [
 [
 1533116100000,    #k线时间戳
 567.362,          #交易量
 425.51,           #收盘价
 425.69,           #最高
 424.67,           #最低
 425.08            #开盘价
 ],
 ]
 */

- (id)initWithsymbol:(NSString *)symbol exchangeName:(NSString *)exchangeName interval:(NSString *)interval;
{
    self = [super init];
    
    if (self) {
        
        _symbol = symbol;
        _exchangeName = exchangeName;
        _interval = interval;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    //客户端发起验证用户密码
    return @"/api/market/klines";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (NSInteger)cacheTimeInSeconds {
    // 3 分钟 = 180 秒
    return 60 * 60 * 24;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_symbol forKey:@"symbol"];
    [parameter setPreventNullValue:_exchangeName forKey:@"exchangeName"];
    [parameter setPreventNullValue:_interval forKey:@"interval"];
    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    
    return parameter;
}

@end
