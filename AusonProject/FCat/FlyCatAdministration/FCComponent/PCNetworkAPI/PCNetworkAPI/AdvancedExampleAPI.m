//
//  AdvancedExampleAPI.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/27.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "AdvancedExampleAPI.h"
#import "ExampleAPI.h"

@implementation AdvancedExampleAPI

// 批量请求
- (void)sendBatchRequest {
    
    ExampleAPI *a = [[ExampleAPI alloc] initWithUsername:@"yochi" password:@"yochi"];
    ExampleAPI *b = [[ExampleAPI alloc] initWithUsername:@"yochi" password:@"yochi"];
    ExampleAPI *c = [[ExampleAPI alloc] initWithUsername:@"yochi" password:@"yochi"];
    ExampleAPI *d = [[ExampleAPI alloc] initWithUsername:@"yochi" password:@"yochi"];
    YTKBatchRequest *batchRequest = [[YTKBatchRequest alloc] initWithRequestArray:@[a, b, c, d]];
    [batchRequest startWithCompletionBlockWithSuccess:^(YTKBatchRequest *batchRequest) {
        NSLog(@"succeed");
        //NSArray *requests = batchRequest.requestArray;
        //ExampleAPI *a = (ExampleAPI *)requests[0];
        //ExampleAPI *b = (ExampleAPI *)requests[1];
        //ExampleAPI *c = (ExampleAPI *)requests[2];
        //ExampleAPI *user = (ExampleAPI *)requests[3];
        // deal with requests result ...
    } failure:^(YTKBatchRequest *batchRequest) {
        NSLog(@"failed");
    }];
}

// 请求依赖
- (void)sendChainRequest {
    
    // 先请求reg
    ExampleAPI *reg = [[ExampleAPI alloc] initWithUsername:@"username" password:@"password"];
    
    // 请求依赖类
    YTKChainRequest *chainReq = [[YTKChainRequest alloc] init];

    [chainReq addRequest:reg callback:^(YTKChainRequest *chainRequest, YTKBaseRequest *baseRequest) {
        
        //ExampleAPI *result = (ExampleAPI *)baseRequest;
    
        // 请求完后再请求你
        ExampleAPI *api2 = [[ExampleAPI alloc] initWithUsername:@"username" password:@"password"];
        [chainRequest addRequest:api2 callback:nil];
        
    }];
    chainReq.delegate = self;
    // start to send request
    [chainReq start];
}

- (void)chainRequestFinished:(YTKChainRequest *)chainRequest {
    // all requests are done
    NSLog(@"请求完成");
}

- (void)chainRequestFailed:(YTKChainRequest *)chainRequest failedBaseRequest:(YTKBaseRequest*)request {
    // some one of request is failed
    NSLog(@"请求失败");
}

/********获取缓存数据*************/
- (void)loadCacheData {
    
     ExampleAPI *api = [[ExampleAPI alloc] initWithUsername:@"username" password:@"password"];
    // 前提 cacheTimeInSeconds ExampleAPI overwrite 返回大于等于0值
    if ([api loadCacheWithError:nil]) {
        NSDictionary *json = [api responseJSONObject];
        NSLog(@"json = %@", json);
        // show cached data
    }
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
        
        NSLog(@"update ui");
    } failure:^(YTKBaseRequest *request) {
        
        NSLog(@"failed");
    }];
}

@end
