//
//  UIView+Fillet.h
//  PurCowExchange
//
//  Created by Frank on 2018/7/7.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Fillet)

@property (nonatomic, copy) void(^ _Nonnull callBackCompleteBlock)(NSError * _Nonnull error);

/**添加圆角并描边（描边可以透明）*/
- (void)pc_addCornerWithRadius:(CGFloat)cornerRadius andStrokeColor:(nullable UIColor *)strokeColor;

/**添加圆角/描边, 并设置填充颜色*/
- (void)pc_addCornerWithRadius:(CGFloat)cornerRadius fillColor:(nullable UIColor *)fillColor strokeColor:(nullable UIColor *)strokeColor borderWidth:(CGFloat) borderWidth;

/**仅仅设置边框*/
- (void)pc_addBorderWithColor:(UIColor *_Nonnull)borderColor width:(float)borderWidth;

// 长截图 类型可以是 tableView或者scrollView 等可以滚动的视图 根据需要自己改
- (UIImage *_Nullable)saveLongImage:(UIScrollView *_Nullable)scrollView height:(CGFloat)height;

- (void)saveImage:(UIImage *_Nullable)image completeBlock:(void(^_Nullable)(NSError *_Nullable))completeBlock;

// 生成二维码
- (UIImage *_Nullable)qrcodeImageURL:(NSString *_Nullable)url;

@end
