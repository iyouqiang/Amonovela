//
//  FCApi_market_tickers.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/29.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_market_tickers.h"
#import "PCPublicClassDefinition.h"

@interface FCApi_market_tickers()
{
    NSMutableDictionary *_params;
}

@end


@implementation FCApi_market_tickers

- (instancetype)initWithMarketType:(NSString *)martketType sortType:(NSString *)sortType orderType: (NSString *)orderType{
    self = [super init];
    if (self) {
        _params = [NSMutableDictionary new];
        [_params setValue:martketType forKey:@"type"];
        [_params setValue:sortType forKey:@"sort"];
        [_params setValue:orderType forKey:@"order"];
    }
    
    return self;
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)requestUrl{
    
    return @"/api/v1/app/market/tickers/get";
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    
    NSString *token = @"";
    if (FCUserInfoManager.sharedInstance.userInfo != nil && FCUserInfoManager.sharedInstance.isLogin) {
        FCUserInfoModel *model = FCUserInfoManager.sharedInstance.userInfo ? FCUserInfoManager.sharedInstance.userInfo : [FCUserInfoModel new];
        token = [model valueForKey:@"token"];
    }
    return token ? @{@"X-token" : token} : @{};
}


- (id)requestArgument{
    
    return _params;
}

@end
