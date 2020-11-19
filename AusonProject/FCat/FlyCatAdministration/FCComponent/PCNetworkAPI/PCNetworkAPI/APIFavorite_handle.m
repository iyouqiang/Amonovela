//
//  APIFavorite_handle.m
//  PurCowExchange
//
//  Created by Yochi on 2018/8/9.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIFavorite_handle.h"

@implementation APIFavorite_handle
{
    NSString *_type;
    NSString *_pair;
}

/**
 "type": 操作类型add/del,
 "pair": 交易对(基础币_交易币) 例如：USDT_ETH
 */

/** 添加|删除 自选 */
- (id)initWithType:(NSString *)type pair:(NSString *)pair
{
    self = [super init];
    
    [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    
    if (self) {
        
        _type = type;
        _pair = pair;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    //客户端发起验证用户密码
    return @"/currency/favorite_handle";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setPreventNullValue:_type forKey:@"type"];
    [parameter setPreventNullValue:_pair forKey:@"pair"];
    
    return parameter;
}

@end
