//
//  FCApi_account_register.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/20.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_account_register : YTKRequest

- (instancetype)initWithRegisterType: (NSString *)type phoneCode:(nullable NSString *)phoneCode phoneNum: (nullable NSString *)phoneNum email:  (nullable NSString *)email password: (NSString *)password invitaionCode: (nullable NSString *)invitaionCode;

@end

NS_ASSUME_NONNULL_END

