//
//  APIAccount_login.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_login : YTKRequest

//客户端登录
- (id)initWithUserAccount:(NSString *)account password:(NSString *)password authorized_token:(NSString *)authorized_token;

@end
