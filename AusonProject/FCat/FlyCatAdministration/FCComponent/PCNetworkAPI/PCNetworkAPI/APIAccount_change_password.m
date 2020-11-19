//
//  APIAccount_change_password.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_change_password.h"

@implementation APIAccount_change_password
{
    /**
     "old_password": "333",        #旧密码
     "new_password":"2323",        #新密码
     "confirmed_new_password":"",  #确认密码
     "ga_code": "3323"             #二次验证码（如果用户开启了二次认证）

     */
    
    NSString *_old_password;
    NSString *_new_password;
    NSString *_confirmed_new_password;
    NSString *_ga_code;
}

//客户端发起修改密码
- (id)initWithUserOld_password:(NSString *)old_password new_password:(NSString *)new_password confirmed_new_password:(NSString *)confirmed_new_password ga_code:(NSString *)ga_code
{
    self = [super init];
    if (self) {
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _old_password = old_password.MD5;
        _new_password = new_password.MD5;
        _confirmed_new_password = confirmed_new_password.MD5;
        _ga_code = ga_code;
    }
    return self;
}

- (NSString *)requestUrl {
    
    //客户端发起修改密码
    return @"/account/change_password";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [NSMutableDictionary dictionary];
    [parameter setPreventNullValue:_old_password forKey:@"old_password"];
    [parameter setPreventNullValue:_new_password forKey:@"new_password"];
    [parameter setPreventNullValue:_confirmed_new_password forKey:@"confirmed_new_password"];
    [parameter setPreventNullValue:_ga_code forKey:@"ga_code"];
    
    return parameter;
}
@end
