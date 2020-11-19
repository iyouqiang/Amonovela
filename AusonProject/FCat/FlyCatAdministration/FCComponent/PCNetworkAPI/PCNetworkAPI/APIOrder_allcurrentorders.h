//
//  APIOrder_allcurrentorders.h
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIOrder_allcurrentorders : YTKRequest

/**当前委托（所有）*/
- (instancetype)initWithOffset:(NSString *)offset limit:(NSString *)limit;

@end
