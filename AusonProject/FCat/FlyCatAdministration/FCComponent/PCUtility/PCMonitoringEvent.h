//
//  PCMonitoringEvent.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/5.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 使用这个Application监听全部触摸事件，配合定时器实现用户呆滞后自动锁定
 */
@interface PCMonitoringEvent : UIApplication
{
    NSTimer *_idleTimer;
}

- (void)resetIdleTimer;

@end
