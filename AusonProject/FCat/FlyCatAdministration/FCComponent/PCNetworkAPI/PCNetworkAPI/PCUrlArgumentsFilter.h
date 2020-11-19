//
//  PCUrlArgumentsFilter.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/27.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetwork.h"

@interface PCUrlArgumentsFilter : NSObject<YTKUrlFilterProtocol>

+ (PCUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments;

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request;

@end
