//
//  APIOrder_place.h
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIOrder_place : YTKRequest

/**下单*/
- (instancetype)initWithExchangeName:(NSString *)exchangeName amount:(NSString *)amount price:(NSString *)price symbol:(NSString *)symbol side:(NSString *)side;


@end
