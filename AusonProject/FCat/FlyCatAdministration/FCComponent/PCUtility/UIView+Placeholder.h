//
//  UIView+Placeholder.h
//  Auson
//
//  Created by Yochi on 2020/12/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Placeholder)

- (UIView *)unAvailableDataSourceDefaultView;

- (UIView *)unAvailableDataSource:(NSString *)title imgStr:(NSString *)imgStr;

- (UIView *)unAvailableDataSource:(NSString *)title imgStr:(NSString *)imgStr verticalSpace:(CGFloat)verticalSpace;

- (void)removePlaceholderView;

@end

NS_ASSUME_NONNULL_END
