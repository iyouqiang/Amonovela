//
//  PCH5ErrorView.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/19.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCH5ErrorView.h"
#import "PCPublicClassDefinition.h"
#import "PCRequesthelper.h"
@interface PCH5ErrorView()

@property (nonatomic, strong) UIButton *refreshBtn;
@property (nonatomic, strong) UIImageView *hintImageView;
@property (nonatomic, strong) UILabel *hintL;
@property (nonatomic, copy) RefreshBlock refreshBlock;

@end

@implementation PCH5ErrorView

- (instancetype)init
{
    self = [super init];

    if (self) {
        
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        [self setup];
    }
    
    return self;
}

#pragma mark - loadView
- (void)setup
{
    self.backgroundColor = COLOR_BackgroundColor;
    [self addSubview:self.hintImageView];
    [self addSubview:self.hintL];
    [self addSubview:self.refreshBtn];
    [self addSubview:self.indicatorView];
}

#pragma mark - eventAction
- (void)refreshView
{
    /** 间隔1.5 防重复点击 */
    [_refreshBtn setEnabled:NO];
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.refreshBtn setEnabled:YES];
    });
    
    if (_refreshBlock) {
        
        _refreshBlock();
    }
    
    [self.indicatorView startAnimating];
}

- (void)showerrorView:(ErrorType)errorType errormessage:(NSString *)message refreshBlock:(RefreshBlock)refreshBlcok
{
    _refreshBlock = refreshBlcok;
    self.hintL.text = message;
    
    if ([PCRequesthelper shareRequestHelpler].networkstatus == AFNetworkReachabilityStatusNotReachable
        ) {
        errorType = ErrorType_network;
        self.hintL.text = @"网络不可用，请检查后重试";
    }
    
    switch (errorType) {
        case ErrorType_network:
            {
                self.hintImageView.image = [UIImage imageNamed:@"webapp_networkerror"];
            }
            break;
        case ErrorType_weberror:
            
        default:
            {
                self.hintImageView.image = [UIImage imageNamed:@"webapp_public_error"];
            }
            break;
    }
}

#pragma mark - lazy
- (UIButton *)refreshBtn
{
    if (!_refreshBtn) {
        
        _refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_refreshBtn addTarget:self action:@selector(refreshView) forControlEvents:UIControlEventTouchUpInside];
        [_refreshBtn setTitle:@"刷新页面" forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:COLOR_HexColor(0x32A8EF) forState:UIControlStateNormal];
        [_refreshBtn setTitleColor:COLOR_White forState:UIControlStateHighlighted];
        _refreshBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        _refreshBtn.frame = CGRectMake((kSCREENWIDTH-200)/2.0, CGRectGetMaxY(self.hintL.frame) + 30, 200, 44.0f);

    }
    
    return _refreshBtn;
}

- (UIImageView *)hintImageView
{
    if (!_hintImageView) {
        
        _hintImageView = [[UIImageView alloc] initWithFrame:CGRectMake((kSCREENWIDTH-65)/2.0, (kSCREENHEIGHT -kNAVIGATIONHEIGHT - kTABBARHEIGHT - 210)/2.0, 65, 65)];
    }
    
    return _hintImageView;
}

- (UILabel *)hintL
{
    if (!_hintL) {
        
        _hintL = [[UILabel alloc] initWithFrame:CGRectMake(20,  CGRectGetMaxY(self.hintImageView.frame) + 50, kSCREENWIDTH-40, 44.0)];
        _hintL.numberOfLines = 0;
        _hintL.text = @"网络不可用，请检查后重试";
        _hintL.textAlignment = NSTextAlignmentCenter;
        _hintL.font = [UIFont systemFontOfSize:17];
        _hintL.textColor = COLOR_HexColor(0xCCCCCC);
    }
    
    return _hintL;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleGray)];
        _indicatorView.center = CGPointMake(self.hintImageView.center.x, self.hintImageView.center.y + self.hintImageView.frame.size.height);
        [_indicatorView hidesWhenStopped];
    }
    
    return _indicatorView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
