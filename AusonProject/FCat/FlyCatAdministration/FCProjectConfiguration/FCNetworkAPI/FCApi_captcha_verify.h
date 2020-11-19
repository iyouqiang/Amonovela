//
//  FC_captcha_verify.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/20.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_captcha_verify : YTKRequest

- (instancetype)initWithtBusinessType: (NSString *)bus_type chanType:(NSString *)chan_type  captchaId: (NSString *)captchaId captcha:(NSString *)captcha;

@end

NS_ASSUME_NONNULL_END
