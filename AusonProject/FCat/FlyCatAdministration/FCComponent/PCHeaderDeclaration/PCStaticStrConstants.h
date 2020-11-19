//
//  PCStaticStrConstants.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/4.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#ifndef PCStaticStrConstants_h
#define PCStaticStrConstants_h

/** 静态字符串常量 定义相同时报错 优于宏定义 */

/** 存储key */
static NSString * const kPURCOWUserAccount     = @"kPURCOWUserAccount";
static NSString * const kPURCOWAPPVersions     = @"kPURCOWAPPVersions";
static NSString * const kPURCOWUserloginStatus = @"kPURCOWUserloginStatus";
static NSString * const kPURCOWUserInfo  = @"kPURCOWUserInfo";
static NSString * const kPURCOWCookie    = @"kPURCOWCookie";
static NSString * const kSMALLASSETS     = @"kSMALLASSETS";
static NSString * const kASSETSYNCTIMETAMP = @"kASSETSYNCTIMETAMP";
static NSString * const kUNBINDACCOUNTS    = @"kUNBINDACCOUNTS";
static NSString * const kUUIDIDENTIFY      = @"kUUIDIDENTIFY";

static NSString * const kAPPFIRSTLAUNCH    = @"kAPPFIRSTLAUNCH";


/** 是否开启指纹解锁 */
static NSString * const kUNLOCKFINGERPRINT = @"kUNLOCKFINGERPRINT";

/** 通知事件 Hidden small assets */


/** 一定时间无操作通知 */
static NSString * const kNotificationUserIdleTimeout = @"kNotificationUserIdleTimeout";

/** 登录 登出通知 */
static NSString * const kNotificationUserLogin = @"kNotificationUserLogin";
static NSString * const kNotificationUserLogout = @"kNotificationUserLogout";

/** 资产账号更新成功(绑定/重命名/修改持仓成本)*/
static NSString * const kNotificationEXAccountUpdate = @"kNotificationEXAccountUpdate";

#endif /* PCStaticStrConstants_h */
