//
//  FCShareItemView.h
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCShareItemView : UIView

@property (nonatomic, copy) void (^showOptionalTitleBlock   )(NSString *message);


@property (nonatomic, copy) void (^cancelShareItemBlock   )(void);

@property (nonatomic, strong) UIImage *shareImage;

@end

NS_ASSUME_NONNULL_END
