//
//  APIAccount_regist.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_regist : YTKRequest

//客户端发起注册
- (id)initWithUserPhone:(NSString *)phone refresh_token:(NSString *)refresh_token sms_code:(NSString *)sms_code password:(NSString *)password confirmed_password:(NSString *)confirmed_password invite_code:(NSString *)invite_code;

@end
