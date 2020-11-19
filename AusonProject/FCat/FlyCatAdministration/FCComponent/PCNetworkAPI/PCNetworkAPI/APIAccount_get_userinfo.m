//
//  APIAccount_get_userinfo.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_get_userinfo.h"

@implementation APIAccount_get_userinfo
- (NSString *)requestUrl {
    
    //客户端请求用户信息
    return @"/account/get_userinfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
