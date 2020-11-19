//
//  NSObject+PCRequestExtension.h
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/29.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (PCRequestExtension)

- (void)autoCancelRequestOnDealloc:(id)request;

@end
