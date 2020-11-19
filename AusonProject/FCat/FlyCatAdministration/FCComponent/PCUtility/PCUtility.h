//
//  PCUtility.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/22.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PCUtility : NSObject

+ (void)makeCallWithPhoneNumber:(NSString *)phoneNumber;

/** 计算后台时间间隔 */
+ (void)timeIntervalInBackgroundTime:(void(^)(CFAbsoluteTime timeInterval))timeIntervalBlock;

+ (NSString *)precisionreference:(NSString *)reference realValue:(CGFloat)realValue;

@end
