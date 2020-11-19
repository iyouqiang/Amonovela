//
//  UITableView+PCRefreshExtension.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/7.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@interface UITableView (PCRefreshExtension)

/** 下拉时候触发的block */
@property (nonatomic, copy, readonly) void(^refreshDataBlock)(void);

/** 上拉时候触发的block */
@property (nonatomic, copy, readonly) void(^loadMoreDataBlock)(void);

/** 正常刷新 */
- (void)refreshNormalModelRefresh:(BOOL)isAutoRefresh
                 refreshDataBlock:(void(^)(void))refreshDataBlock
                loadMoreDataBlock:(void(^)(void))loadMoreDataBlock;

- (void)endHeaderrefresh;
- (void)endFooterrefresh;
- (void)endRefresh;

/** gif刷新 */

/** 刷新指定单元格 */
- (void)refreshSingleSection:(NSInteger)sectionIndex singleCell:(NSInteger)cellIndex;

/** 刷新指定section */
- (void)refreshSingleSection:(NSInteger)index;

/** 刷新多个cell 传入indexPath数组 */
- (void)refreshCells:(NSArray*)indexArray;


@end
