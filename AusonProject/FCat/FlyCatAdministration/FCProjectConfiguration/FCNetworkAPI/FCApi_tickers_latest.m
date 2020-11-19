
//
//  FCApi_tickers_latest.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_tickers_latest.h"
#import "FlyCatAdministration-Swift.h"

@interface FCApi_tickers_latest()
{
    NSMutableDictionary *_params;
}

@end

@implementation FCApi_tickers_latest
-(instancetype)initWithSymbol:(NSString *)symbol{

    if (self = [super init]) {
        _params = [NSMutableDictionary new];
        [_params setValue:symbol forKey:@"symbol"];
        //[self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    }
    
    return self;
}

- (NSString*)baseUrl {
    return FCConstantDefinition.HOSTURL_OC_SPOT;
}

-(NSString *)requestUrl{
    return @"/api/v1/spot/market/latest/ticker/get";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    return _params;
}
@end
