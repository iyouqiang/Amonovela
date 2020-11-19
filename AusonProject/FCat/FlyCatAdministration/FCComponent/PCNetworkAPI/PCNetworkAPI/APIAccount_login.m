//
//  APIAccount_login.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_login.h"

@implementation APIAccount_login
{
    /**
     "account": "13751106265", #用户账号
     "password": "abc123",     #用户密码md5加密
     "sessionId":"",           #sdk字段
     "token":"",               #sdk字段
     "sig":"",                 #sdk字段
     "scene":""                #sdk字段
     */
    
    NSString *_account;
    NSString *_password;
    NSString *_authorized_token;
}

//客户端登录
- (id)initWithUserAccount:(NSString *)account password:(NSString *)password authorized_token:(NSString *)authorized_token
{
    self = [super init];
    if (self) {
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _account = account;
        _password = password;
        _authorized_token = authorized_token;
    }
    return self;
}

- (NSString *)requestUrl {
    
    //客户端上报设备信息，在每次启动APP的时候触发
    return @"/account/login";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setPreventNullValue:_account forKey:@"account"];
    [parameter setPreventNullValue:_password.MD5 forKey:@"password"];
    [parameter setPreventNullValue:_authorized_token forKey:@"authorized_token"];
    
    return parameter;
}

@end
