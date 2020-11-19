//
//  FCApi_market_tickers.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/29.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_market_tickers : YTKRequest

- (instancetype)initWithMarketType:(NSString *)martketType sortType:(NSString *)sortType orderType: (NSString *)orderType;

@end

NS_ASSUME_NONNULL_END
