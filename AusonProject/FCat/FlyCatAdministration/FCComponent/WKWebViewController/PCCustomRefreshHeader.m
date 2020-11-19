//
//  PCCustomRefreshHeader.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/19.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCCustomRefreshHeader.h"

@interface PCCustomRefreshHeader()<CAAnimationDelegate>

@property (strong, nonatomic) UIImageView *loadingView;

@property (nonatomic, strong) UIView *animationView;
@property (nonatomic, strong) UIImageView *pawOneView;
@property (nonatomic, strong) UIImageView *pawSecView;
@property (nonatomic, strong) UIImageView *pawThirView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *animationArray;

@end

@implementation PCCustomRefreshHeader

- (UIImageView *)loadingView
{
    if (!_loadingView) {
        
        //_loadingView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"webapp_refreshHeader"]];
        
        _loadingView = [[UIImageView alloc] init]; //45 24
        _loadingView.frame = CGRectMake(0, 0, 45, 45);
        [self addSubview:_loadingView];
        [_loadingView setHidden:YES];

        NSMutableArray *images = [NSMutableArray array];
        
        for (int i = 0; i < 49; i++) {
            
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"loadingPaw_%d", i]];
            [images addObject:img];
        }
        _loadingView.animationDuration = 1.8;
        _loadingView.animationImages = images;
        
        /***************************************/
//        [self addSubview:self.animationView];
//        self.index = 0;
//        self.animationArray = [NSMutableArray array];
    }
    
    return _loadingView;
}

- (UIView *)animationView
{
    if (!_animationView) {
        
        _animationView = [[UIView alloc]  initWithFrame:CGRectMake(0, 0, 60, 60)];
        _animationView.backgroundColor = [UIColor whiteColor];
        
        _pawOneView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pawIcon"]];
        _pawSecView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pawIcon"]];
        _pawThirView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pawIcon"]];
        
        _pawOneView.frame = CGRectMake(20, 0, 20, 20);
        _pawSecView.frame = CGRectMake(10, 30, 20, 20);
        _pawThirView.frame = CGRectMake(30, 30, 20, 20);
        [_animationView addSubview:_pawOneView];
        [_animationView addSubview:_pawSecView];
        [_animationView addSubview:_pawThirView];
    }
    
    return _animationView;
}

#pragma mark - 重写父类方法
- (void)prepare
{
    [super prepare];
    
    // 初始化间距
    self.labelLeftInset = MJRefreshLabelLeftInset;
    
    // 初始化文字
    [self setTitle:@"下拉可以刷新" forState:MJRefreshStateIdle];
    [self setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"" forState:MJRefreshStateRefreshing];
}

- (void)placeSubviews
{
    [super placeSubviews];
    self.loadingView.center = self.stateLabel.center;
//    self.animationView.center = self.stateLabel.center;
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                
                [self.loadingView setHidden:YES];
                
            } completion:^(BOOL finished) {
         
                if (self.state != MJRefreshStateIdle) return;
        
                [self stopAnimation];
            }];
        } else {
            
            [self stopAnimation];
        }
    } else if (state == MJRefreshStatePulling) {
        
        [self stopAnimation];
    
    } else if (state == MJRefreshStateRefreshing) {
        [self startAnimation];
    }
}

#pragma mark - 加载动画效果
- (void)startAnimation
{
    [_loadingView setHidden:NO];
    
    [_loadingView stopAnimating];

    [_loadingView startAnimating];
    
//    return;
//
//    [_loadingView setHidden:NO];
//    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    animation.fromValue = [NSNumber numberWithFloat:0.f];
//    animation.toValue = [NSNumber numberWithFloat: M_PI *2];
//    animation.duration = 1;
//    animation.removedOnCompletion = NO;
//    animation.autoreverses = NO;
//    animation.fillMode = kCAFillModeForwards;
//    animation.repeatCount = MAXFLOAT;
//    [_loadingView.layer addAnimation:animation forKey:nil];
    
    /*************三个组动画****************/
    
    //[self repeateAnimation];
}

- (CAAnimationGroup *)addAnimationStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint
{
    CABasicAnimation *moveAnimation = [CABasicAnimation animationWithKeyPath:@"position"];
    moveAnimation.fromValue = [NSValue valueWithCGPoint:startPoint];
    moveAnimation.toValue   = [NSValue valueWithCGPoint:endPoint];
    moveAnimation.duration = 1.0;
    moveAnimation.repeatCount = MAXFLOAT;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue = [NSNumber numberWithFloat:0.2];
    opacityAnimation.duration = 1.0f;
    opacityAnimation.repeatCount = MAXFLOAT;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.duration = 1.0f;
    groupAnimation.delegate = self;
    groupAnimation.animations = @[moveAnimation, opacityAnimation];
    groupAnimation.repeatCount = MAXFLOAT;
    
    
    return groupAnimation;
}

- (void)repeateAnimation
{
    CAAnimationGroup *groupAnimation1 = [self addAnimationStartPoint:self.pawSecView.layer.position endPoint:CGPointMake(self.pawSecView.center.x -10, self.pawSecView.center.y + 10)];
    [groupAnimation1 setBeginTime:1];
    
    CAAnimationGroup *groupAnimation2 = [self addAnimationStartPoint:self.pawThirView.layer.position endPoint:CGPointMake(self.pawThirView.center.x -10, self.pawThirView.center.y + 10)];
    [groupAnimation2 setBeginTime:1];

    [self.pawOneView.layer addAnimation:[self addAnimationStartPoint:self.pawOneView.layer.position endPoint:CGPointMake(self.pawOneView.center.x -10, self.pawOneView.center.y + 10)] forKey:@"groupAniamtion"];
    
    [self.pawSecView.layer addAnimation:groupAnimation1 forKey:@"groupAniamtion"];

    [self.pawThirView.layer addAnimation:groupAnimation2 forKey:@"groupAniamtion"];
}

- (void)stopAnimation
{
    [_loadingView setHidden:YES];
    [_loadingView.layer removeAllAnimations];
    
    [self.pawThirView.layer removeAllAnimations];
    [self.pawSecView.layer removeAllAnimations];
    [self.pawOneView.layer removeAllAnimations];
}

- (void)animationDidStart:(CAAnimation *)anim
{
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
