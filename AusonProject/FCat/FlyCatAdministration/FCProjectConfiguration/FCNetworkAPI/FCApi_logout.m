//
//  FCApi_logout.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_logout.h"
#import "PCPublicClassDefinition.h"

@interface FCApi_logout()
{
    NSMutableDictionary *_params;
}
@end


@implementation FCApi_logout

- (instancetype)initWithUserId:(NSString *)userId{
    
    self = [super init];
     [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    if (self) {
        _params = [NSMutableDictionary new];
        [_params setValue:userId forKey:@"userId"];
    }

    return self;
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}

- (NSString *)requestUrl{
    
    return @"/api/v1/user/logout";
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
   NSString *token = FCUserInfoManager.sharedInstance.userInfo.token;
    return @{@"X-token" : token ? token : @""};
}

- (id)requestArgument{
    
    return _params;
}


@end

