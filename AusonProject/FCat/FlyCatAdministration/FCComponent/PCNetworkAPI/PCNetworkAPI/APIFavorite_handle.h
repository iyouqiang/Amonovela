//
//  APIFavorite_handle.h
//  PurCowExchange
//
//  Created by Yochi on 2018/8/9.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIFavorite_handle : YTKRequest

/** 添加|删除 自选 */
- (id)initWithType:(NSString *)type pair:(NSString *)pair;

@end
