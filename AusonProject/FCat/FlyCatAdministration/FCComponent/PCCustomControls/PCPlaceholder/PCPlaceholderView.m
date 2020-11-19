
//
//  PCPlaceholderView.m
//  PurCowExchange
//
//  Created by Frank on 2018/8/16.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCPlaceholderView.h"
#import "Masonry.h"
#import "UILabel+PCExtension.h"
#import "PCStyleDefinition.h"

#define defaultTitle @"暂无记录"
#define defaultImg  @"default_placeholder"

@interface PCPlaceholderView()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *imgName;

@end


@implementation PCPlaceholderView

- (instancetype)initWithImgName:(NSString *)imgName title:(NSString *)title{
    
    if (self = [super init]) {
        
        self.title = title;
        self.imgName = imgName;
        [self setupSubviews];
    }
    
    return self;
}

+ (instancetype)defaultPlaceholderView{
    
    return [[PCPlaceholderView alloc] initWithImgName:defaultImg title:defaultTitle];
}

- (void)setupSubviews{
    
    self.imgName = self.imgName.length > 0?self.imgName : defaultImg;
    self.title = self.title.length > 0?self.title : defaultTitle;
    
    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:self.imgName]];
    UILabel *lable = [UILabel labelWithText:self.title textColor:COLOR_HexColor(0xCCCCCC) fontSize:12 bgColor:COLOR_Clear];
    [self addSubview:imgView];
    [self addSubview:lable];
    
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.centerY.mas_equalTo(self.mas_centerY);
    }];
    
    [lable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.mas_centerX);
        make.top.mas_equalTo(imgView.mas_bottom).offset(15);
    }];
}

@end
