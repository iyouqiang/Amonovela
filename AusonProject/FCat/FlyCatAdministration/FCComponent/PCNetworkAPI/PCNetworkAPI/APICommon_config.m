//
//  APICommon_config.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APICommon_config.h"

@interface APICommon_config()

@property (nonatomic, copy)NSString *baseSymbol;

@end

@implementation APICommon_config

- (instancetype)initWithBaseSymbol:(NSString *)baseSymbol{
    
    self =[super init];
    if (self) {
        
        self.baseSymbol = baseSymbol;
    }
    
    return self;
}


- (NSString *)requestUrl {
    
    //客户端获取配置，每次启动时重新拉取更新即可
    return @"/common/config";
}

- (id)requestArgument {
    return self.baseSymbol ? @{@"base_symbol" : self.baseSymbol} : @{};
}


- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
