//
//  PCDropDownListView.m
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/26.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCDropDownListView.h"
#import "PCPublicClassDefinition.h"

typedef void(^DissViewBlock)(void);

@interface PCDropDownListView ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) DissViewBlock dissBlock;

@end

@implementation PCDropDownListView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initUI];
    }
    
    return self;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self initUI];
    }
    return self;
}

- (void)setBgColor:(UIColor *)bgColor
{
    _bgColor = bgColor;
    self.tableView.backgroundColor = bgColor;
}

- (void)initUI
{
    UITableView * tableView = [UITableView new];
    tableView.showsVerticalScrollIndicator = NO;
    tableView.frame = self.bounds;
    tableView.separatorColor = COLOR_UnderLineColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.delegate      = self;
    tableView.dataSource    = self;
    tableView.clipsToBounds = YES;
    tableView.layer.cornerRadius = 5;
    tableView.layer.borderColor = COLOR_UnderLineColor.CGColor;
    tableView.layer.borderWidth = 0.5;
    self.tableView = tableView;
    tableView.rowHeight = 30;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"fmenualert"];
    [self addSubview:tableView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tableView.frame = self.bounds;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];

    CGRect rect = [self.superview convertRect:self.manalRect toView:self];
    
    if (point.x > rect.origin.x && point.x < CGRectGetMaxX(rect) && point.y > rect.origin.y && point.y < CGRectGetMaxY(rect)) {
        return nil;
    }
    if (!view ) {
        [self dissViewAction];
    }
    
    return view;
}

- (void)dissViewAction
{
    [self removeFromSuperview];
}

- (void)setDataSource:(NSArray *)dataSource
{
    _dataSource = dataSource;
    [_tableView reloadData];
    [self loadCellAnimation];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self dissViewAction];
    if (self.didSelectedCallback) {
        self.didSelectedCallback(indexPath.row, _dataSource[indexPath.row]);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"fmenualert" forIndexPath:indexPath];
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.textLabel.textColor = _textColor ? _textColor : [UIColor blackColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.contentView.backgroundColor = self.bgColor;
    cell.textLabel.font = _textFont ? _textFont : [UIFont systemFontOfSize:13];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    
    UIView *segLine = [cell.contentView viewWithTag:998];
    if (!segLine) {
        segLine = [[UIView alloc] initWithFrame:CGRectMake(0, 29.5, kSCREENWIDTH, 0.5)];
        segLine.backgroundColor = COLOR_UnderLineColor;
    }
    [cell.contentView addSubview:segLine];
    
    return cell;
}

- (void)loadCellAnimation
{
    for (UITableViewCell *cell in self.tableView.visibleCells) {
        cell.transform = CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    }
    
    for (int i = 0; i<self.tableView.visibleCells.count; i++) {
        UITableViewCell *cell = self.tableView.visibleCells[i];
        CGFloat cellDelay = 0.05 *i;
        
        [UIView animateWithDuration:0.5 delay:cellDelay usingSpringWithDamping:0.95 initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseIn animations:^{
            cell.transform = CGAffineTransformMakeTranslation(0.0, 0.0);
        } completion:^(BOOL finished) {
            
        }];
    }
}

// 以下适配iOS11+
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}


@end
