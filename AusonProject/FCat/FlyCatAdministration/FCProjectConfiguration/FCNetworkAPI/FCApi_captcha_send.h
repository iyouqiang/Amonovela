//
//  FCApi_captcha_send.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/20.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_captcha_send : YTKRequest

- (instancetype)initWithBusType:(NSString *)busType chanType:(NSString *)chantype PhoneCode:(nullable NSString *)code phoneNum:(nullable NSString *)num  email:(nullable NSString *)email;

@end

NS_ASSUME_NONNULL_END
