//
//  FCApi_captcha_resend.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_captcha_resend : YTKRequest

- (instancetype)initWithVerificationId:(NSString *)verificationId channelType:(NSString *)channelType;

@end

NS_ASSUME_NONNULL_END
