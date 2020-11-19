//
//  FCApi_add_optional.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_add_optional : YTKRequest

- (instancetype)initWithSymbol: (NSString *)symbol marketType:(NSString *)marketType;

@end

NS_ASSUME_NONNULL_END
