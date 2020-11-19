//
//  APIAccount_send_sms.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_send_sms.h"

@implementation APIAccount_send_sms
{
    /**
     "phone": "13751106265",   #用户账号
     "refresh_token":""        #经过安全验证后颁发的临时token
     */
    NSString *_phone;
    NSString *_refres_token;
    NSString *_biz;
    NSString *_authorized_token;
}

- (id)initWithPhone:(NSString *)phone refres_token:(NSString *)refres_token biz:(NSString *)biz authorized_token:(NSString *)authorized_token
{
    self = [super init];
    if (self) {
   [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _phone = phone;
        _refres_token = refres_token;
        _biz = biz;
        _authorized_token = authorized_token;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    //客户端发送短信验证码
    return @"account/send_sms";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:_phone forKey:@"phone"];
    [parameter setValue:_refres_token forKey:@"refresh_token"];
    [parameter setValue:_biz forKey:@"biz"];
    [parameter setValue:_authorized_token forKey:@"authorized_token"];
    
    return parameter;
}

@end
