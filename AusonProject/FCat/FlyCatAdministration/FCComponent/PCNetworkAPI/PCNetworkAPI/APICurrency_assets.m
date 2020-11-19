//
//  APICurrency_assets.m
//  PurCowExchange
//
//  Created by Yochi on 2018/8/9.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APICurrency_assets.h"

@implementation APICurrency_assets

- (NSString *)requestUrl
{
    //客户端发起验证用户密码
    return @"/account/currency_assets";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodGET;
}

@end
