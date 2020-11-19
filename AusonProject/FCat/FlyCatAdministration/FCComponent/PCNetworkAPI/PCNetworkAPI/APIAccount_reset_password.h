//
//  APIAccount_reset_password.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_reset_password : YTKRequest

//客户端发起重置密码
- (id)initWithUserPhone:(NSString *)phone refresh_token:(NSString *)refresh_token sms_code:(NSString *)sms_code password:(NSString *)password confirmed_password:(NSString *)confirmed_password;

@end
