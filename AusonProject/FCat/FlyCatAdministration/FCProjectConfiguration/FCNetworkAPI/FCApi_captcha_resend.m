//
//  FCApi_captcha_resend.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_captcha_resend.h"

@interface FCApi_captcha_resend()
{
    NSString *_verificationId;
    NSString *_channelType;
}

@end

@implementation FCApi_captcha_resend

- (instancetype)initWithVerificationId:(NSString *)verificationId channelType:(NSString *)channelType{
    self = [super init];
     [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    if (self) {
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
        _verificationId = verificationId;
        _channelType = channelType;
    }
    
    return self;
}

- (YTKRequestSerializerType)requestSerializerType {
    return YTKRequestSerializerTypeJSON;
}


- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    
     return @"/api/v1/user/verification/resend";
}
//
- (id)requestArgument{

//    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    NSMutableDictionary *parameter = [NSMutableDictionary new];
    [parameter setValue:_verificationId forKeyPath:@"verificationId"];
    [parameter setValue:_channelType forKeyPath:@"channelType"];

//    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    return parameter;
}




@end
