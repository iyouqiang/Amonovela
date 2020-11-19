//
//  FCApi_tickers_latest.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_tickers_latest : YTKRequest

-(instancetype)initWithSymbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END
