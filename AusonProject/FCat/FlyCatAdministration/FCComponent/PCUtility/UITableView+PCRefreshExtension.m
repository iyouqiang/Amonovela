//
//  UITableView+PCRefreshExtension.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/7.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UITableView+PCRefreshExtension.h"
#import "PCCustomRefreshHeader.h"

@implementation UITableView (PCRefreshExtension)

/** 正常刷新 */
- (void)refreshNormalModelRefresh:(BOOL)isAutoRefresh
                 refreshDataBlock:(void(^)(void))refreshDataBlock
                loadMoreDataBlock:(void(^)(void))loadMoreDataBlock
{
    if (refreshDataBlock) {
        //PCCustomRefreshHeader
        __weak typeof(self) weakSelf = self;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            __strong typeof (weakSelf) strongSelf = weakSelf;
            /** 头部刷新 */
            [strongSelf refreshDataAction];
        }];
        
        header.lastUpdatedTimeLabel.hidden = YES;
        header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        self.mj_header = header;
        
        self.refreshDataBlock = refreshDataBlock;
        
        if (isAutoRefresh) {
            
            /** 默认头部刷新 */
            [self.mj_header beginRefreshing];
        }
    }
    
    if (loadMoreDataBlock) {
        
        __weak typeof(self) weakSelf = self;
       self.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           __strong typeof (weakSelf) strongSelf = weakSelf;
           
            /** 尾部刷新 */
            [strongSelf loadMoreDataAction];
        }];
        
        /** 尾部刷新 */
        self.loadMoreDataBlock = loadMoreDataBlock;
    }
    
}

- (void)endHeaderrefresh
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.mj_header endRefreshing];
    });
}

- (void)endFooterrefresh
{
    [self.mj_footer endRefreshing];
}

- (void)endRefresh
{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

static NSString *HeadRefreshBlockKey = @"headRefreshBlock";

- (void)setRefreshDataBlock:(void (^)(void))refreshDataBlock
{
    if (refreshDataBlock != self.refreshDataBlock) {

        [self willChangeValueForKey:@"headrefresh"];

        objc_setAssociatedObject(self, &HeadRefreshBlockKey,
                                 refreshDataBlock,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);

        [self didChangeValueForKey:@"headrefresh"];
    }
}

- (void (^)(void))refreshDataBlock
{
    return objc_getAssociatedObject(self, &HeadRefreshBlockKey);
}

static NSString *FooterRefreshBlocKey = @"FooterRefreshBlock";

- (void)setLoadMoreDataBlock:(void (^)(void))loadMoreDataBlock
{
    if (loadMoreDataBlock != self.loadMoreDataBlock) {

        [self willChangeValueForKey:@"footerrefresh"];
        objc_setAssociatedObject(self, &FooterRefreshBlocKey,
                                 loadMoreDataBlock,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self didChangeValueForKey:@"footerrefresh"];
    }
}

- (void (^)(void))loadMoreDataBlock
{
    return objc_getAssociatedObject(self, &FooterRefreshBlocKey);
}

/** 下拉时候触发的block */
- (void)refreshDataAction {

    if (self.refreshDataBlock) {

        self.refreshDataBlock();
        [self.mj_footer resetNoMoreData];
    }
}

/** 上拉时候触发的block */
- (void)loadMoreDataAction {

    if (self.loadMoreDataBlock) {
        self.loadMoreDataBlock();
    }
}

#pragma mark - 单元格刷新

/** 刷新指定单元格 */
- (void)refreshSingleSection:(NSInteger)sectionIndex singleCell:(NSInteger)cellIndex
{
    NSIndexPath *singleIndexPath = [NSIndexPath indexPathForRow:cellIndex inSection:sectionIndex];
    [self reloadRowsAtIndexPaths:[NSArray arrayWithObjects:singleIndexPath,nil]  withRowAnimation:UITableViewRowAnimationNone];
}

/** 刷新指定section */
- (void)refreshSingleSection:(NSInteger)index
{
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:index];
    [self reloadSections:indexSet withRowAnimation:UITableViewRowAnimationFade];
}

/** 刷新多个cell */
- (void)refreshCells:(NSArray*)indexArray
{
    [self reloadRowsAtIndexPaths:indexArray  withRowAnimation:UITableViewRowAnimationAutomatic];
}

@end
