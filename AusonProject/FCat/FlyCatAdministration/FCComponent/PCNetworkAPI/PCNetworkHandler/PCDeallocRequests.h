//
//  PCDeallocRequests.h
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/29.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YTKNetwork.h"
@interface PCDeallocRequests : NSObject

@property (strong, nonatomic) NSMutableArray<YTKRequest*> *weakRequests;
@property (strong, nonatomic) NSLock *lock;

- (void)clearDeallocRequest;
- (void)addRequest:(YTKRequest*)request;

@end
