//
//  APIAccount_verify_password.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_verify_password : YTKRequest

//客户端发起验证用户密码
- (id)initWithPassword:(NSString *)password;

@end
