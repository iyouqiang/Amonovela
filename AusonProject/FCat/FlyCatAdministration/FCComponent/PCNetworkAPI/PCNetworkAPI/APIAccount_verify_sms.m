//
//  APIAccount_verify_sms.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/23.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_verify_sms.h"

@implementation APIAccount_verify_sms
{
    NSString *_phone;
    NSString *_refres_token;
    NSString *_biz;
    NSString *_sms_code;
}

/** 短信验证码校验 */
- (id)initWithPhone:(NSString *)phone refres_token:(NSString *)refres_token biz:(NSString *)biz sms_code:(NSString *)sms_code
{
    self = [super init];
    
    if (self) {
        
        _phone = phone;
        _refres_token = refres_token;
        _biz = biz;
        _sms_code = sms_code;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    //客户端发起验证用户密码
    return @"/account/verify_sms";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
//    [parameter setPreventNullValue:_phone forKey:@"phone"];
//    [parameter setPreventNullValue:_sms_code forKey:@"sms_code"];
//    [parameter setPreventNullValue:_refres_token forKey:@"refresh_token"];
//    [parameter setPreventNullValue:_biz forKey:@"biz"];
    
    return parameter;
}

@end
