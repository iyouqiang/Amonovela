//
//  FCShareTool.m
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FCShareTool.h"

@interface FCShareTool()

@end

@implementation FCShareTool

+ (void)showTitle:(nullable NSString *)shareTitle shareImg:(nullable UIImage *)shareImg shareUrl:(nullable NSString *)shareUrl completionWithItemsHandler:(UIActivityViewControllerCompletionWithItemsHandler )completionWithItemsHandler {
    
    NSMutableArray *activityItems = [NSMutableArray array];
    if (shareTitle.length > 0) {
        [activityItems addObject:shareTitle];
    }
    
    if (shareImg) {
        [activityItems addObject:shareImg];
    }
    
    if (shareUrl.length > 0) {
        
        [activityItems addObject:shareUrl];
    }
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    activityVC.view.backgroundColor = [UIColor whiteColor];
    
    //activityVc.excludedActivityTypes= @[UIActivityTypePrint,UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:activityVC animated:YES completion:nil];

    activityVC.completionWithItemsHandler = completionWithItemsHandler;
}

@end
