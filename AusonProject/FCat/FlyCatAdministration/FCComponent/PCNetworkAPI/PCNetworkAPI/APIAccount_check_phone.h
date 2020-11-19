//
//  APIAccount_check_phone.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_check_phone : YTKRequest

//客户端注册 检查手机号码
- (id)initWithUserAccount:(NSString *)account scene:(NSString *)scene;

@end
