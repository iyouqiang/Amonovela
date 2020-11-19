
//
//  FCApi_account_register.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/20.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_account_register.h"

@interface FCApi_account_register()
{
    NSString *_registerType;
    NSString *_phoneCode;
    NSString *_phoneNum;
    NSString *_email;
    NSString *_password;
    NSString *_inviter;
    NSString *_invitaionCode;
}
@end

@implementation FCApi_account_register

- (instancetype)initWithRegisterType: (NSString *)type phoneCode:(nullable NSString *)phoneCode phoneNum: (nullable NSString *)phoneNum email:  (nullable NSString *)email password: (NSString *)password invitaionCode: (nullable NSString *)invitaionCode
{
    self = [super init];
    
    if (self) {
        _registerType = type;
        _phoneCode = phoneCode;
        _phoneNum = phoneNum;
        _email = email;
        _password = password;
        //_inviter = inviter;
        _invitaionCode = invitaionCode;
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
    
    return @"/api/v1/user/register";
}
//
- (id)requestArgument{

//    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    NSMutableDictionary *parameter = [NSMutableDictionary new];

    if ([_registerType isEqualToString:@"PhonePassword"]) {
        [parameter setPreventNullValue:@"PhonePassword" forKey:@"registerType"];
        [parameter setPreventNullValue:_phoneCode forKey:@"phoneCode"];
        [parameter setPreventNullValue:_phoneNum forKey:@"phoneNumber"];
    }else {
        [parameter setPreventNullValue:_registerType forKey:@"registerType"];
        [parameter setPreventNullValue:_email forKey:@"email"];
    }
    [parameter setPreventNullValue:_password.MD5 forKey:@"password"];

    if (_invitaionCode!= nil) {
        [parameter setPreventNullValue:_inviter forKey:@"invitaionCode"];
    }

//    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];

    return parameter;
}

@end
