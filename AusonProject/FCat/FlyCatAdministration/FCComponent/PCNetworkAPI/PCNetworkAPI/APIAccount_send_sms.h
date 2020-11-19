//
//  APIAccount_send_sms.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_send_sms : YTKRequest

- (id)initWithPhone:(NSString *)phone refres_token:(NSString *)refres_token biz:(NSString *)biz authorized_token:(NSString *)authorized_token;

@end
