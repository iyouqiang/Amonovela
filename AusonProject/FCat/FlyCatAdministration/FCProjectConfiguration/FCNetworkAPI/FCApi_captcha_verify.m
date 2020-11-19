//
//  FC_captcha_verify.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/20.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_captcha_verify.h"


@interface FCApi_captcha_verify()

{
    NSString *_bus_type;
    NSString *_chan_type;
    NSString *_captcha;
    NSString *_captchaId;
}

@end

@implementation FCApi_captcha_verify

- (instancetype)initWithtBusinessType: (NSString *)bus_type chanType:(NSString *)chan_type captchaId: (NSString *)captchaId  captcha:(NSString *)captcha {
    
    self = [super init];
     [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    if (self) {
        _bus_type = bus_type;
        _chan_type = chan_type;
        _captcha = captcha;
        _captchaId = captchaId;
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
    
    return @"/api/v1/user/verification/confirm";
}


- (id)requestArgument{
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_bus_type forKey:@"businessType"];
    [parameter setPreventNullValue:_chan_type forKey:@"channelType"];
    [parameter setPreventNullValue:_captchaId forKey:@"verificationId"];
    [parameter setPreventNullValue:_captcha forKey:@"verificationCode"];
    
//    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    
    return parameter;
}



@end
