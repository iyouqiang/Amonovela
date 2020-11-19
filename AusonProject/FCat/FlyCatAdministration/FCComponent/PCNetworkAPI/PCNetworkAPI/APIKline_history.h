//
//  APIKline_history.h
//  PurCowExchange
//
//  Created by Yochi on 2018/8/15.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APIKline_history : YTKRequest

- (id)initWithsymbol:(NSString *)symbol exchangeName:(NSString *)exchangeName interval:(NSString *)interval;

@end
