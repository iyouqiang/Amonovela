//
//  FCApi_captcha_send.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/20.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_captcha_send.h"

@interface FCApi_captcha_send()
{
    NSString *_phoneCode;
    NSString *_phoneNum;
    NSString *_email;
    NSString *_busType;
    NSString *_chanType;
}
@end


@implementation FCApi_captcha_send

- (instancetype)initWithBusType:(NSString *)busType chanType:(NSString *)chanType PhoneCode:(nullable NSString *)code phoneNum:(nullable NSString *)num  email:(nullable NSString *)email{
    
    self = [super init];
     [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    if (self) {
        _phoneCode = code;
        _phoneNum = num;
        _email = email;
        _busType = busType;
        _chanType = chanType;
    }

    
    return self;
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodPOST;
}

- (NSString *)requestUrl{
    
    return @"/api/v1/user/verification/apply";
}

- (id)requestArgument{
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_busType forKey:@"businessType"];
    [parameter setPreventNullValue:_chanType forKey:@"channelType"];
    
    if ([_chanType isEqualToString:@"Phone"]) {
        [parameter setPreventNullValue:_phoneCode forKey:@"phoneCode"];
        [parameter setPreventNullValue:_phoneNum forKey:@"phoneNumber"];
    } {
        [parameter setPreventNullValue:_email forKey:@"email"];
    }
//    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    
    return parameter;
}


@end
