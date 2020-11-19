//
//  PCH5ErrorView.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/19.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, ErrorType) {
    ErrorType_network,
    ErrorType_weberror,
    ErrorType_unknow,
};

typedef void(^RefreshBlock)(void);

@interface PCH5ErrorView : UIView

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)showerrorView:(ErrorType)errorType errormessage:(NSString *)message refreshBlock:(RefreshBlock)refreshBlcok;

@end
