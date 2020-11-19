//
//  UINavigationBar+CustomStyle.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/14.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UINavigationBar+CustomStyle.h"
#import <objc/runtime.h>
#import "PCPublicClassDefinition.h"

@interface UINavigationBar ()
@property (nonatomic, strong, setter=setMaskLayer:) UIView *maskLayer;
@end

@implementation UINavigationBar (CustomStyle)

/** 设置背景色 */
- (void)at_setBackgroundColor:(UIColor *)backgroundColor
{
    self.maskLayer.backgroundColor = backgroundColor;
}

/** 设置线条颜色 */
- (void)at_setBottomLineColor:(UIColor *)color
{
    [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    UIImage *line = [UIImage at_imageWithColor:color withSize:CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 0.15)];
    [self at_setBottomLineImage:line];
}

/** 设置背景图片 */
- (void)at_setBackgroundImage:(UIImage *)backgroundImage
{
     [self setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
}

/** 设置线条图片 */
- (void)at_setBottomLineImage:(UIImage *)image
{
    [self setShadowImage:[UIImage new]];
    [self setShadowImage:image];
}

/** 设置内容透明度 */
- (void)at_setContentAlpha:(CGFloat)alpha
{
    [self _setAlpha:alpha forSubviewsOfView:self];
    [self at_setBottomLineAlpha:alpha];
}

- (void)_setAlpha:(CGFloat)alpha forSubviewsOfView:(UIView *)view
{
    for (UIView *v in view.subviews) {
        
        if ([v isKindOfClass:NSClassFromString(@"_UINavigationBarBackIndicatorView")]) {
            continue;
        } else if ([v isKindOfClass:NSClassFromString(@"UINavigationItemButtonView")]) {
            continue;
        } else if ([v isKindOfClass:NSClassFromString(@"UINavigationItemView")]){
            continue;
        }
        
        v.alpha = alpha;
        
        [self _setAlpha:alpha forSubviewsOfView:v];
    }
}

/** 设置线条透明度 */
- (void)at_setBottomLineAlpha:(CGFloat)alpha
{
    [self at_setBottomLineColor:[UIColor colorWithRed:0.600 green:0.600 blue:0.600 alpha:alpha]];
}

- (void)at_setNavigationtitleTextAttributes:(NSDictionary *)AttributeDic
{
    self.titleTextAttributes = AttributeDic;
}

#pragma mark - setter/getter
- (UIView *)maskLayer
{
    UIView *layer = objc_getAssociatedObject(self, _cmd);
    if (!layer) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        layer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), CGRectGetHeight(self.bounds) + [UIApplication sharedApplication].statusBarFrame.size.height)];
        layer.userInteractionEnabled = NO;
        layer.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
        [[[self subviews] firstObject] insertSubview:layer atIndex:0];
        [self setMaskLayer:layer];
    }
    self.backgroundColor = [UIColor clearColor];
    return layer;
}

- (void)setMaskLayer:(UIView *)maskLayer
{
    objc_setAssociatedObject(self, @selector(maskLayer), maskLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
