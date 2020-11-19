//
//  PCUtility.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/22.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCUtility.h"
#import "PCAlertManager.h"
#import "PCRequesthelper.h"
#import "NSString+PCExtend.h"

@implementation PCUtility

/********************检测更新************************/


+ (void)checkAPPUpdate:(void(^)(id object, NSError * _Nullable error))completionHandler
{

}

/** 普通更新 */
static int popAlertCount = 0;

+ (void)checkupdate
{
    popAlertCount ++;
    [PCUtility checkAPPUpdate:^(id object, NSError * _Nullable error) {
        if (error) {
            return ;
        }
        
        NSDictionary *tempDic = object[@"data"];
        NSString *newest_version = tempDic[@"newest_version"];
 
        // 本地版本判读
        if ([PCUtility compareVersion:newest_version to:[NSString getLocalAppVersion]] <= 0) {
            return;
        }

        NSString *title = [NSString stringWithFormat:@"发现新版本%@", newest_version];
        NSString *description = tempDic[@"description"];
        NSString *force = [NSString stringWithFormat:@"%@", tempDic[@"force"]];
        NSString *download_url = tempDic[@"download_url"];
        NSURL *URL = [NSURL URLWithString:download_url];
        
        if (force.integerValue == 1) {
            /** 强制更新 */
            
            [PCAlertManager showCustomAlertView:title message:description btnFirstTitle:@"立即更新" btnFirstBlock:^{
                
                if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                    
                    [[UIApplication sharedApplication] openURL:URL];
                }
                
            } btnSecondTitle:nil btnSecondBlock:nil];
  
        }else {
            
            if (popAlertCount > 1) return;
            
            [PCAlertManager showCustomAlertView:title message:description btnFirstTitle:@"以后再说" btnFirstBlock:^{
                
            } btnSecondTitle:@"立即更新" btnSecondBlock:^{
                
                if ([[UIApplication sharedApplication] canOpenURL:URL]) {
                    
                    [[UIApplication sharedApplication] openURL:URL];
                }
            }];
        }
    }];
}

/**
 比较两个版本号的大小
 
 @param v1 第一个版本号
 @param v2 第二个版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1.
 */
+ (NSInteger)compareVersion:(NSString *)v1 to:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

/********************拨打电话号码************************/

+ (void)makeCallWithPhoneNumber:(NSString *)phoneNumber {

    //iOS 10.2之前不会添加弹窗
    NSMutableString *str = [[NSMutableString alloc] initWithFormat:@"tel://%@", phoneNumber];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:str]]) {
     
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}

/** app后台计时 */
+ (void)timeIntervalInBackgroundTime:(void(^)(CFAbsoluteTime timeInterval))timeIntervalBlock
{
    __block CFAbsoluteTime enterBackgroundTime;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([note.object isKindOfClass:[UIApplication class]]) {
            
            enterBackgroundTime = CFAbsoluteTimeGetCurrent();
        }
    }];
    
    __block CFAbsoluteTime enterForegroundTime;
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        
        if ([note.object isKindOfClass:[UIApplication class]]) {
            
            enterForegroundTime = CFAbsoluteTimeGetCurrent();
            CFAbsoluteTime timeInterval = enterForegroundTime - enterBackgroundTime;
            if (timeIntervalBlock) {
                
                timeIntervalBlock(timeInterval);
            }
        }
    }];
}

+ (NSString *)precisionreference:(NSString *)reference realValue:(CGFloat)realValue
{
    NSInteger accuracy = 0;
    
    if ([reference containsString:@"."]) {
        
        NSArray *valueArray = [reference componentsSeparatedByString:@"."];
        NSString *decStr = valueArray.lastObject;
        accuracy = decStr.length;
    }
    
    NSString *string = [NSString stringWithFormat:@"%%.%ldf",accuracy];
    
    NSString *accuracystr = [NSString stringWithFormat:string, realValue];
    
    return accuracystr;
}


@end
