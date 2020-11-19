//
//  PCAlertManager.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/21.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PCCustomAlert.h"

@interface PCAlertManager : NSObject

/** 原始弹窗 */
+ (void)showNativeAlertView:(NSString *)title
                    message:(NSString *)message
              btnFirstTitle:(NSString *)btnFirstTitle
                 firststyle:(UIAlertActionStyle)firststyle
             btnSecondTitle:(NSString *)btnSecondTitle
                secondstyle:(UIAlertActionStyle)secondstyle
              btnFirstBlock:(void(^)(void))btnFirstBlock
             btnSecondBlock:(void(^)(void))btnSecondBlcok;

/** 自定弹窗 */
+ (void)showCustomAlertView:(NSString *)title
                               message:(NSString *)message
                         btnFirstTitle:(NSString *)btnFirstTitle
                         btnFirstBlock:(void(^)(void))btnFirstBlock
                        btnSecondTitle:(NSString *)btnSecondTitle
                        btnSecondBlock:(void(^)(void))btnSecondBlcok;

/** 输入框弹窗 */
+ (void)showCustomInputAlertView:(NSString *)title
                     placeholder:(NSString *)placeholder
                    confirmTitle:(NSString *)confirmTitle
                    confirmBlock:(void(^)(NSString *inputStr))confirmBlock
                     cancelTitle:(NSString *)cancelTitle
                     cancelBlock:(void(^)(void))cancelBlock;

/** 仅提示弹窗 标题温馨提示 */
+ (void)showAlertMessage:(NSString *)message;

+ (void)showPanAlertMessage:(NSString *)message;

/** 界面震动提醒动画 */
+ (void)shadeAnimationAlert:(UIView *)hintView;

/** 登录过期 */
+ (void)showAlertExpiry:(NSString *)expiryMessage;


@end
