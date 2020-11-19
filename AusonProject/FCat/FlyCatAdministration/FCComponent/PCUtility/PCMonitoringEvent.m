//
//  PCMonitoringEvent.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/5.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCMonitoringEvent.h"
#import "PCStaticStrConstants.h"
#import "PCPublicClassDefinition.h"

/** 一分钟未操作通知 */
const int kUserIdleTimeoutInMinutes = 1;

@implementation PCMonitoringEvent

/** main.m 文件中放入了主时间循环 */
- (void)sendEvent:(UIEvent *)event {
    
    [super sendEvent:event];
    
    if (!_idleTimer) {
        
        [self resetIdleTimer];
    }
    
    NSSet *allTouches = [event allTouches];
    
    if ([allTouches count] > 0) {
        
        UITouchPhase phase = ((UITouch *)[allTouches anyObject]).phase;
        
        if (phase == UITouchPhaseBegan) {
            
            [self resetIdleTimer];
        }
    }
}

- (void)resetIdleTimer {
    
    if (_idleTimer) {
        [_idleTimer invalidate];
    }
    
    int timeout = kUserIdleTimeoutInMinutes * 60;
    _idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(idleTimerExceeded)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)idleTimerExceeded {
    
    NSLog(@"一分钟未操作");
}

@end
