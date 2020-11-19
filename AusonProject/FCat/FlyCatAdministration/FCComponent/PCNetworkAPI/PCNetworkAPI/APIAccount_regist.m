//
//  APIAccount_regist.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_regist.h"

@implementation APIAccount_regist
{
    /**
     "phone": "13751106265",   #用户账号
     "refresh_token":"",       #经过安全验证后颁发的临时token
     "sms_code":"2332",        #短信验证码
     "password":"2323",        #密码
     "confirmed_password":"",  #确认密码
     "invite_code": ""         #邀请码
     */
    
    NSString *_phone;
    NSString *_refresh_token;
    NSString *_sms_code;
    NSString *_password;
    NSString *_confirmed_password;
    NSString *_invite_code;
    NSString *_endpoint;
}
//客户端发起注册
- (id)initWithUserPhone:(NSString *)phone refresh_token:(NSString *)refresh_token sms_code:(NSString *)sms_code password:(NSString *)password confirmed_password:(NSString *)confirmed_password invite_code:(NSString *)invite_code
{
    self = [super init];
    if (self) {
   [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _phone = phone;
        _refresh_token = refresh_token;
        _sms_code = sms_code;
        _password = password.MD5;
        _confirmed_password = confirmed_password.MD5;
        _invite_code = invite_code.MD5;
    }
    return self;
}

- (NSString *)requestUrl {
    
    //客户端发起注册
    return @"/account/regist";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setPreventNullValue:_phone forKey:@"phone"];
    [parameter setPreventNullValue:_refresh_token forKey:@"refresh_token"];
    [parameter setPreventNullValue:_sms_code forKey:@"sms_code"];
    [parameter setPreventNullValue:_password forKey:@"password"];
    [parameter setPreventNullValue:_confirmed_password forKey:@"confirmed_password"];
    [parameter setPreventNullValue:_invite_code forKey:@"invite_code"];
    [parameter setPreventNullValue:@"ios" forKey:@"endpoint"];
    
    return parameter;
}
@end
