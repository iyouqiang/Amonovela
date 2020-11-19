//
//  FCShareTool.h
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCShareTool : NSObject

+ (void)showTitle:(nullable NSString *)shareTitle shareImg:(nullable UIImage *)shareImg shareUrl:(nullable NSString *)shareUrl completionWithItemsHandler:(UIActivityViewControllerCompletionWithItemsHandler )completionWithItemsHandler;
@end

NS_ASSUME_NONNULL_END
