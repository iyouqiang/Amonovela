//
//  FCDigitalListViewController.h
//  Auson
//
//  Created by Yochi on 2021/1/14.
//  Copyright © 2021 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCDigitalListViewController : UIViewController

@property (nonatomic, strong) NSArray *assetsArry;

@property (nonatomic, copy) void (^callBackItemBlock)(id item);

@end

NS_ASSUME_NONNULL_END
