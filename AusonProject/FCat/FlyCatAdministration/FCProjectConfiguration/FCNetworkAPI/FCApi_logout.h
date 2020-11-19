//
//  FCApi_logout.h
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "YTKRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface FCApi_logout : YTKRequest

- (instancetype)initWithUserId:(NSString *)userId;

@end

NS_ASSUME_NONNULL_END
