//
//  JSBridge.h
//  WKWebViewHybrid
//
//  Created by Yochi on 2018/6/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>

@interface JSBridge : NSObject

@property (nonatomic, assign) id delegate;

+ (NSArray *)alluserScriptNames;

- (instancetype)initWithUserContentController:(WKUserContentController *)userContentController;

- (void)setUserScriptNames;

- (void)removeAllUserScripts;

@end
