//
//  PCUnderLineTextFileld.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/7.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCUnderLineTextFileld.h"
#import "PCMacroDefinition.h"
#import "PCStyleDefinition.h"

@interface PCUnderLineTextFileld ()

@property (nonatomic, strong) UIView *underLineView;

@end

@implementation PCUnderLineTextFileld

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        [self configureTextView];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self configureTextView];
    }
    return self;
}

- (void)configureTextView
{
    self.textColor = [UIColor whiteColor];
    self.tintColor = COLOR_HexColor(0xb3b3b3);
    self.font = [UIFont font_customTypeSize:14];
    self.borderStyle = UITextBorderStyleNone;
    [self addSubview:self.underLineView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.underLineView.frame = CGRectMake(0, CGRectGetHeight(self.frame)-1, CGRectGetWidth(self.frame), 1);
}

- (UIView *)underLineView
{
    if (!_underLineView) {
        
        _underLineView = [[UIView alloc] init];
        _underLineView.backgroundColor = COLOR_UnderLineColor;
    }
    
    return _underLineView;
}

-(void)drawPlaceholderInRect:(CGRect)rect {
    // 计算占位文字的 Size
    CGSize placeholderSize = [self.placeholder sizeWithAttributes:
                              @{NSFontAttributeName : self.font}];
    
    [self.placeholder drawInRect:CGRectMake(0, (rect.size.height - placeholderSize.height)/2, rect.size.width, rect.size.height) withAttributes:
     @{NSForegroundColorAttributeName : COLOR_HexColor(0xb3b3b3),
       NSFontAttributeName : self.font}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
