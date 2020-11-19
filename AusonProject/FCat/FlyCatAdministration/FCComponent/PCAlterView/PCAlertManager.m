//
//  PCAlertManager.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/21.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCAlertManager.h"
#import "PCPublicClassDefinition.h"

@implementation PCAlertManager

/** 原始弹窗 */
+ (void)showNativeAlertView:(NSString *)title
                    message:(NSString *)message
                btnFirstTitle:(NSString *)btnFirstTitle
                firststyle:(UIAlertActionStyle)firststyle
                btnSecondTitle:(NSString *)btnSecondTitle
                secondstyle:(UIAlertActionStyle)secondstyle
                btnFirstBlock:(void(^)(void))btnFirstBlock
                btnSecondBlock:(void(^)(void))btnSecondBlcok
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    if (btnFirstTitle.length > 0) {
    
        [alertVC addAction:
         [UIAlertAction actionWithTitle:btnFirstTitle style:firststyle handler:^(UIAlertAction * _Nonnull action) {
            
            if (btnFirstBlock) {
                btnFirstBlock();
            }
        }]];
    }
    
    if (btnSecondTitle.length > 0) {
        
        [alertVC addAction:
         [UIAlertAction actionWithTitle:btnSecondTitle style:secondstyle handler:^(UIAlertAction * _Nonnull action) {
            
            if (btnSecondBlcok) {
                btnSecondBlcok();
            }
        }]];
    }
    
//    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
//    [delegate.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

/** 自定弹窗 */
+ (void)showCustomAlertView:(NSString *)title
                               message:(NSString *)message
                         btnFirstTitle:(NSString *)btnFirstTitle
                         btnFirstBlock:(void(^)(void))btnFirstBlock
                        btnSecondTitle:(NSString *)btnSecondTitle
                        btnSecondBlock:(void(^)(void))btnSecondBlcok;
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PCCustomAlert *alert = [PCCustomAlert alertViewWithTitle:title message:message preferredStyle:PCCustomAlert_Alert];
        alert.tag = 1998;
        if (btnFirstTitle.length > 0) {
            
            [alert addAction:btnFirstTitle style:(PCCustomAction_Normal) btnAction:^(NSString *message) {
                
                if (btnFirstBlock) {
                    btnFirstBlock();
                }
            }];
        }
        
        if (btnSecondTitle.length > 0) {
            
            [alert addAction:btnSecondTitle style:(PCCustomAction_highlight) btnAction:^(NSString *message) {
                
                if (btnSecondBlcok) {
                    btnSecondBlcok();
                }
            }];
        }
        
        [alert presentViewAlert];
    });
}

/** 输入框弹窗 */
+ (void)showCustomInputAlertView:(NSString *)title
                     placeholder:(NSString *)placeholder
                    confirmTitle:(NSString *)confirmTitle
                    confirmBlock:(void(^)(NSString *inputStr))confirmBlock
                     cancelTitle:(NSString *)cancelTitle
                     cancelBlock:(void(^)(void))cancelBlock;
{
    dispatch_async(dispatch_get_main_queue(), ^{
       
        PCCustomAlert *alert = [PCCustomAlert alertViewWithTitle:title message:placeholder preferredStyle:PCCustomAlert_Input];
        
        if (cancelTitle.length > 0) {
            
            [alert addAction:cancelTitle style:(PCCustomAction_Normal) btnAction:^(NSString *message) {
                
                if (cancelBlock) {
                    cancelBlock();
                }
            }];
        }
        
        if (confirmTitle.length > 0) {
            
            [alert addAction:confirmTitle style:(PCCustomAction_highlight) btnAction:^(NSString *message) {
                
                if (confirmBlock && message.length !=0) {
                    confirmBlock(message);
                }
            }];
        }
        
        [alert presentViewAlert];
    });
}

+ (void)showAlertMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [PCAlertManager showCustomAlertView:@"温馨提示" message:message btnFirstTitle:nil btnFirstBlock:nil btnSecondTitle:@"确定" btnSecondBlock:nil];
    });
}

+ (void)showPanAlertMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        PCCustomAlert *alert = [PCCustomAlert alertViewWithTitle:@"" message:message preferredStyle:PCCustomAlert_Alert];
        alert.messageL.textColor = COLOR_HexColor(0x141416);
        alert.arbitrarilyDisappear = YES;
        alert.backgroundColor = COLOR_HexColor(0xFFDB17);
        [alert presentViewAlert];
    });
}

/** 添加整栋动画 */
+ (void)shadeAnimationAlert:(UIView *)hintView
{
    //获取到当前View的layer
    
    CALayer *viewLayer = hintView.layer;
    
    //获取当前View的位置
    
    CGPoint position = viewLayer.position;
    
    //移动的两个终点位置
    
    CGPoint beginPosition = CGPointMake(position.x + 10, position.y);
    
    CGPoint endPosition = CGPointMake(position.x - 10, position.y);
    
    //设置动画
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    
    //设置运动形式
    
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    
    //设置开始位置
    
    [animation setFromValue:[NSValue valueWithCGPoint:beginPosition]];
    
    //设置结束位置

    [animation setToValue:[NSValue valueWithCGPoint:endPosition]];
    
    //设置自动反转
    [animation setAutoreverses:YES];
    
    //设置时间
    [animation setDuration:.06];
    
    //设置次数
    [animation setRepeatCount:3];
    
    //添加上动画
    [viewLayer addAnimation:animation forKey:nil];
}

/** 登录过期 */
+ (void)showAlertExpiry:(NSString *)expiryMessage
{
    if (FCUserInfoManager.sharedInstance.isLogin == NO) {
        return;
    }
    NSString *message = expiryMessage.length > 0 && expiryMessage ? expiryMessage : @"登录已失效，请重新登录";
    [PCAlertManager showCustomAlertView:@"温馨提示" message:message btnFirstTitle:@"确定" btnFirstBlock:^{
        
        /** 退出登录 接口 */
        [FCUserInfoManager.sharedInstance remveUserInfo];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLogout object:nil];
        
        [kAPPDELEGATE.topViewController.navigationController popToRootViewControllerAnimated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [kAPPDELEGATE.tabBarViewController setSelectedIndex:0];
            
            [FCLoginViewController showLogViewWithLoginBlock:^(FCUserInfoModel * userInfoModel) {
                
            }];
        });
        
    } btnSecondTitle:@"取消" btnSecondBlock:^{
        
        /** 退出登录 接口 */
        [FCUserInfoManager.sharedInstance remveUserInfo];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationUserLogout object:nil];
    }];
}

@end
