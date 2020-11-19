//
//  NSObject+PCRequestExtension.m
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/29.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "NSObject+PCRequestExtension.h"
#import "PCDeallocRequests.h"
#import "YTKNetwork.h"
#import <objc/runtime.h>

@implementation NSObject (PCRequestExtension)

- (PCDeallocRequests *)deallocRequests
{
    PCDeallocRequests *requests = objc_getAssociatedObject(self, _cmd);
    if (!requests) {
        requests = [[PCDeallocRequests alloc]init];
        objc_setAssociatedObject(self, _cmd, requests, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return requests;
}

- (void)autoCancelRequestOnDealloc:(id)request
{
    [[self deallocRequests] clearDeallocRequest];
    YTKRequest *weakRequest = request;
    [[self deallocRequests] addRequest:weakRequest];
}


@end
