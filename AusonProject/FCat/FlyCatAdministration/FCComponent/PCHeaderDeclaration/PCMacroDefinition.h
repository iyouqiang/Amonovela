//
//  PCMacroDefinition.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/13.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#ifndef PCMacroDefinition_h
#define PCMacroDefinition_h

/** iPhone版本判断 */
#define PCiPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断是否为 iPhone 5 SE */
#define PCiPhone5SE ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断是否为 iPhone 6/6s */
#define PCiPhone6_6s ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/** 判断是否为iPhone 6Plus/6sPlus */
#define PCiPhone6Plus_6sPlus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/** appdelegate */
#define kAPPDELEGATE ((AppDelegate *)[UIApplication sharedApplication].delegate)

/** 屏幕横竖屏尺寸  */
#define kSCREENWIDTH [UIScreen mainScreen].bounds.size.width

#define kSCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define kSTATUSHEIGHT [[UIApplication sharedApplication] statusBarFrame].size.height

#define kNAVIGATIONHEIGHT (kSTATUSHEIGHT + 44)

#define kTABBARHEIGHT (PCiPhoneX ? 83.0 : 49.0)

#define iPhoneXPRO (UIScreen.mainScreen.bounds.size.height >= 812 ? YES : NO)

#define iPhonePlusPRO (UIScreen.mainScreen.bounds.size.height > 667 ? YES : NO)


/** 随机 rgb 16进制颜色 */
#define COLOR_RandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 \
green:arc4random_uniform(256)/255.0 \
blue:arc4random_uniform(256)/255.0 alpha:1.0]

#define COLOR_RGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 \
green:(g)/255.0 \
blue:(b)/255.0 alpha:a]

#define COLOR_HexColor(sixteenValue) [UIColor colorWithRed:((float)((sixteenValue & 0xFF0000) >> 16))/255.0 \
green:((float)((sixteenValue & 0xFF00) >> 8))/255.0 \
blue:((float)(sixteenValue & 0xFF))/255.0 alpha:1.0]

/** 强弱引用 */
#define Weak_Self(type)    __weak typeof(type) weak##type = type;
#define Strong_Self(type)  __strong typeof(type) type = weak##type;

/** 内容比例 */

/** 符号转换 */

/** 系统版本 */
#define kSYSTEM(value) @available(iOS value, *)

/** NSlog定义 */
#ifdef DEBUG

#define NSLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define NSLog(...)

#endif

#endif /* PCMacroDefinition_h */
