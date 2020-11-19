//
//  FCBannerCarouselView.h
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/24.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCBannerCarouselView : UIView

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) void(^didSelectedItemBlock)(NSInteger index);

@end

NS_ASSUME_NONNULL_END
