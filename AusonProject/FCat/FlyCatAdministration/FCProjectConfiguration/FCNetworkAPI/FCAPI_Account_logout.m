//
//  FCAPI_Account_logout.m
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/14.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "FCAPI_Account_logout.h"

@implementation FCAPI_Account_logout

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    
    return @"/api/account/logout";
}

- (id)requestArgument{
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    
    return parameter;
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    return [PCCookieManager requestHeaderToken];
}

@end
