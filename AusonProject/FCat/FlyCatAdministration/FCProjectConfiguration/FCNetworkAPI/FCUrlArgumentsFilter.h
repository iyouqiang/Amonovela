//
//  FCUrlArgumentsFilter.h
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetworkConfig.h"
#import "YTKBaseRequest.h"
NS_ASSUME_NONNULL_BEGIN

@interface FCUrlArgumentsFilter : NSObject<YTKUrlFilterProtocol>

+ (FCUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end

NS_ASSUME_NONNULL_END
