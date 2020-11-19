//
//  FCApi_ticker_trade.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_ticker_trade : YTKRequest
- (instancetype)initWithSymbol:(NSString *)symbol step:(NSString *)step;
@end

NS_ASSUME_NONNULL_END
