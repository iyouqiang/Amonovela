//
//  APIAccount_two_fa.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_two_fa.h"

@implementation APIAccount_two_fa
{
    /**
     "ga_code": "343553",          #二次认证码
     "refres_token":""             #服务器返回的临时token
     */
    NSString *_ga_code;
    NSString *_refres_token;
}

- (id)initWithGa_code:(NSString *)ga_code refres_token:(NSString *)refres_token
{
    self = [super init];
    if (self) {
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _ga_code = ga_code;
        _refres_token = refres_token;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"/account/two_fa";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setPreventNullValue:_ga_code forKey:@"ga_code"];
    [parameter setPreventNullValue:_refres_token forKey:@"refresh_token"];

    return parameter;
}

@end
