//
//  APIAccount_verify_password.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_verify_password.h"

@implementation APIAccount_verify_password
{
    /**
     "password": "333",        #密码
     */
    NSString *_password;
}

//客户端发起验证用户密码
- (id)initWithPassword:(NSString *)password
{
    self = [super init];
    if (self) {
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _password = password.MD5;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    //客户端发起验证用户密码
    return @"/account/verify_password";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setPreventNullValue:_password forKey:@"password"];
    
    return parameter;
}

@end
