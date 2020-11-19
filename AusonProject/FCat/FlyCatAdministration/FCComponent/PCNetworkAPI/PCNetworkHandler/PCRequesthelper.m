//
//  PCRequesthelper.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/20.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCRequesthelper.h"
#import "PCMacroDefinition.h"
#import "NSString+PCExtend.h"
#import "NSDictionary+PreventNull.h"
#import "FlyCatAdministration-Swift.h"

@interface PCRequesthelper ()

@property (nonatomic, copy) NetworkReachabilityBlock networkBlcok;

@end

@implementation PCRequesthelper

+ (void)load
{
    [PCRequesthelper shareRequestHelpler];
}

+ (instancetype)shareRequestHelpler
{
    static PCRequesthelper *requestHelper = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        requestHelper = [[PCRequesthelper alloc] init];
    });
    
    return requestHelper;
}

- (void)startMonitoringCurrentNetworkState:(NetworkReachabilityBlock)networkBlcok;
{
    _networkBlcok = networkBlcok;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        AFNetworkReachabilityManager * manager = [AFNetworkReachabilityManager sharedManager];
        
        Weak_Self(self);
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            Strong_Self(self);
            
            /*
             AFNetworkReachabilityStatusUnknown          = -1,
             AFNetworkReachabilityStatusNotReachable     = 0,
             AFNetworkReachabilityStatusReachableViaWWAN = 1,
             AFNetworkReachabilityStatusReachableViaWiFi = 2,
             */
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                    NSLog(@"网络状态未知");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    NSLog(@"当前无网络");
                    break;
                case  AFNetworkReachabilityStatusReachableViaWWAN:
                    NSLog(@"3g/4g网络");
                    self.networkType = @"WWAN";
                    break;
                case  AFNetworkReachabilityStatusReachableViaWiFi:
                    NSLog(@"Wifi");
                    self.networkType = @"WiFi";
                    break;
                default:
                    break;
            }
            
            if (self.networkBlcok) {
                
                self.networkBlcok(status);
            }
            
            self.networkstatus = status;
        }];
        
         [manager startMonitoring];
    }
    
    return self;
}

+ (id )convertjsonStringToDict:(NSString *)jsonString;
{
    
    id retDict = nil;
    if ([jsonString isKindOfClass:[NSString class]]) {
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        retDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        return  retDict;
    }else{
        return retDict;
    }
}

+ (NSString *)sortparameter:(NSDictionary *)parameter
{
    NSArray* sortedKeyArray = [[parameter allKeys] sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return [obj1 compare:obj2];
    }];
    
    NSMutableArray *tmpArray = [NSMutableArray array];
    for (NSString* key in sortedKeyArray) {
        NSString* orderItem = [self itemWithKey:key andValue:[NSString stringWithFormat:@"%@",[parameter objectForKey:key]]];
        
        if (orderItem.length > 0) {
            [tmpArray addObject:orderItem];
        }
    }
    return [tmpArray componentsJoinedByString:@"&"];
}

+ (NSString*)itemWithKey:(NSString*)key andValue:(NSString*)value
{
    if (key.length > 0 && value.length > 0) {
        return [NSString stringWithFormat:@"%@=%@", key, value];
    }
    
    return nil;
}

+ (NSString *)urlEncode:(NSString *)requesturl;
{
    NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
    NSString *encodeUrl = [requesturl stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
    return encodeUrl;
}

+ (NSString *)URLEncodedString:(NSString *)unencodedString
{
    // CharactersToBeEscaped = @":/?&=;+!@#$()~',*";
    // CharactersToLeaveUnescaped = @"[].";
    
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)unencodedString,
                                                              NULL,
                                                              (CFStringRef)@"!*'();:@&=+$,/?%#[]|",
                                                              kCFStringEncodingUTF8));
    
    return encodedString;
}

/**
 *  URLDecode
 */
+ (NSString *)URLDecodedString:(NSString*)encodedString
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/** 获取时间戳 */
+ (NSString *)timestampToString
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss SS"];
    
    //设置时区,这个对于时间的处理有时很重要
    //    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    //
    //    [formatter setTimeZone:timeZone];
    
    //现在时间,你可以输出来看下是什么格式
    NSDate *datenow = [NSDate date];
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
    
    return timeSp;
}

+ (NSMutableDictionary *)globalParameter
{
    /**
     基本协议通用字段：apikey和secret的组合加密字段（加密方式已经给出 传输的时候可以再做下base64)
     key  客户端版本version 终端platform 唯一标识号identify 当前时间戳ts  登录session 签名sign
     其它为业务字段
     sign签名根据字段+ts md5
     */
    NSMutableDictionary *parameDic = [NSMutableDictionary dictionary];
    [parameDic setValue:[NSString getLocalAppVersion] forKey:@"version"];
    [parameDic setValue:@"iOS" forKey:@"platform"];
    [parameDic setValue:[PCRequesthelper timestampToString] forKey:@"ts"];
    [parameDic setValue:[NSString getDeviceUUID] forKey:@"identify"];
    
    FCUserInfoManager *manger = [FCUserInfoManager sharedInstance];
    if (manger.userSID.length != 0) {
     
        [parameDic setPreventNullValue:manger.userSID forKey:@"session"];
    }
    
    return parameDic;
}

+ (NSString *)signString:(NSDictionary *)parameters
{
    NSString *reqeustKEY = [NSString stringWithFormat:@"Fcat@%@", [[NSString timestampToString] timestampTodateFormatter:@"YYYYMMdd"]];
    NSString *signcode = [NSString stringWithFormat:@"%@%@",reqeustKEY, [PCRequesthelper sortparameter:parameters]];
        
    NSString *signMD5 = [PCRequesthelper urlEncode:signcode].MD5;
    
    return signMD5;
}

@end
