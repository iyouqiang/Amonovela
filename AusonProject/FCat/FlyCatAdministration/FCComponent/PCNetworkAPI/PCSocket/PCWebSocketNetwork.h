//
//  PCWebSocketNetwork.h
//  PurCowExchange
//
//  Created by Frank on 2018/7/11.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SRWebSocket.h"
#import "PCRequesthelper.h"

typedef void (^receiveMessage)(id _Nullable message);

typedef void (^failure)(NSError * _Nullable error);

@interface PCWebSocketNetwork : NSObject

@property (nonatomic, assign) SRReadyState socketState;
// 初始化时传
@property (nonatomic, strong) NSDictionary * _Nullable sendObject;


- (instancetype _Nullable )initWithsymbol:(nullable NSString *)symbol receiveMessage:(receiveMessage _Nullable )receiveMessage failure:(failure _Nullable )failure;

// 初始化你socket, 做不带参请求
- (instancetype _Nullable )initWithReceiveMessage:(receiveMessage _Nullable )receiveMessage failure:(failure _Nullable )failure;


/**外部主动发起重连*/
- (void)reconnectToHost;

- (void)webSocketClose;

// 发送socketxin'xi
- (void)webSocketSendMessage:(NSDictionary *_Nullable)messageDic;

@end
