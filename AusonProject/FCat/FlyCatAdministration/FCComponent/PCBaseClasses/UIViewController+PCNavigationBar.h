//
//  UIViewController+PCNavigationBar.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/13.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (PCNavigationBar)

/** 导航栏右侧按钮可能多个 */
@property (nonatomic, strong) NSMutableArray *rightItems;
@property (nonatomic, strong) NSMutableArray *rightBlockArrays;

@property (nonatomic, strong) NSMutableArray *leftItems;
@property (nonatomic, strong) NSMutableArray *leftBlockArrays;

/** 左侧导航栏事件 */
@property (nonatomic, copy) void(^leftNavigationItemBlock)(void);

/** 左侧添加导航栏按钮 */
- (UIButton *)addleftNavigationItemImgNameStr:(NSString *)imgName title:(NSString *)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont clickCallBack:(void(^)(void))clickCallBackBlock;

/** 左侧添加多个按钮 */
- (UIButton *)addmutableleftNavigationItemImgNameStr:(NSString *)imgName title:(NSString *)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont clickCallBack:(void(^)(void))clickCallBackBlock;

/** 右侧添加导航栏按钮 */
- (UIButton *)addrightNavigationItemImgNameStr:(NSString *)imgName title:(NSString *)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont clickCallBack:(void(^)(void))clickCallBackBlock;

/** 移除左右两侧按钮 */
- (void)removeLeftItems;
- (void)removeRightItems;

- (void)adjuestInsets;

@end
