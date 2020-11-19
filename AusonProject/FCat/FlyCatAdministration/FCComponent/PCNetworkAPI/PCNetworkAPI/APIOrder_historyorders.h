//
//  APIOrder_historyorders.h
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIOrder_historyorders : YTKRequest

/**历史委托（所有）*/
- (instancetype)initWithExchangeAccount:(NSString *)exchangeAccount symbol:(NSString *)symbol offset:(NSString *)offset limit:(NSString *)limit;

@end
