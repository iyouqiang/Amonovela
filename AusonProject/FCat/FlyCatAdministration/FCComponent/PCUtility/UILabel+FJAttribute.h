//
//  UILabel+FJAttribute.h
//  GXQApp
//
//  Created by Yochi on 2018/6/7.
//  Copyright © 2018年 jinfuzi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (FJAttribute)

- (void)addlineSpacing:(CGFloat)lineSpacing;

- (void)setAttributeColor:(UIColor*)textColor range:(NSRange)range;

- (void)setAttributeFont:(UIFont*)font range:(NSRange)range;

- (void)addunderLine:(UIColor*)underLineColor range:(NSRange)range;

- (void)setAttributeFont:(UIFont*)font attributeColor:(UIColor*)textColor range:(NSRange)range lineSpacing:(CGFloat)lineSpacing;

- (CGFloat)labelWidthMaxHeight:(CGFloat)height;

- (CGFloat)labelHeightMaxWidth:(CGFloat)width;

@end
