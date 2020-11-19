//
//  APIOrder_cancel.h
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIOrder_cancel : YTKRequest

/**取消订单*/
-(instancetype)initWithOrderId:(NSString *)orderId exchangeName:(NSString *)exchangeName symbol:(NSString *)symbol;

@end
