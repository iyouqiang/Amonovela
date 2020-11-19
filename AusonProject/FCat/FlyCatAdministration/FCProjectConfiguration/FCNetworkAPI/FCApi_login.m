//
//  FCApi_login.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_login.h"

@interface FCApi_login()
{
    NSMutableDictionary *_params;
}
@end

@implementation FCApi_login

- (instancetype)initWithLoginType: (NSString *)loginType phoneCode:(NSString *)phoneCode phoneNumber: (NSString *)phoneNumber  email:(NSString *)email password:(NSString *)password{
    
    self = [super init];
     [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    if (self) {
        _params = [NSMutableDictionary new];
        
        /**
         // 终端信息
         type TerminalInfo struct {
             TerminalType int `json:"terminalType"`    // 终端类型 0-web 1-app
             SubType int `json:"subType"`            // TerminalType=0时，取值0；TerminalType=1时，取值1-andriod 2-ios
             DUA    string `json:"dua"`                    // 机型相关信息
         }
         */
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [tempDic setValue:@(1) forKey:@"terminalType"];
        [tempDic setValue:@(2) forKey:@"subType"];
        [tempDic setValue:[[UIDevice currentDevice] model] forKey:@"dua"];
        [_params setValue:tempDic forKey:@"terminalInfo"];
        
        [_params setValue:loginType forKey:@"loginType"];
        [_params setValue:phoneCode forKey:@"phoneCode"];
        [_params setValue:phoneNumber forKey:@"phoneNumber"];
        [_params setValue:email forKey:@"email"];
        [_params setValue:password.MD5 forKey:@"password"];
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
    
    return @"/api/v1/user/login";
}


- (id)requestArgument{
    
//    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
////    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
//    return parameter;
    return _params;
}


@end
