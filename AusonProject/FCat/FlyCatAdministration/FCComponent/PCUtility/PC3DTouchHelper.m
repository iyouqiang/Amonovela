//
//  PC3DTouchHelper.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/20.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PC3DTouchHelper.h"

@interface PC3DTouchHelper ()<UIViewControllerPreviewingDelegate>

@property (nonatomic, weak) UIViewController<PC3DTouchHelperPreviewingDelegate> *viewController;

@end

@implementation PC3DTouchHelper

+ (id)hepler:(UIViewController <PC3DTouchHelperPreviewingDelegate> *)viewController {
    return [[self alloc] initWithViewController:viewController];
}

- (instancetype)initWithViewController:(UIViewController <PC3DTouchHelperPreviewingDelegate> *)viewController {
    if (self = [super init]) {
        
        _viewController = viewController;
        
        //判断是否支持3D Touch，如果支持则需要注册一下
        if (@available(iOS 9.0, *)) {
            if (self.viewController.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                [self.viewController registerForPreviewingWithDelegate:self sourceView:_viewController.view];
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
    return self;
}

- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0)
{
    if ([self.viewController respondsToSelector:@selector(previewingContext:viewControllerForLocation:)])
    {
        return [self.viewController previewingContext:previewingContext viewControllerForLocation:location];
    }
    return nil;
}

- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit NS_AVAILABLE_IOS(9_0)
{
    if([self.viewController respondsToSelector:@selector(previewingContext:commitViewController:)]) {
        [self.viewController previewingContext:previewingContext commitViewController:viewControllerToCommit];
    }
}

@end
