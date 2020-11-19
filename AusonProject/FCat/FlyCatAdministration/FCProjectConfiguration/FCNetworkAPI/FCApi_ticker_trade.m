//
//  FCApi_ticker_trade.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_ticker_trade.h"
#import "FlyCatAdministration-Swift.h"

@interface FCApi_ticker_trade()
{
    NSMutableDictionary *_params;
}

@end

@implementation FCApi_ticker_trade

- (instancetype)initWithSymbol:(NSString *)symbol step:(NSString *)step{
    if (self = [super init]) {
        _params = [NSMutableDictionary new];
        [_params setValue:symbol forKey:@"symbol"];
        [_params setValue:step forKey:@"precision"];
        //[self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    }
    
    return self;
}

- (NSString*)baseUrl {
    return FCConstantDefinition.HOSTURL_OC_SPOT;
}

- (NSString *)requestUrl{
    return @"/api/v1/spot/market/trade/get";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return _params;
}

@end
