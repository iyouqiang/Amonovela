//
//  PCCustomAlert.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/21.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    
    PCCustomAlert_Alert,       // 普通弹窗
    PCCustomAlert_Input,       // 输入框弹窗
    PCCustomAlert_Custom       // 全界面外部定制
    
} PCCustomAlertStyle;

typedef enum : NSUInteger {
    
    PCCustomAction_Normal,       // 普通样色按钮
    PCCustomAction_highlight,
    PCCustomAlert_Other,         // 其他颜色按钮，更具内容自行配置
    
} PCCustomActionStyle;

@interface PCCustomAction : NSObject

@property (nonatomic, strong) NSString * _Nullable btnTitle;
@property (nonatomic, copy) void(^ _Nullable PCCustomActionBlock)(NSString *message);
@property (nonatomic, assign) PCCustomActionStyle preferredStyle;

@end

@interface PCCustomAlert : UIView

@property (nonatomic, readonly) NSArray * _Nullable actions;
@property (nonatomic, strong) NSString * _Nullable title;
@property (nonatomic, strong) NSString * _Nullable message;
@property (nonatomic, strong) UITextField * _Nullable inputTextField;
@property (nonatomic, strong) UILabel * _Nullable messageL; // 预留，避免出现富文本弹窗
@property (nonatomic, assign) BOOL arbitrarilyDisappear;


/** 弹窗初始化 */
+ (instancetype _Nullable )alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(PCCustomAlertStyle)preferredStyle;

/** 界面完全外部自定义 底部弹窗 */
+ (instancetype _Nullable )alertCustomView:(UIView *_Nullable)customView;

/** 界面完全外部自定义 中间弹窗 */
+ (instancetype _Nullable )alertCustomCenterPointView:(UIView *_Nullable)customView;

/// 分享弹窗
+ (instancetype _Nullable )alertShareCustomView:(UIView *_Nullable)customView;

/** 视图弹窗 🚧施工完成就撤退 */
+ (void)showAppInConstructionAlert;

/** 警告弹窗 */
+ (void)showWarningAlertMessage:(NSString *_Nullable)message;

/** 按钮事件初始化 */
- (void)addAction:(NSString *_Nullable)btnTitle style:(PCCustomActionStyle)style btnAction:(void(^_Nullable)(NSString * _Nonnull message))btnActionBlock;

/** attributedString 内容与message相同，否则高度将会发生偏差 */
- (void)setAlertAttributedText:(NSAttributedString *_Nullable)attributedString;

/** 弹窗 */
- (void)presentViewAlert;

- (void)disappearAlert;

- (void)cloasAlertView;

@end
