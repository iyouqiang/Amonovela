//
//  PCSearchTitleView.h
//  PurCowExchange
//
//  Created by Yochi on 2018/8/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCSearchTitleView : UIView

@property (nonatomic, strong) NSString *placeholderStr;
@property (nonatomic, strong) void(^searchBlock)(NSString *searchStr);
@property (nonatomic, assign) BOOL isfuzzySearch; // 实时搜索

@end
