//
//  APIAccount_two_fa.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIAccount_two_fa : YTKRequest

//客户端二次认证
- (id)initWithGa_code:(NSString *)ga_code refres_token:(NSString *)refres_token;

@end
