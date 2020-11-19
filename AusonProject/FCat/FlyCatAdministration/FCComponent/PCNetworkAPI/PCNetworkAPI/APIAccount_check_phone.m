//
//  APIAccount_check_phone.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_check_phone.h"

@implementation APIAccount_check_phone
{
    /**
     "phone": "13751106265",   #用户账号
     "sessionId":"",           #sdk字段
     "token":"",               #sdk字段
     "sig":"",                 #sdk字段
     "scene":""                #sdk字段
     */
    
    NSString *_phone;
    NSString *_scene;
}

- (id)initWithUserAccount:(NSString *)account scene:(NSString *)scene
{
    self = [super init];
    if (self) {
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _phone = account;
        _scene = scene;
    }
    return self;
}

- (NSString *)requestUrl {
    
    //客户端注册 检查手机号码
    return @"/account/check_phone";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setValue:_phone forKey:@"phone"];
    [parameter setValue:_scene forKey:@"scene"];
    
    return parameter;
}

@end
