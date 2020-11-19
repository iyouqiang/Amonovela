//
//  FCBannerCarouselView.m
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/24.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCBannerCarouselView.h"
#import <iCarousel/iCarousel.h>
#import <Masonry/Masonry.h>
#import "PCStyleDefinition.h"
#import "PCMacroDefinition.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface FCBannerCarouselView()<iCarouselDelegate, iCarouselDataSource>

@property (nonatomic, strong) iCarousel *bannerView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UIPageControl *pageView;

@end

@implementation FCBannerCarouselView


- (instancetype)initWithFrame:(CGRect)frame
{
   self = [super initWithFrame:frame];
    
    if (self) {
        
        _bannerView = [[iCarousel alloc] init];
        _bannerView.autoscroll = 0;
        _bannerView.pagingEnabled = YES;
        _bannerView.type = iCarouselTypeLinear;
        _bannerView.scrollSpeed = 0.2;
        _bannerView.delegate = self;
        _bannerView.dataSource = self;
        [self addSubview:_bannerView];
        
        _pageView = [[UIPageControl alloc] init];
        _pageView.tintColor = COLOR_HexColor(0xFEC92D);
        _pageView.pageIndicatorTintColor = [UIColor whiteColor];
        _pageView.currentPageIndicatorTintColor = COLOR_HexColor(0xFEC92D);
        [self addSubview:_pageView];
        
        [_pageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.mas_equalTo(self.mas_bottom);
        }];
        [_bannerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    
    return self;
}

- (void)setDataSource:(NSMutableArray *)dataSource
{
    _dataSource = dataSource;
    [self.bannerView reloadData];
    
    if (_dataSource.count <=1) {
        
        [_pageView setHidden:YES];
        return;
    }
    
    [_pageView setHidden:false];
    _pageView.numberOfPages = dataSource.count;
    [self starTimer];
}

- (void)starTimer {
    
    [_timer invalidate];
    _timer = [NSTimer scheduledTimerWithTimeInterval:2 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        [self timerCount];
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:UITrackingRunLoopMode];
}

- (void)timerCount {
    
    if (_count >= [self.dataSource count]) {
        _count = 0;
    }
    
    [_bannerView scrollToItemAtIndex:_count+1 animated:YES];
    _count ++;
}

#pragma mark - delegate datasource

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [self.dataSource count];
}

- (CGFloat)carouselItemWidth:(iCarousel *)carousel
{
    return CGRectGetWidth(self.frame);
}

- (void)carouselWillBeginDragging:(iCarousel *)carousel
{
    [_timer timeInterval];
}

- (void)carouselDidEndDragging:(iCarousel *)carousel willDecelerate:(BOOL)decelerate
{
    [self starTimer];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view{
    if (view == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [imageView sd_setImageWithURL:[NSURL URLWithString:self.dataSource[index]] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            
        }];
      
        imageView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(carousel.bounds));
        return imageView;
    }else{
        //view.backgroundColor = self.dataSource[index];
        return view;
    }
    return nil;
}

- (void)carousel:(__unused iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index {
    //NSLog(@"Tapped view number: %ld", (long)index);
    
    if (self.didSelectedItemBlock) {
        self.didSelectedItemBlock(index);
    }
}

- (void)carouselCurrentItemIndexDidChange:(__unused iCarousel *)carousel {
    _count = self.bannerView.currentItemIndex;
    _pageView.currentPage = _count;
    //NSLog(@"Index: %@", @(self.bannerView.currentItemIndex));
    
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value {
    switch (option) {
        case iCarouselOptionWrap:
            return YES;
        case iCarouselOptionShowBackfaces:
            
            break;
        case iCarouselOptionOffsetMultiplier:
            
            break;
        case iCarouselOptionVisibleItems:
            
            break;
        case iCarouselOptionCount:
            
            break;
        case iCarouselOptionArc:
            
            break;
        case iCarouselOptionAngle:
            
            break;
        case iCarouselOptionRadius:
            
            break;
        case iCarouselOptionTilt:
            
            break;
        case iCarouselOptionSpacing:
            
            break;
        case iCarouselOptionFadeMin:
            
            break;
        case iCarouselOptionFadeMax:
            
            break;
        case iCarouselOptionFadeRange:
            
            break;
        case iCarouselOptionFadeMinAlpha:
            
            break;
    }

    return value;
}
 

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
