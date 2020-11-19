//
//  PCWKWebHybridController.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/9.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCWKWebHybridController.h"
#import "JSBridge.h"
#import "PCPublicClassDefinition.h"
#import "MJRefresh.h"
#import "PCH5ErrorView.h"
#import "PCCookieManager.h"
#import "PCCustomRefreshHeader.h"

@interface PCWKWebHybridController ()<WKScriptMessageHandler, WKNavigationDelegate, WKUIDelegate>

@property (nonatomic, strong) WKNavigation *gobackNavigation;
@property (nonatomic, strong) JSBridge *jsBridge;
@property (nonatomic, strong) NSURL *requestURL;
@property (nonatomic, strong) PCH5ErrorView *errorView;
@property (nonatomic, assign) BOOL isNotifRefresh;

@end

@implementation PCWKWebHybridController

- (void)dealloc
{
    if (_wkWebView) {
        
        [_wkWebView removeObserver:self forKeyPath:@"loading"];
        [_wkWebView removeObserver:self forKeyPath:@"title"];
        [_wkWebView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/** 清除cookie */
- (void)clearCookies
{
    if (kSYSTEM(9)) {
        
        WKWebsiteDataStore *dateStore = [WKWebsiteDataStore defaultDataStore];
        [dateStore fetchDataRecordsOfTypes:[WKWebsiteDataStore allWebsiteDataTypes]
                         completionHandler:^(NSArray<WKWebsiteDataRecord *> * __nonnull records) {
                             for (WKWebsiteDataRecord *record  in records)
                             {
                                 //                             if ( [record.displayName containsString:@"baidu"]) //取消备注，可以针对某域名清除，否则是全清
                                 //                             {
                               
                                 //                             }
                                 
                                 [[WKWebsiteDataStore defaultDataStore] removeDataOfTypes:record.dataTypes
                                                                           forDataRecords:@[record]
                                                                        completionHandler:^{
                                                                            NSLog(@"Cookies for %@ deleted successfully",record.displayName);
                                                                        }];
                             }
                         }];
    }else {
        
        NSString *libraryPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *cookiesFolderPath = [libraryPath stringByAppendingString:@"/Cookies"];
        NSError *errors;
        [[NSFileManager defaultManager] removeItemAtPath:cookiesFolderPath error:&errors];
    }
}

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        
        _requestURL = URL;
        
        if ([[FCUserInfoManager sharedInstance] isLogin]) {
            
            NSString *urlStr = URL.absoluteString;
            _requestURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@?token=%@",urlStr,FCUserInfoManager.sharedInstance.userInfo.token]];
            NSLog(@"_requestURL : %@", _requestURL.absoluteString);
        }

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = COLOR_BackgroundColor;
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.wkWebView.scrollView addSubview:self.errorView];
    
    [self.view addSubview:self.wkWebView];
    [self.view addSubview:self.progress];
    
    //self.isCanbackHome = YES;
    //_isshoudChangeBackIcon = YES;
    
    // 加载
    [self loadRequestWKWebView];
    
    /** 加入下拉刷新 */
    [self addpulldownrefresh];
    
    // 导航代理
    self.wkWebView.navigationDelegate = self;
    
    // 与webview UI交互代理
    self.wkWebView.UIDelegate = self;
    
    /// 开启侧滑 设置代理的下面才有效果
    self.wkWebView.allowsBackForwardNavigationGestures = YES;
    
    // 添加KVO监听
    [self.wkWebView addObserver:self
                     forKeyPath:@"loading"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [self.wkWebView addObserver:self
                     forKeyPath:@"title"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    [self.wkWebView addObserver:self
                     forKeyPath:@"estimatedProgress"
                        options:NSKeyValueObservingOptionNew
                        context:nil];
    
    /** 是否是模态跳转 */
    Weak_Self(self);
    if ([kAPPDELEGATE.tabBarViewController presentedViewController]) {
        [self addleftNavigationItemImgNameStr:@"navbar_close" title:nil textColor:nil textFont:nil clickCallBack:^{
            Strong_Self(self);

            [self navigationGobackAction];
        }];
    }
    
    /** 登录登出弹窗 */
    [self loginouttNotification];
}

#pragma mark - configure notif
- (void)loginouttNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginnotification:) name:kNotificationUserLogin object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutnotification:) name:kNotificationUserLogout object:nil];
}

/** 登录成功处理 */
- (void)loginnotification:(NSNotification *)loginNoti
{
    _isNotifRefresh = YES;
    [self wkWebViewReload];
}

- (void)logoutnotification:(NSNotification *)loginNoti
{
    //[self wkWebViewReload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setIsCanbackHome:(BOOL)isCanbackHome
{
    if (isCanbackHome) {
        
        Weak_Self(self);
        [self addrightNavigationItemImgNameStr:@"navbar_web_close" title:nil textColor:nil textFont:nil clickCallBack:^{
            Strong_Self(self);
            [self goHome];
        }];
        
    }else {
        
        [self.navigationController removeRightItems];
    }
    
    _isCanbackHome = isCanbackHome;
}

#pragma mark - Lazy loading

- (WKWebView *)wkWebView
{
    if (!_wkWebView) {
        
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        config.preferences = [[WKPreferences alloc] init];
        config.allowsInlineMediaPlayback = YES;
        config.selectionGranularity = YES;
        config.preferences.minimumFontSize = 10;
        config.preferences.javaScriptEnabled = YES;
        config.preferences.javaScriptCanOpenWindowsAutomatically = NO;
        config.userContentController = [[WKUserContentController alloc] init];
        
        /// 此次cookie有效
        NSString *cookieSource = [NSString stringWithFormat:@"document.cookie = 'token=%@';document.cookie = 'platform=iOS';", FCUserInfoManager.sharedInstance.userInfo.token];
        WKUserScript *cookieScript = [[WKUserScript alloc] initWithSource:cookieSource injectionTime:WKUserScriptInjectionTimeAtDocumentStart forMainFrameOnly:NO];
        [config.userContentController addUserScript:cookieScript];

        _wkWebView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT-kNAVIGATIONHEIGHT) configuration:config];
        _wkWebView.scrollView.backgroundColor = COLOR_BackgroundColor;
        
        _wkWebView.scrollView.showsVerticalScrollIndicator = NO;
        
        [self.wkWebView setValue:@"purcow-ios" forKey:@"applicationNameForUserAgent"];
        
        /** js模型注入 */
        _jsBridge = [[JSBridge alloc] initWithUserContentController:config.userContentController];
        [_jsBridge setUserScriptNames];
    }
    
    return _wkWebView;
}

- (UIProgressView* )progress {
    if (!_progress) {
        _progress = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.wkWebView.frame), 2)];
        _progress.trackTintColor = [UIColor clearColor];
        _progress.progressTintColor = _loadingProgressColor?_loadingProgressColor:COLOR_HighlightColor;
    }
    return _progress;
}

- (PCH5ErrorView *)errorView
{
    if (!_errorView) {
        
        _errorView = [[PCH5ErrorView alloc] initWithFrame:self.wkWebView.bounds];
        _errorView.hidden = YES;
    }
    
    return _errorView;
}

#pragma mark - Private Method

- (void)addpulldownrefresh
{
    if (self.isNotRefresh) {
        return;
    }
    /** 自定义刷新头部 MJRefreshNormalHeader PCCustomRefreshHeader*/
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefresh)];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    self.wkWebView.scrollView.mj_header = header;
}

- (void)headerRefresh
{
    if (_wkWebView.isLoading) {
        return;
    }
    
    /** 网页刷新 */
    [self wkWebViewReload];
}

// 不用
- (void)resetNavigationView
{
    NSString *titleStr = self.wkWebView.title;
    
    NSArray *subTitleStr = [titleStr componentsSeparatedByString:@"-"];

    NSString *cutTitleStr = [subTitleStr firstObject];
    
    self.navigationItem.title = cutTitleStr;
    
    NSInteger backcount = self.wkWebView.backForwardList.backList.count;
    
    if (backcount > 0) {
        
        /*****************************************/
        Weak_Self(self);
        [self removeRightItems];
        [self addrightNavigationItemImgNameStr:@"webapp_navigation_home" title:nil textColor:nil textFont:nil clickCallBack:^{
            Strong_Self(self);
            [self goHome];
        }];
        
    }else {
        
        /*****************************************/
        [self removeRightItems];
    }
}

/** 截取导航栏返回事件 */
- (void)navigationGobackAction
{
    NSInteger backcount = self.wkWebView.backForwardList.backList.count;

    if (backcount > 0) {

        [self goback];
    }else {

        if ([kAPPDELEGATE.tabBarViewController presentedViewController]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)changeNavigationItemIcon
{
    NSInteger backcount = self.wkWebView.backForwardList.backList.count;
    //UIButton *leftBtn = self.navigationItem.leftBarButtonItem.customView;
    
    if (backcount > 0) {
        
        [self removeLeftItems];
        
        [self addmutableleftNavigationItemImgNameStr:@"navbar_back" title:@"" textColor:[UIColor clearColor] textFont:[UIFont systemFontOfSize:14] clickCallBack:^{

            [self navigationGobackAction];
        }];
        
        [self addmutableleftNavigationItemImgNameStr:@"icon_web_view_close" title:@"" textColor:[UIColor clearColor] textFont:[UIFont systemFontOfSize:14] clickCallBack:^{

            [self goHome];
        }];

        
        //[leftBtn setImage:[UIImage imageNamed:@"navbar_back"] forState:UIControlStateNormal];
    }else {
        
        [self addleftNavigationItemImgNameStr:@"navbar_back" title:@"" textColor:[UIColor clearColor] textFont:[UIFont systemFontOfSize:14] clickCallBack:^{

            [self navigationGobackAction];
        }];
    }
}

- (void)goback {
    
    if ([self.wkWebView canGoBack]) {
        
        _gobackNavigation = [self.wkWebView goBack];
    }
}

- (void)goHome
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)gofarward {
    
    if ([self.wkWebView canGoForward]) {
        
        [self.wkWebView goForward];
    }
}

/** 刷新当前页面 */
- (void)wkWebViewReload
{
    //[self clearCookies];
    
    // 加载界面
    if (self.wkWebView.title.length > 0 && self.wkWebView.title) {
        if (self.wkWebView.backForwardList.backList.count > 0) {
            
            [self.wkWebView reload];
        }else {
            
            [self loadRequestWKWebView];
        }
    }else {
        
        [self loadRequestWKWebView];
    }
}

/** 当前界面加载新的URL */
- (void)reloadWebViewWithUrl:(NSURL *)URL
{
    // 再加载URL
    _requestURL = URL;
    
    [self loadRequestWKWebView];
}

- (void)loadRequestWKWebView
{
    // 先移除
     [self.jsBridge removeAllUserScripts];
    
    // 再注入
     [self.jsBridge setUserScriptNames];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:self.requestURL];
    request.HTTPShouldHandleCookies = YES;
    [request addValue:[PCCookieManager cookiesValue] forHTTPHeaderField:@"Cookie"];

    [self.wkWebView loadRequest:request];
}

#pragma mark - KVO wkwebview
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary<NSString *,id> *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"loading"]) {
        
    } else if ([keyPath isEqualToString:@"title"]) {
        
        NSString *titleStr = self.wkWebView.title;
        
        NSArray *subTitleStr = [titleStr componentsSeparatedByString:@"-"];
        
        NSString *cutTitleStr = [subTitleStr firstObject];
        
        CGFloat singleWidth = ([cutTitleStr boundingRectWithSize:CGSizeMake(MAXFLOAT, 20) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17]} context:nil].size.width)/cutTitleStr.length;

        /** 导航阿里 可显示字数 */
        NSInteger strNumber = (kSCREENWIDTH -120) / singleWidth;
        
        self.navigationItem.title = strNumber<cutTitleStr.length?[cutTitleStr substringToIndex:strNumber]:cutTitleStr;
    
    } else if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        _progress.progress = self.wkWebView.estimatedProgress;
        
        if (_progress.progress >= 1.0) {
            
            [_progress setHidden:YES];
        }
    }
}

#pragma mark - WKScriptMessageHandler 移送到JSBridge
- (void)userContentController:(WKUserContentController *)userContentController
      didReceiveScriptMessage:(WKScriptMessage *)message {

}

#pragma mark - WKUIDelegate
// 如果在网页上点击某些链接却不响应，试试再实现一个协议方法（属于WKUIDelegate协议），参考http://stackoverflow.com/questions/25713069/why-is-wkwebview-not-opening-links-with-target-blank
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    if (!navigationAction.targetFrame.isMainFrame) {
        [webView loadRequest:navigationAction.request];
    }
    return nil;
}

- (void)webViewDidClose:(WKWebView *)webView {
    NSLog(@"%s", __FUNCTION__);
}

#pragma mark - WKNavigationDelegate
// 请求开始前，会先调用此代理方法
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    
    //NSLog(@"navigationAction.request.URL : %@", navigationAction.request.URL.absoluteString);
  
    NSURL *mutStr = navigationAction.request.URL;
    NSMutableURLRequest *currentRequest = [NSMutableURLRequest requestWithURL:mutStr];
    
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated &&
        [navigationAction.request.URL.scheme isEqualToString:@"tel"]) {
        
        // 对于跨域，需要手动跳转 例如：拨打电话
        if ([[UIApplication sharedApplication] canOpenURL:mutStr]) {
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:mutStr options:@{} completionHandler:^(BOOL success) {}];
            } else {
                [[UIApplication sharedApplication] openURL:mutStr];
            }
        }
        
        // 不允许web内跳转
        decisionHandler(WKNavigationActionPolicyCancel);
        
    } else {
    
        // 界面刷新更新
        decisionHandler(WKNavigationActionPolicyAllow);
    }
}

// 在响应完成时，会回调此方法 如果设置为不允许响应，web内容就不会传过来
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler {
    decisionHandler(WKNavigationResponsePolicyAllow);
    //NSLog(@"%s", __FUNCTION__);
}

// 开始导航跳转时会回调
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    _progress.hidden = NO;
    
    /** 空网页不跳转 */
    if ([webView.URL.scheme isEqual:@"about"]) {
        webView.hidden = YES;
    }
    
    // 避免界面闪烁
    if (self.errorView.hidden == NO) {
        return;
    }
    
    _wkWebView.hidden = NO;
    self.errorView.hidden = YES;
}

// 接收到重定向时会回调
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(null_unspecified WKNavigation *)navigation {
    
    // NSLog(@"重定向： webView ：%s %@", __FUNCTION__, webView.URL.absoluteString);
}

// 导航失败时会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    //NSLog(@"%s", __FUNCTION__);
    
    if([error code] == NSURLErrorCancelled) {
        return;
    }

    [self.errorView.indicatorView stopAnimating];
    
    Weak_Self(self);
    [self.errorView showerrorView:ErrorType_weberror errormessage:error.localizedDescription refreshBlock:^{
        Strong_Self(self);
        [self wkWebViewReload];
    }];
    
    //_wkWebView.hidden = YES;
    _errorView.hidden = NO;
    _errorView.mj_size = _wkWebView.scrollView.contentSize;
    
    [self.wkWebView.scrollView.mj_header endRefreshing];
}

// 导航完成时，会回调（也就是页面载入完成了）
- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    //NSLog(@"%s", __FUNCTION__);
    
    _progress.hidden  = YES;
    _errorView.hidden = YES;
    _wkWebView.hidden = NO;
    [self.errorView.indicatorView stopAnimating];
    
    [self.wkWebView.scrollView.mj_header endRefreshing];
    
    /** 返回刷新 */
    if ([navigation isEqual:self.gobackNavigation] || !navigation) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[_wkWebView reload];
        });
        self.gobackNavigation = nil;
    }
    
    // 改变左侧按钮icon
    [self changeNavigationItemIcon];
}

- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        
        NSURLCredential *card = [[NSURLCredential alloc]initWithTrust:challenge.protectionSpace.serverTrust];
        
        completionHandler(NSURLSessionAuthChallengeUseCredential,card);
    }
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(null_unspecified WKNavigation *)navigation
{
    [webView evaluateJavaScript:[PCCookieManager webcookiesValue] completionHandler:^(id obj, NSError * _Nullable error) {
        //加载真正的第一次Request
    }];
}

- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler
{
    //[PCAlertManager showAlertMessage:message];
    [PCAlertManager showCustomAlertView:@"温馨提示" message:message btnFirstTitle:@"确定" btnFirstBlock:^{

        completionHandler();
        
    } btnSecondTitle:nil btnSecondBlock:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
