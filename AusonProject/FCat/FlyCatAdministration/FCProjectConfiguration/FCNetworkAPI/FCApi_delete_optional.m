//
//  FCApi_delete_optional.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_delete_optional.h"

#import "PCPublicClassDefinition.h"

@interface FCApi_delete_optional()
{
    NSMutableDictionary *_params;
}

@end

@implementation FCApi_delete_optional

- (instancetype)initWithSymbol: (NSString *)symbol marketType:(NSString *)marketType{
    self = [super init];
    [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    if (self) {
        _params = [NSMutableDictionary new];
        if (FCUserInfoManager.sharedInstance.userInfo != nil) {
            FCUserInfoModel *model = FCUserInfoManager.sharedInstance.userInfo ? FCUserInfoManager.sharedInstance.userInfo : [FCUserInfoModel new];
            [_params setValue:model.userId forKey:@"userId"];
        }
        [_params setValue:symbol forKey:@"symbol"];
        [_params setValue:marketType forKey:@"marketType"];
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
    
    return @"/api/v1/app/optional/delete/post";
}

- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    
    NSString *token = @"";
    if (FCUserInfoManager.sharedInstance.userInfo != nil) {
        FCUserInfoModel *model = FCUserInfoManager.sharedInstance.userInfo ? FCUserInfoManager.sharedInstance.userInfo : [FCUserInfoModel new];
        token = [model valueForKey:@"token"];
    }
    return @{@"X-token" : token};
}


- (id)requestArgument{
    
    return _params;
}


@end
