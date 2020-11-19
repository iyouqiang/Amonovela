//
//  UILabel+FJAttribute.m
//  GXQApp
//
//  Created by Yochi on 2018/6/7.
//  Copyright © 2018年 jinfuzi. All rights reserved.
//

#import "UILabel+FJAttribute.h"

@implementation UILabel (FJAttribute)

- (void)addlineSpacing:(CGFloat)lineSpacing
{
    NSString *message = self.text;
    NSMutableAttributedString * attributedStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.lineSpacing = lineSpacing;
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    [self setAttributedText:attributedStr];
}

- (void)addunderLine:(UIColor*)underLineColor range:(NSRange)range
{
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:self.text];

    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:underLineColor
                          range:range];
    [attributedStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];
    [self setAttributedText:attributedStr];
}

- (void)setAttributeColor:(UIColor*)textColor range:(NSRange)range
{
    NSMutableAttributedString * attributedStr = attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:textColor
                          range:range];
    
    [self setAttributedText:attributedStr];
}

- (void)setAttributeFont:(UIFont*)font range:(NSRange)range
{
    NSMutableAttributedString * attributedStr = attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //给富文本添加属性1-字体大小
    [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    
    [self setAttributedText:attributedStr];
}

- (void)setAttributeFont:(UIFont*)font attributeColor:(UIColor*)textColor range:(NSRange)range lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString * attributedStr = attributedStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    
    //给富文本添加属性1-字体大小
    [attributedStr addAttribute:NSFontAttributeName value:font range:range];
    
    //给富文本添加属性2-字体颜色
    [attributedStr addAttribute:NSForegroundColorAttributeName
                          value:textColor
                          range:range];
    
    //给富文本添加属性3-下划线
    //[attributedStr addAttribute:NSUnderlineStyleAttributeName value:@(NSUnderlineStyleSingle) range:NSMakeRange(2, 2)];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    
    paragraphStyle.lineSpacing = lineSpacing;
    
    [attributedStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0,self.text.length)];
    
    [self setAttributedText:attributedStr];
}

- (CGFloat)labelWidthMaxHeight:(CGFloat)height
{
    /** 计算富文本大小 */
    NSString *tempMessage = [self.text stringByReplacingOccurrencesOfString:@" " withString:@"k"];
    
    CGSize messageSize = [tempMessage boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    return messageSize.width+5;
}

- (CGFloat)labelHeightMaxWidth:(CGFloat)width
{
    /** 计算富文本大小 */
    NSString *tempMessage = [self.text stringByReplacingOccurrencesOfString:@" " withString:@"k"];
    
    CGSize messageSize = [tempMessage boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.font} context:nil].size;
    
    return messageSize.height+5;
}

@end
