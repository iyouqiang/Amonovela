//
//  NSDictionary+PreventNull.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (PreventNull)

- (void)setPreventNullValue:(id)value forKey:(NSString *)key;

@end

@interface NSMutableDictionary (PreventNull)

- (void)setPreventNullValue:(id)value forKey:(NSString *)key;

@end
