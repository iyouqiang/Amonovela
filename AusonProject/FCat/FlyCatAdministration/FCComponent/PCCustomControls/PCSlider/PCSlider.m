

//
//  PCSlider.m
//  PurCowExchange
//
//  Created by Frank on 2018/8/8.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCSlider.h"
#import "PCStyleDefinition.h"

@interface PCSlider()

@property (nonatomic, strong) CAShapeLayer *shadowLayer;
@property (nonatomic, strong) CAShapeLayer *tintLayer;
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@property (nonatomic, strong) UIView *thumbView;
@property (nonatomic, assign) float lineLength;
@property (nonatomic, copy) void (^slideBlock)(float sliderValue);
@property (nonatomic, assign) BOOL isTouch;

@end


@implementation PCSlider

static float const gapWidth = 2;

#pragma life circle

- (instancetype)initWithFrame:(CGRect)frame ScaleLineNumber:(NSInteger)scaleLineNumber{
    
    if (self = [super initWithFrame:frame]) {
        
        self.scaleLineNumber = scaleLineNumber >=2 ? scaleLineNumber : 2;
        //默认值
        self.thumbTintColor = COLOR_HexColor(0xFFB517);
        self.thumbShadowColor = COLOR_HexColor(0x48494E);
        self.thumbDiameter = 11.5;
        self.lineShadowColor = COLOR_HexColor(0x48494E);
        self.lineTintColor = COLOR_HexColor(0xFFB517);
        self.lineWidth = 2;
        self.dotDiameter = 7.5;
        
        float leftWidth = self.frame.size.width - self.scaleLineNumber * self.dotDiameter - (self.scaleLineNumber -1) * 2 * gapWidth;
        
        if (leftWidth > 0) {
            
            self.lineLength = (leftWidth*1.0) / (self.scaleLineNumber - 1);
           [self setup];
        }
    }
    
    return self;
}

- (void)monitorSliderValue:(void(^)(float))sliderValue{
    
    self.slideBlock = sliderValue;
}

- (void)setup{
    
    self.shadowLayer = [self customShapeLayerWithFillColor:self.lineShadowColor];
    self.tintLayer = [self customShapeLayerWithFillColor:self.lineTintColor];
    [self setupMasklayer];
    [self.layer addSublayer:self.shadowLayer];
    [self.layer addSublayer:self.tintLayer];
    [self setupThumbView];
    
    
    [self setupTapGesture];
//    [self setupPanGesture];
}

- (void)setupMasklayer{
    
    self.maskLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, 0)];
    [path addLineToPoint:CGPointMake(CGRectGetMaxX(self.bounds), 0)];
    self.maskLayer.path = path.CGPath;
    self.maskLayer.strokeColor = self.lineTintColor.CGColor;
    self.maskLayer.lineWidth = self.bounds.size.height*2;
    
    self.maskLayer.strokeEnd = 0.0f;

    self.tintLayer.mask = _maskLayer;
}

- (void)setupThumbView{
   
    float thumbWidth = self.frame.size.height;
    CAShapeLayer *thumbLayer = [CAShapeLayer layer];
    thumbLayer = [CAShapeLayer layer];
    thumbLayer.frame = CGRectMake(0, 0, _thumbDiameter, _thumbDiameter);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((thumbWidth - _thumbDiameter)/2.0, (thumbWidth - _thumbDiameter)/2.0, _thumbDiameter, _thumbDiameter) cornerRadius:_thumbDiameter/2.0];
    thumbLayer.path = path.CGPath;
    thumbLayer.fillColor = self.lineTintColor.CGColor;
    thumbLayer.lineWidth = 0;

    self.thumbView = [[UIView alloc] initWithFrame:CGRectMake( (_dotDiameter -thumbWidth)/2.0, 0, thumbWidth, thumbWidth)];
    [self.thumbView.layer addSublayer: thumbLayer];
    [self addSubview:self.thumbView];
}


- (void)setupTapGesture{
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self addGestureRecognizer:tap];
}


- (CAShapeLayer *)customShapeLayerWithFillColor:(UIColor *)fillColor{
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = self.frame;
    
    for (int i = 0; i < self.scaleLineNumber; i++) {
        
        CAShapeLayer *cirle = [self circleLayerWithFillColor:fillColor];
        cirle.frame = CGRectMake(i*(_dotDiameter + gapWidth*2 + self.lineLength), (self.bounds.size.height - _dotDiameter)/2.0, _dotDiameter, _dotDiameter);
        [shapeLayer addSublayer:cirle];
        
        if (i != self.scaleLineNumber - 1) {
            
            CAShapeLayer *line = [self lineLayerWithColor:fillColor];
            line.frame = CGRectMake(i*(_dotDiameter + gapWidth*2 + _lineLength) + gapWidth + _dotDiameter, (self.bounds.size.height - _lineWidth)/2.0, _lineLength, _lineWidth);
            [shapeLayer addSublayer:line];
        }
    }
    
    return shapeLayer;
}

- (CAShapeLayer *)circleLayerWithFillColor:(UIColor *)fillColor{
    
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.strokeColor = fillColor.CGColor;
    circleLayer.fillColor = fillColor.CGColor;
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, _dotDiameter, _dotDiameter) cornerRadius:_dotDiameter/2.0];
    circleLayer.lineWidth = 1;
    circleLayer.path = path.CGPath;
    
    return circleLayer;
}

- (CAShapeLayer *)lineLayerWithColor:(UIColor *)fillColor{
    
    CAShapeLayer *linelayer = [CAShapeLayer layer];
    linelayer.strokeColor = [UIColor clearColor].CGColor;
    linelayer.fillColor = fillColor.CGColor;
    linelayer.lineWidth = 0;
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, self.lineLength, self.lineWidth)];
    linelayer.path = path.CGPath;
    
    return linelayer;
}

#pragma -mark private

- (void)tapAction:(UITapGestureRecognizer *)tap{
    
    if (tap.state == UIGestureRecognizerStateEnded) {
        
        CGPoint point = [tap locationInView:self];
        point.x = point.x > self.bounds.size.width ? self.bounds.size.width : point.x;
        [self setSliderValue:point.x/self.bounds.size.width];
        
        if (self.slideBlock) {
            
            self.slideBlock(self.value);
        }
    }
}

#pragma -mark public

- (void)setSliderValue:(float)value{

     float thumbWidth = self.frame.size.height;
    value = value <= 0 ? 0 : value > 1 ? 1 : value;
    self.maskLayer.strokeEnd = value;
    self.value = value;
    float positionX = (self.bounds.size.width - self.dotDiameter)* value;
    self.thumbView.center = CGPointMake(positionX + _dotDiameter/2.0, thumbWidth/2.0);
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    CGPoint transpoint = [self convertPoint:point toView:self.thumbView];

    self.isTouch = CGRectContainsPoint(self.thumbView.bounds, transpoint) ? YES : NO;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{

    if (_isTouch) {

        UITouch* touch = [touches anyObject];
        CGPoint currentP = [touch locationInView:self];
        float transValue = currentP.x/self.frame.size.width;

        [self setSliderValue:transValue];

        if (self.slideBlock) {

            self.slideBlock(self.value);
        }
    }
}



@end
