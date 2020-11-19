//
//  SPMarqueeView.m
//  SPMarqueeViewExample
//
//  Created by 123456789 on 2018/3/6.
//  Copyright © 2018年 123456789. All rights reserved.
//

#import "FCMarqueeView.h"
#import "PCStyleDefinition.h"

@interface FCMarqueeView()
@property(nonatomic,strong)UILabel *customL1;
@property(nonatomic,strong)UILabel *customL2;

@end
@implementation FCMarqueeView
{
    // 记录位置
    NSInteger currentIndex;
}

#pragma mark - 懒加载
- (UIView *)customL1 {
    if (!_customL1) {
        _customL1 = [[UILabel alloc]init];
        _customL1.text = @"热烈庆祝CXP隆重上线";
        [self addSubview:_customL1];
        _customL1.textColor = COLOR_HexColor(0xB0B1B4);
        _customL1.numberOfLines = 2;
        _customL1.font = [UIFont systemFontOfSize:13];
        _customL1.enabled = YES;
        _customL1.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
        [_customL1 addGestureRecognizer:tap];
    }
    return _customL1;
}
- (UIView *)customL2 {
    if (!_customL2) {
        _customL2 = [[UILabel alloc]init];
        [self addSubview:_customL2];
        _customL2.textColor = COLOR_HexColor(0xB0B1B4);
        _customL2.numberOfLines = 2;
        _customL2.font = [UIFont systemFontOfSize:13];
        _customL2.enabled = YES;
        _customL2.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClick)];
        [_customL2 addGestureRecognizer:tap];
    }
    return _customL2;
}

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
        
        // 设置默认数据
        self.animationDuration = 1.f;
        self.pauseDuration = 1.5f;
    }
    return self;
}
- (void)setupView {
    
    // 设置Label的frame
    self.customL1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.customL2.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);

    self.clipsToBounds = YES;
}

#pragma mark - 设置动画
-(void)startMarqueeViewAnimation{
    
    // 1.设置滚动前的数据
    self.customL1.text = self.marqueeContentArray[currentIndex];
    self.customL1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    
    // 提前计算currentIndex
    currentIndex++;
    if(currentIndex >= [self.marqueeContentArray count]) {
        currentIndex = 0;
    }
    
    self.customL2.text = self.marqueeContentArray[currentIndex];
    self.customL2.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    // 2.开始动画
    [UIView animateWithDuration:self.animationDuration animations:^{
       
        self.customL1.frame = CGRectMake(0, -self.frame.size.height, self.frame.size.width, self.frame.size.height);
        self.customL2.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        // 延迟2秒再次启动动画
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMarqueeViewAnimation) object:nil];
        [self performSelector:@selector(startMarqueeViewAnimation) withObject:nil afterDelay:4];
    }];
}

#pragma mark - 开始动画
- (void)start {
    
    // 设置动画默认第一条信息
    currentIndex = 0;
    
    self.customL1.text = self.marqueeContentArray[currentIndex];
    self.customL1.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.customL2.frame = CGRectMake(0, self.frame.size.height, self.frame.size.width, self.frame.size.height);
    
    // 开始动画
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(startMarqueeViewAnimation) object:nil];
    [self performSelector:@selector(startMarqueeViewAnimation) withObject:nil afterDelay:4];
}
#pragma mark - 点击事件
- (void)onClick {
    if (self.block) {
        self.block(currentIndex);
    }
}

@end
