//
//  PCWKWebHybridController.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/9.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

@interface PCWKWebHybridController : UIViewController

@property (nonatomic, strong) UIColor *loadingProgressColor;
@property (nonatomic, strong) WKWebView *wkWebView;
@property (nonatomic, strong) UIProgressView *progress;

/** 是否关掉下拉刷新 */
@property (nonatomic, assign) BOOL isNotRefresh;

/** 右侧是否加入一键回首页按钮 */
@property (nonatomic, assign) BOOL isCanbackHome;

/** 左侧是存在 x 和 < 两个返回按钮图标切换 */
//@property (nonatomic, assign) BOOL isshoudChangeBackIcon;

/** 清除cookie */ 
- (void)clearCookies;

/** 未初始化传入 URL 使用 */
- (void)reloadWebViewWithUrl:(NSURL *)URL;

/** 直接初始化创建 */
- (instancetype)initWithURL:(NSURL *)URL;

@end
