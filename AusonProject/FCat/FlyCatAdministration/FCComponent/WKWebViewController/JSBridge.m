//
//  JSBridge.m
//  WKWebViewHybrid
//
//  Created by Yochi on 2018/6/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "JSBridge.h"

@interface JSBridge ()<WKScriptMessageHandler>

@property (nonatomic, weak) WKUserContentController * userContentController;
@property (nonatomic, strong) NSArray *userScriptNames;

@end

@implementation JSBridge

+ (NSArray *)alluserScriptNames
{
    return @[@"purcowapp_dismiss",
             @"purcowapp_register",
             @"purcowapp_refreshHomePage",
             @"purcowapp_login",
             @"purcowapp_applyauthentication",
             @"purcowapp_expiry"];
}

- (instancetype)initWithUserContentController:(WKUserContentController *)userContentController
{
    if (self = [super init]) {
        _userContentController = userContentController;
    }return self;
}

/// 注入JS MessageHandler和Name
- (void)setUserScriptNames
{
    _userScriptNames = [JSBridge alluserScriptNames];
    [_userScriptNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.userContentController addScriptMessageHandler:self name:obj];
    }];
}

/// 移除JS MessageHandler
- (void)removeAllUserScripts
{
    [self.userScriptNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.userContentController removeScriptMessageHandlerForName:obj];
        
        // NSLog(@"self.userContentController : %@",self.userContentController.userScripts);
    }];
    self.userScriptNames = nil;
}

/// 接收JS调iOS的事件消息
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
     NSLog(@"JSBridge js调用OC事件  name : %@    body : %@",message.name,message.body);

    NSDictionary *tempDic = nil;
    if ([message.body isKindOfClass:[NSDictionary class]]) {
        
        tempDic = message.body;
    }else if ([message.body isKindOfClass:[NSString class]]) {
        
        NSString *bodyStr = [NSString stringWithFormat:@"%@", message.body];
        tempDic = @{@"wkValue" : bodyStr};
    }
    
}

@end
