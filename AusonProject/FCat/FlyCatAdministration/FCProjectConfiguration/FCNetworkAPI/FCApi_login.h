//
//  FCApi_login.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_login : YTKRequest

- (instancetype)initWithLoginType: (NSString *)loginType phoneCode:(NSString *)phoneCode phoneNumber: (NSString *)phoneNumber  email:(NSString *)email password:(NSString *)password;

@end

NS_ASSUME_NONNULL_END
