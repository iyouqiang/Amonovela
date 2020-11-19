//
//  PC3DTouchHelper.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/20.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol PC3DTouchHelperPreviewingDelegate<NSObject>

@optional

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0);
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0);

@end

@interface PC3DTouchHelper : NSObject

+ (id)hepler:(UIViewController *)viewController;

@end
