//
//  PCRequesthelper.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/20.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^NetworkReachabilityBlock)(AFNetworkReachabilityStatus networkstatus);

@interface PCRequesthelper : NSObject

// 开始监听当前网络
- (void)startMonitoringCurrentNetworkState:(NetworkReachabilityBlock)networkBlcok;

+ (instancetype)shareRequestHelpler;

// 档期网络状态
@property (nonatomic, assign) AFNetworkReachabilityStatus networkstatus;
@property (nonatomic, strong) NSString *networkType;

+ (NSString *)sortparameter:(NSDictionary *)parameter;

+ (NSString*)itemWithKey:(NSString*)key andValue:(NSString*)value;

+ (id )convertjsonStringToDict:(NSString *)jsonString;

+ (NSString *)urlEncode:(NSString *)requesturl;

+ (NSMutableDictionary *)globalParameter;

+ (NSString *)signString:(NSDictionary *)parameters;

@end
