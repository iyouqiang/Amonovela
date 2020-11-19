

//
//  PCWebSocketNetwork.m
//  PurCowExchange
//
//  Created by Frank on 2018/7/11.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCWebSocketNetwork.h"
#import "PCRequesthelper.h"
#import "PCCookieManager.h"
#import "PCPublicClassDefinition.h"
#import "NSDictionary+PreventNull.h"
#import "NSString+PCExtend.h"

@interface PCWebSocketNetwork()<SRWebSocketDelegate>

@property (nonatomic, strong) SRWebSocket *webSocket;
@property (nonatomic, strong) NSTimer *heartBeat;
@property (nonatomic, assign) AFNetworkReachabilityStatus networkStatus;
@property (nonatomic, assign) NSString *urlStr;
@property (nonatomic, copy) receiveMessage receiveMessage;
@property (nonatomic, copy) failure failure;
@property (nonatomic, assign) NSInteger errorCount;//意外断开次数

@end

@implementation PCWebSocketNetwork

- (void)dealloc
{
    [self.heartBeat invalidate];
    self.heartBeat = nil;
}

- (instancetype)initWithReceiveMessage:(receiveMessage)receiveMessage failure:(failure)failure
{
    self = [super init];
    
    if (self) {
        
        self.receiveMessage = receiveMessage;
        
        self.failure = failure;
        
        self.urlStr = @"";//HREF_WebSocketHost;
        
        [self reconnectToHost];
    }
    
    return self;
}


/**
 K线的场景：A_B_kline_1m(1分钟)、A_B_kline_5m(5分钟)、A_B_kline_15m(15分钟)、A_B_kline_30m(30分钟)、A_B_kline_1h(1小时)、A_B_kline_1d(1天)、A_B_kline_1w(1周)
 symbol A_B  A为基础币，B为交易币
 */
- (instancetype)initWithsymbol:(nullable NSString *)symbol receiveMessage:(receiveMessage)receiveMessage failure:(failure)failure
{
    self = [super init];
    
    if (self) {
        
        self.receiveMessage = receiveMessage;
        self.failure = failure;
        
        //NSString *topic = [NSString stringWithFormat:@"%@_kline_%@", symbol, kline];
        
        NSMutableDictionary *mutDic = [[NSMutableDictionary alloc] init];
        
        [mutDic setPreventNullValue:[symbol lowercaseString] forKey:@"topic"];

        self.sendObject = mutDic;
        
        self.urlStr = @"";//HREF_WebSocketHost;
        
        [self reconnectToHost];
    }
    
    return self;
}



- (void)reconnectToHost
{
        //重连前先关闭可能正在连接的socket
        [self webSocketClose];
        
        //重连时间逐次增加(或者限定重连次数)
        CGFloat timeOut = 2.0*(self.errorCount + 1);
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.urlStr] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:timeOut];
        [request addValue:[PCCookieManager cookiesValue] forHTTPHeaderField:@"Cookie"];
        self.webSocket = [[SRWebSocket alloc] initWithURLRequest:request];
        self.webSocket.delegate = self;
    
        [self.webSocket open];
}

- (void)initHeartBeat
{
    self.heartBeat = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(sendPing) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.heartBeat forMode:NSRunLoopCommonModes];
}

- (void)invalidateHeartBeat
{
    [self.heartBeat invalidate];
    self.heartBeat = nil;
}

- (void)sendPing
{
    if (self.webSocket.readyState == SR_OPEN) {
        
        [_webSocket send:@"ping"];
    }
}

- (void)monitoringNetWork
{
    [[PCRequesthelper shareRequestHelpler] startMonitoringCurrentNetworkState:^(AFNetworkReachabilityStatus networkstatus) {
        
        switch (networkstatus) {
            case AFNetworkReachabilityStatusUnknown:
                
                [self closeByNetworkStatus];
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
                
                [self closeByNetworkStatus];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
                [self reconnectByNetworkStatus];
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
                [self reconnectByNetworkStatus];
                break;
                
            default:
                break;
        }
        
        self.networkStatus = networkstatus;
    }];
}

- (void)closeByNetworkStatus
{
    if (self.networkStatus > 0) {
        
        [self webSocketClose];
    }
}

- (void)reconnectByNetworkStatus
{
    if (self.networkStatus <= 0) {
        
        [self reconnectToHost];
    }
}

- (void)webSocketClose
{
    if (self.webSocket) {
        
        //self.sendObject = nil;
        [self.webSocket close];
    }
}

// 发送socket信息
- (void)webSocketSendMessage:(NSDictionary *)messageDic
{
    if (self.webSocket.readyState == SR_OPEN) {
     
        NSLog(@"sendMessage: %@",messageDic);
        
        self.sendObject = messageDic;
        
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:messageDic options:NSJSONWritingPrettyPrinted error:&error];
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [self.webSocket send:jsonString];
    }
}

- (SRReadyState)socketState
{
    return self.webSocket.readyState;
}

#pragma -mark SRWebSocketDelegate

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
//    NSLog(@"%s", __func__);
   //回调
    if (self.receiveMessage) {
        
        self.receiveMessage(message);
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
     //NSLog(@"%s", __func__);
    self.errorCount = 0;
    
    //连接成功, 开启心跳
    [self initHeartBeat];
    
    if (self.sendObject) {
     
        NSLog(@"DidOpe sendObject : %@", self.sendObject);
        
        NSError *error;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self.sendObject options:NSJSONWritingPrettyPrinted error:&error];
        
        NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [webSocket send:jsonString];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    //NSLog(@"%s", __func__);
    if (self.failure && self.errorCount >= 5) {
        
        self.failure(error);
    }
    
    if (self.networkStatus != AFNetworkReachabilityStatusNotReachable || self.networkStatus != AFNetworkReachabilityStatusUnknown) {
        
        //网络可用情况下发起重新连接, 出现error的情况最多重连接5次
        self.errorCount += 1;
        if (self.errorCount < 5) {
            [self reconnectToHost];
        }
        
    }else{
        
        [self invalidateHeartBeat];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    //NSLog(@"%s", __func__);
    //关闭心跳，清空socket
    [self invalidateHeartBeat];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    //pinpong机制服务端响应
    //NSLog(@"__%s__", __func__);
}

// Return YES to convert messages sent as Text to an NSString. Return NO to skip NSData -> NSString conversion for Text messages. Defaults to YES.
//- (BOOL)webSocketShouldConvertTextFrameToString:(SRWebSocket *)webSocket
//{
//
//}

@end
