//
//  YTKAnimatingRequestAccessory.m
//  Ape_uni
//
//  Created by Chenyu Lan on 10/30/14.
//  Copyright (c) 2014 Fenbi. All rights reserved.
//

#import "YTKAnimatingRequestAccessory.h"

@implementation YTKAnimatingRequestAccessory

+ (id)accessoryWithAnimatingView
{
    YTKAnimatingRequestAccessory *accessory = [[self alloc] init];
    [[UIApplication sharedApplication].keyWindow addSubview:accessory.indicatorView];
    accessory.indicatorView.center = [UIApplication sharedApplication].keyWindow.center;
    return accessory;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:(UIActivityIndicatorViewStyleWhite)];
        [_indicatorView hidesWhenStopped];
    }
    
    return _indicatorView;
}

- (id)initWithAnimatingView:(UIView *)animatingView animatingText:(NSString *)animatingText {
    self = [super init];
    if (self) {
        _animatingView = animatingView;
        _animatingText = animatingText;
    }
    return self;
}

- (id)initWithAnimatingView:(UIView *)animatingView {
    self = [super init];
    if (self) {
        _animatingView = animatingView;
    }
    return self;
}

+ (id)accessoryWithAnimatingView:(UIView *)animatingView {
    return [[self alloc] initWithAnimatingView:animatingView];
}

+ (id)accessoryWithAnimatingView:(UIView *)animatingView animatingText:(NSString *)animatingText {
    return [[self alloc] initWithAnimatingView:animatingView animatingText:animatingText];
}

- (void)requestWillStart:(id)request {
    
    if (_animatingView) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
  
            NSLog(@" loading start");
            
        });
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.indicatorView startAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        });
    }
}

- (void)requestWillStop:(id)request {
    
    if (_animatingView) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
  
            NSLog(@" loading finished");
        });
    }else {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.indicatorView stopAnimating];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        });
    }
}

@end
