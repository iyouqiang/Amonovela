//
//  APIOrder_get_history_order.m
//  PurCowExchange
//
//  Created by Frank on 2018/8/15.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIOrder_get_history_order.h"

@interface APIOrder_get_history_order()

@property (nonatomic, assign) NSInteger offset;

@end


@implementation APIOrder_get_history_order

- (instancetype)initWithOffset:(NSInteger)offset{
    
    if (self = [super init]) {
        
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        self.offset = offset;
    }
    
    return self;
}

- (NSString *)requestUrl{
    
    return @"/order/get_history_order";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

- (id)requestArgument{
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setPreventNullValue:[NSString stringWithFormat:@"%zd",self.offset] forKey:@"offset"];
    [parameter setPreventNullValue:@"10" forKey:@"length"];
    
    return parameter;
}


@end
