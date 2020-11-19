//
//  FCApi_MarketTypes.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_MarketTypes.h"

@implementation FCApi_MarketTypes

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    }
    
    return self;
}

-(NSString *)requestUrl{
    
    return @"/api/v1/app/market/types/get";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    return parameter;
}


@end
