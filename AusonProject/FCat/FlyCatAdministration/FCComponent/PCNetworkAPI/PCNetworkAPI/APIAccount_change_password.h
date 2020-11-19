//
//  APIAccount_change_password.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_change_password : YTKRequest

//客户端发起修改密码
- (id)initWithUserOld_password:(NSString *)old_password new_password:(NSString *)new_password confirmed_new_password:(NSString *)confirmed_new_password ga_code:(NSString *)ga_code;

@end
