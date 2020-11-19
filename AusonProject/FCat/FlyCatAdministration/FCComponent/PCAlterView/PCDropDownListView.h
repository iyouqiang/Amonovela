//
//  PCDropDownListView.h
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/26.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCDropDownListView : UIView

/// 点击回调,返回所点的角标以及点击的内容
@property(nonatomic, copy) void(^didSelectedCallback)(NSInteger index, NSString * content);

/// 数据源
@property(nonatomic, strong) NSArray * dataSource;

@property(nonatomic, assign) CGRect manalRect;

/// 背景色
@property(nonatomic, strong) UIColor * bgColor;

// 文字属性设置
@property(nonatomic, strong) UIColor * textColor;
@property(nonatomic,assign) UIFont * textFont;

@end
