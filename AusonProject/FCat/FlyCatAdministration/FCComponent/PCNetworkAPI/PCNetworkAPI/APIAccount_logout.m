//
//  APIAccount_logout.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APIAccount_logout.h"

@implementation APIAccount_logout

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    }
    return self;
}

- (NSString *)requestUrl {
    
    //客户端发起退出登录
    return @"/account/logout";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

@end
