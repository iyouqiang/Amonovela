//
//  APIOrder_preplace.h
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIOrder_preplace : YTKRequest

/**下单预置信息*/

- (instancetype)initWithEXchangeName:(NSString *)exchangeName symbol:(NSString *)symbol;
 

@end
