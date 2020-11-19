//
//  PCDeallocRequests.m
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/29.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCDeallocRequests.h"

@implementation PCDeallocRequests

- (instancetype)init{
    if (self = [super init]) {
        _weakRequests = [NSMutableArray arrayWithCapacity:20];
        _lock = [[NSLock alloc]init];
    }
    return self;
}
- (void)addRequest:(YTKRequest*)request{
    if (!request) {
        return;
    }
    [_lock lock];
    [self.weakRequests addObject:request];
    [_lock unlock];
}
- (void)clearDeallocRequest{
    [_lock lock];
    NSInteger count = self.weakRequests.count;
    for (NSInteger i=count-1; i>0; i--) {
        YTKRequest *weakRequest = self.weakRequests[i];
        if (!weakRequest) {
            [self.weakRequests removeObject:weakRequest];
        }
    }
    [_lock unlock];
}

- (void)dealloc{

    for (YTKRequest *weakRequest in _weakRequests) {
        [weakRequest stop];
    }
}

@end
