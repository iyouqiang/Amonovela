//
//  PCSlider.h
//  PurCowExchange
//
//  Created by Frank on 2018/8/8.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,PCSliderStyle)
{
    PCSliderStyle_Point = 1  /*默认样式 例如 ○--------○--------○--------○--------○*/
};


@interface PCSlider : UIControl

/**
 刻度样式 详情参考 枚举值 CLSliderStyle 默认 CLSliderStyle_Nomal
 */
@property (nonatomic) PCSliderStyle sliderStyle;

/**
 滑块填充颜色
 */
@property (nonatomic) UIColor *thumbTintColor;

/**
 滑块阴影颜色
 */
@property (nonatomic) UIColor *thumbShadowColor;

/**
 滑块阴影透明度
 */
@property (nonatomic) CGFloat thumbShadowOpacity;

/**
 滑块直径 默认4;
 */
@property (nonatomic) CGFloat thumbDiameter;

/**
 圆点直径 默认5;
 */
@property (nonatomic) CGFloat dotDiameter;

/**
  线条颜色
 */
@property (nonatomic) UIColor *lineShadowColor;

@property (nonatomic) UIColor *lineTintColor;

/**
 刻度线 线条宽度
 */
@property (nonatomic,assign) CGFloat lineWidth;

/**
 刻度线 刻度数量
 */
@property (nonatomic,assign) NSInteger scaleLineNumber;

@property (nonatomic, assign) float value;



- (instancetype)initWithFrame:(CGRect)frame ScaleLineNumber:(NSInteger)scaleLineNumber;

- (void)monitorSliderValue:(void(^)(float))sliderValue;


/**
 设置 滑块的值, 默认为0
 */
- (void)setSliderValue:(float)value;

/**
 设置 滑块选中的刻度索引 无动画效果
 */



@end
