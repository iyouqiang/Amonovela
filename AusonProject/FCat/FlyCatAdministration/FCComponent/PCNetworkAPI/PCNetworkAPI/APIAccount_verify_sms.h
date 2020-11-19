//
//  APIAccount_verify_sms.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/23.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_verify_sms : YTKRequest

/** 短信验证码校验 */
- (id)initWithPhone:(NSString *)phone refres_token:(NSString *)refres_token biz:(NSString *)biz sms_code:(NSString *)sms_code;

@end
