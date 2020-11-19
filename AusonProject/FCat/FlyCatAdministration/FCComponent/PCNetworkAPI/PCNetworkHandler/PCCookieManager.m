
//
//  PCCookieManager.m
//  PurCowExchange
//
//  Created by Frank on 2018/7/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCCookieManager.h"
#import "PCMacroDefinition.h"
#import "PCStaticStrConstants.h"
#import "NSString+PCExtend.h"

#import "NSDictionary+PreventNull.h"
#import <UIKit/UIKit.h>
#import "PCPublicClassDefinition.h"
static  NSString * const kSESSIONID = @"sid";

@interface PCCookieManager()

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *secret;

@end

@implementation PCCookieManager

static PCCookieManager *shareManager = nil;

+(instancetype)shareManager{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[PCCookieManager alloc] init];
    });
    
    return shareManager;
}

/** 清除cookie的登录态 */
+ (void)clearCookies
{
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];

    for (NSHTTPCookie *cookie in storage.cookies) {

        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
        /**
        if ([cookie.name isEqual:kSESSIONID]) {

            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        }
         */
    }
}

//Cookie
+ (NSString *)cookiesValue
{
    [PCCookieManager clearCookies];
    
    NSString *sidStr = FCUserInfoManager.sharedInstance.userSID;
    
    if (sidStr.length>0 && sidStr) {
        
        sidStr = [NSString stringWithFormat:@"sid=%@;",sidStr];
    }else {
        sidStr = @"";
    }
    
    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@"system_version=%@;version=%@;platform=%@;identify=%@;token=%@;%@", [UIDevice currentDevice].systemVersion,[NSString  getLocalAppVersion], @"iOS", [NSString getDeviceUUID], FCUserInfoManager.sharedInstance.userInfo.token,sidStr];
    
    // NSLog(@"httpcookies : %@",cookieValue);
    
    return cookieValue;
}

/** 在web中执行js的cookies值 */
+ (NSString *)webcookiesValue
{
    [PCCookieManager clearCookies];
    
    NSString *JSFuncString =
    @"function setCookie(name,value,expires)\
    {\
    var oDate=new Date();\
    oDate.setDate(oDate.getDate()+expires);\
    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
    }";
    
    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
    [cookieDic setObject:[UIDevice currentDevice].systemVersion forKey:@"system_version"];
    [cookieDic setObject:@"iOS" forKey:@"platform"];
    [cookieDic setObject:[NSString getLocalAppVersion] forKey:@"version"];
    [cookieDic setObject:[NSString getAppBundleIdentifier] forKey:@"identify"];
    
    NSString *sidStr = FCUserInfoManager.sharedInstance.userSID;
    
    if (sidStr) {
        [cookieDic setObject:sidStr forKey:@"sid"];
    }
    
    //拼凑js字符串，按照自己的需求拼凑Cookie
    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
    
    for (NSString *keyStr in cookieDic.allKeys) {
        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", keyStr, cookieDic[keyStr]];
        [JSCookieString appendString:excuteJSString];
    }
    
    // NSLog(@"webCookies : %@",JSCookieString);
    return JSCookieString;
}

+ (NSArray *)cookies
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    
    for (cookie in [cookieJar cookies]) {
        
        NSLog(@"%@", cookie.properties);
    }
    
    return [cookieJar cookies];
}

/**  请求头token */
+ (NSDictionary *)requestHeaderToken
{
    NSString *encrypt = [NSString stringWithFormat:@"%@:%@", [PCCookieManager shareManager].apiKey, [PCCookieManager shareManager].secret];
    NSString *token = [NSString stringWithFormat:@"%@",[FCCrypto EncodingWithRaw_in:encrypt]];
    
    NSLog(@"token = %@", token);
    
    return FCUserInfoManager.sharedInstance.isLogin? @{@"TOKEN":token} : nil;
}

- (void)updateApiKey:(NSString *)apikey secret:(NSString *)secret
{
    self.apiKey = apikey;
    self.secret = secret;
}

//+ (void)localCookies
//{
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *data = [defaults objectForKey:kPURCOWCookie];
//    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:data];
//    if (cookies) {
//        for (NSHTTPCookie *cookie in cookies) {
//            [storage setCookie:cookie];
//        }
//    }
//}
//
//+ (void)saveCookie
//{
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:[NSHTTPCookieStorage sharedHTTPCookieStorage].cookies];
//    [defaults setObject:data forKey:kPURCOWCookie];
//    [defaults synchronize];
//}
//
///** 清除cookie的登录态 */
//+ (void)clearCookies
//{
//    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//
//    for (NSHTTPCookie *cookie in storage.cookies) {
//
//        if ([cookie.name isEqual:kSESSIONID]) {
//
//            [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
//        }
//    }
//}
//
///** 更新cookies */
//+ (void)updateCookies;
//{
//    /*******cookies 登录态 sid***********/
//    NSMutableDictionary *cookieProperties_sid = [NSMutableDictionary dictionary];
//
//    [cookieProperties_sid setObject:kSESSIONID forKey:NSHTTPCookieName];
//
//    NSString *sidStr = [PCUserInfoManager shareUserManager].userInfo.sid;
//
//    if (!sidStr || sidStr.length == 0) {
//
//        PCUserInfo *userInfo = [[PCUserInfoManager shareUserManager] getUserInfo];
//        sidStr = userInfo.sid;
//    }
//
//    [cookieProperties_sid setPreventNullValue:sidStr forKey:NSHTTPCookieValue];
//
//    NSHTTPCookie *cookie_sid = [NSHTTPCookie cookieWithProperties:cookieProperties_sid];
//
//    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie_sid];
//
//    // 保存更新的token
//    [PCCookieManager saveCookie];
//}
//
////Cookie
//+ (NSString *)cookiesValue
//{
//    [PCCookieManager clearCookies];
//
//    NSString *sidStr = [PCUserInfoManager shareUserManager].userInfo.sid;
//
//    if (!sidStr || sidStr.length == 0) {
//
//        PCUserInfo *userInfo = [[PCUserInfoManager shareUserManager] getUserInfo];
//        sidStr = userInfo.sid;
//    }
//
//    if (sidStr.length>0 && sidStr) {
//
//        sidStr = [NSString stringWithFormat:@"sid=%@;",sidStr];
//    }else {
//        sidStr = @"";
//    }
//
////    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//
//    NSMutableString *cookieValue = [NSMutableString stringWithFormat:@"system_version=%@;platform=%@;identify=%@;%@", [UIDevice currentDevice].systemVersion, @"iOS", [NSString getAppBundleIdentifier],sidStr];
//
////    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
////    for (NSHTTPCookie *cookie in [cookieJar cookies]) {
////        [cookieDic setObject:cookie.value forKey:cookie.name];
////    }
////
////    // cookie重复，先放到字典去重，再进行拼接
////    for (NSString *key in cookieDic) {
////        NSString *appendString = [NSString stringWithFormat:@"%@=%@;", key, [cookieDic valueForKey:key]];
////        [cookieValue appendString:appendString];
////    }
//
////     NSLog(@"cookieValue : %@",cookieValue);
//
//    return cookieValue;
//}
//
///** 在web中执行js的cookies值 */
//+ (NSString *)webcookiesValue
//{
//    [PCCookieManager clearCookies];
//
//    NSString *JSFuncString =
//    @"function setCookie(name,value,expires)\
//    {\
//    var oDate=new Date();\
//    oDate.setDate(oDate.getDate()+expires);\
//    document.cookie=name+'='+value+';expires='+oDate+';path=/'\
//    }";
//
//    NSMutableDictionary *cookieDic = [NSMutableDictionary dictionary];
//    [cookieDic setObject:[UIDevice currentDevice].systemVersion forKey:@"system_version"];
//    [cookieDic setObject:@"iOS" forKey:@"platform"];
//    [cookieDic setObject:[NSString getAppBundleIdentifier] forKey:@"identify"];
//
//    PCUserInfo *userInfoModel = [[PCUserInfoManager shareUserManager] getUserInfo];
//
//    if (userInfoModel.sid) {
//        [cookieDic setObject:userInfoModel.sid forKey:@"sid"];
//    }
//
//    //拼凑js字符串，按照自己的需求拼凑Cookie
//    NSMutableString *JSCookieString = JSFuncString.mutableCopy;
//
//    for (NSString *keyStr in cookieDic.allKeys) {
//        NSString *excuteJSString = [NSString stringWithFormat:@"setCookie('%@', '%@', 3);", keyStr, cookieDic[keyStr]];
//        [JSCookieString appendString:excuteJSString];
//    }
//
////     NSLog(@"JSCookieString : %@",JSCookieString);
//    return JSCookieString;
//}
//
//+ (NSArray *)cookies
//{
//    NSHTTPCookie *cookie;
//    NSHTTPCookieStorage *cookieJar = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//
//    for (cookie in [cookieJar cookies]) {
//
//        NSLog(@"%@", cookie.properties);
//    }
//
//    return [cookieJar cookies];
//}

@end
