//
//  UIView+Placeholder.m
//  Auson
//
//  Created by Yochi on 2020/12/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "UIView+Placeholder.h"
#import <objc/runtime.h>
#import "UIFont+Extension.h"
#import "PCMacroDefinition.h"
#import "Masonry.h"

@interface UIView ()

@property (nonatomic, strong, setter=setPlaceholderTitle:) UILabel *placeholderTitleL;
@property (nonatomic, strong, setter=setPlaceholderImgView:) UIImageView *placeholderImgView;
@end

@implementation UIView (Placeholder)

- (UIView *)unAvailableDataSourceDefaultView
{
    return [self unAvailableDataSource:@"" imgStr:@""];
}

- (UIView *)unAvailableDataSource:(NSString *)title imgStr:(NSString *)imgStr
{
    if (title.length > 0) {
        self.placeholderTitleL.text = title;
    }else {
        title = @"暂无数据";
    }
    
    if (imgStr.length > 0) {
        
        self.placeholderImgView.image = [UIImage imageNamed:imgStr];
    }else {
        self.placeholderImgView.image = [UIImage imageNamed:@"noneDataIcon"];
    }
    
    UIView *placeholderView = [self placeholderView];
    [self insertSubview:placeholderView atIndex:0];
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(kNAVIGATIONHEIGHT);
            make.width.mas_equalTo(225);
            make.height.mas_equalTo(145);
    }];
    
    return placeholderView;
}

- (UIView *)unAvailableDataSource:(NSString *)title imgStr:(NSString *)imgStr verticalSpace:(CGFloat)verticalSpace
{
    if (title.length > 0) {
        self.placeholderTitleL.text = title;
    }
    
    if (imgStr.length > 0) {
        
        self.placeholderImgView.image = [UIImage imageNamed:imgStr];
    }
    
    UIView *placeholderView = [self placeholderView];
    [self addSubview:placeholderView];
    
    [placeholderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.mas_centerX);
            make.top.mas_equalTo(verticalSpace);
            make.width.mas_equalTo(225);
            make.height.mas_equalTo(145);
    }];
    
    return placeholderView;
}

- (UIView *)placeholderView
{
    UIView *placeholderView = [self viewWithTag:1102];
    if (!placeholderView) {
     
        placeholderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 225, 105 + 40)];
        placeholderView.backgroundColor = [UIColor clearColor];
        [placeholderView addSubview:self.placeholderImgView];
        [placeholderView addSubview:self.placeholderTitleL];
        placeholderView.tag = 1102;
    }
    
    return placeholderView;
}

- (void)removePlaceholderView
{
    UIView *placeholderView = [self viewWithTag:1102];
    [placeholderView removeFromSuperview];
    placeholderView = nil;
}

#pragma mark - setter/getter

- (UIImageView *)placeholderImgView
{
    UIImageView *placeholderImgView = objc_getAssociatedObject(self, _cmd);
    
    if (!placeholderImgView) {
        
        placeholderImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"noneDataIcon"]];
        placeholderImgView.frame = CGRectMake(0, 0, 225, 105);
        placeholderImgView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    return placeholderImgView;
}

- (UILabel *)placeholderTitleL
{
    UILabel *placeholderL = objc_getAssociatedObject(self, _cmd);
    
    if (!placeholderL) {
        
        placeholderL = [[UILabel alloc] initWithFrame:CGRectMake(0, 65, 225, 40)];
        placeholderL.text = @"暂无数据";
        placeholderL.numberOfLines = 2;
        placeholderL.font = [UIFont font_PingFangSCTypeSize:14];
        placeholderL.textAlignment = NSTextAlignmentCenter;
        placeholderL.textColor = COLOR_HexColor(0x748293);
    }
    
    return placeholderL;
}

- (void)setPlaceholderTitleL:(UILabel *)placeholderTitleL
{
    objc_setAssociatedObject(self, @selector(placeholderTitleL), placeholderTitleL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setPlaceholderImgView:(UIImageView *)placeholderImgView
{
    objc_setAssociatedObject(self, @selector(placeholderImgView), placeholderImgView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
