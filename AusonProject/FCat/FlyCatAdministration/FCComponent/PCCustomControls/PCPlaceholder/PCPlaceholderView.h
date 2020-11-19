//
//  PCPlaceholderView.h
//  PurCowExchange
//
//  Created by Frank on 2018/8/16.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCPlaceholderView : UIView

- (instancetype)initWithImgName:(NSString *)imgName title:(NSString *)title;

+ (instancetype)defaultPlaceholderView;

@end
