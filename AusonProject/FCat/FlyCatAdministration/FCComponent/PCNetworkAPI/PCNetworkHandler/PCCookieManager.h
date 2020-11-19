//
//  PCCookieManager.h
//  PurCowExchange
//
//  Created by Frank on 2018/7/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCCookieManager : NSObject

+(instancetype)shareManager;

/** 清除cookie的登录态 */
+ (void)clearCookies;

/** 在request请求中设置cookies值 */
+ (NSString *)cookiesValue;

/** 在web中执行js的cookies值 */
+ (NSString *)webcookiesValue;

/** 查看全部cookies */
+ (NSArray *)cookies;

/**  请求头token */
+ (NSDictionary *)requestHeaderToken;

/** 更新当前的apiKey 和 secret*/
- (void)updateApiKey:(NSString *)apikey secret:(NSString *)secret;

@end
