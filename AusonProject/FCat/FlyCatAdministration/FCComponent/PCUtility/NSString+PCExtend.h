//
//  NSString+PCExtend.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/20.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (PCExtend)

#pragma mark - 设备信息
+ (NSString *)getDeviceUUID;

/** 获取mac地址 无用 02：00：00：00：00*/
+ (NSString *)getMacaddress;

/** 获取设备型号 */
+ (NSString *)getDeviceModel;

/** 获取设备名称 */
+ (NSString *)getDeviceName;

/** 获取设备iP地址 */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

#pragma mark - AppIcon
// 获取APP本地Icon
+ (NSString *)getLocalAppIcon;

#pragma mark - App信息
/** 获取AppName */
+ (NSString *)getAppName;

/** 获取BundleID */
+ (NSString *)getAppBundleIdentifier;

/** 获取 bundle version版本号 */
+ (NSString *)getLocalAppVersion;

/** 获取编译版本好 */
+ (NSString *)getAppBuildNumber;

/** 获取版本URLSchemes */
+ (NSString *)getAppURLScheme;

#pragma mark - 时间戳处理
/** 获取时间戳 */
+ (NSString *)timestampToString;

/// 如期转时间戳
+ (NSString *)dateTotimestamp:(NSDate *)date;

/** 时间戳 转 日期 */
- (NSDate *)timestampTodate;

/** 时间戳转换: 传入格式 yyyy-MM-DD HH:mm:ss */
- (NSString *)timestampTodateFormatter:(NSString *)formatter;

#pragma mark - 数据格式转换
// 阿拉伯转中文
- (NSString*)transChinese;

+ (NSString *)convertToJsonData:(NSDictionary *)dict;

#pragma mark - 加密 编解码处理
- (NSString *)MD5;

#pragma mark - 验证
/**邮箱验证 */
- (BOOL)isValidateEmail;

/** 手机号码验证 */
- (BOOL)isValidateMobileFormate;

/** 判断非法字符 */
- (BOOL)isValidateTheillegalCharacter;

/** 判断密码的合法性 */
- (BOOL)isValidatePassWordLegal;

/** 判断是否位数字 */
- (BOOL)isVerifyLegalNumber;

/** 判断是否最多包含几位小数 */
- (BOOL)isUnderDecimalNUmber:(NSInteger)decimalNumber;

/** 判断是否满足自定义的正则表达式 */
- (BOOL)isMatch:(NSString *)regex;


@end
