//
//  UIView+Fillet.m
//  PurCowExchange
//
//  Created by Frank on 2018/7/7.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UIView+Fillet.h"
#import <objc/runtime.h>

@implementation UIView (Fillet)

static NSString *CallBackCompleteKEY = @"CallBackCompleteBlock";

- (void)setCallBackCompleteBlock:(void (^)(NSError *))callBackCompleteBlock
{
    if (callBackCompleteBlock != self.callBackCompleteBlock) {
        
        [self willChangeValueForKey:@"CallBack"];
        objc_setAssociatedObject(self, &CallBackCompleteKEY,
                                 callBackCompleteBlock,
                                 OBJC_ASSOCIATION_COPY_NONATOMIC);
        [self didChangeValueForKey:@"CallBack"];
    }
}

- (void (^)(NSError *))callBackCompleteBlock
{
    return objc_getAssociatedObject(self, &CallBackCompleteKEY);
}


- (void)pc_addCornerWithRadius:(CGFloat)cornerRadius andStrokeColor:(nullable UIColor *)strokeColor{
    
    [self pc_addCornerWithRadius:cornerRadius fillColor:[UIColor clearColor] strokeColor:strokeColor borderWidth:0];
}

- (void)pc_addCornerWithRadius:(CGFloat)cornerRadius fillColor:(nullable UIColor *)fillColor strokeColor:(nullable UIColor *)strokeColor borderWidth:(CGFloat) borderWidth{
    
    self.backgroundColor = [UIColor clearColor];
    
    CGSize size = self.bounds.size;
    
    if (self.constraints.count) {
        //获取设置约束之后的size
        size = [self systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    }

    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    UIBezierPath* p = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderWidth, borderWidth, size.width - borderWidth*2, size.height - borderWidth*2) cornerRadius:cornerRadius];
    
    [fillColor setFill];
    [p fill];
    
    if (borderWidth) {
        [strokeColor setStroke];
        p.lineWidth = borderWidth;
        [p stroke];
    }
    
    UIImage* im = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.layer.contents = (__bridge id)im.CGImage;
}

- (void)pc_addBorderWithColor:(UIColor *)borderColor width:(float)borderWidth{
    
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
}

// 长截图 类型可以是 tableView或者scrollView 等可以滚动的视图 根据需要自己改

- (UIImage *)saveLongImage:(UIScrollView *)scrollView height:(CGFloat)height
{
    UIImage* image = nil;
    
    if (height <=0) {
        height = scrollView.contentSize.height;
    }
    
    // 下面方法，第一个参数表示区域大小。第二个参数表示是否是非透明的。如果需要显示半透明效果，需要传NO，否则传YES。第三个参数就是屏幕密度了，调整清晰度。
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(scrollView.contentSize.width, height), YES, [UIScreen mainScreen].scale);
    
    CGPoint savedContentOffset = scrollView.contentOffset;
    
    CGRect savedFrame = scrollView.frame;
    
    scrollView.contentOffset = CGPointZero;
    
    scrollView.frame = CGRectMake(0, 0, scrollView.contentSize.width, height);
    
    [scrollView.layer renderInContext: UIGraphicsGetCurrentContext()];
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    
    scrollView.contentOffset = savedContentOffset;
    
    scrollView.frame = savedFrame;
    
    UIGraphicsEndImageContext();

    return image;
}

- (void)saveImage:(UIImage *)image completeBlock:(void(^)(NSError *))completeBlock
{
    self.callBackCompleteBlock = completeBlock;
    
    if (image != nil) {
        
        //保存图片到相册
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), NULL);
    }
}

// 保存后回调方法

- (void)image: (UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    NSString *msg = nil ;
    
    if(error != NULL){
        
        msg = @"保存图片失败" ;
        
    }else{
        
        msg = @"保存图片成功，可到相册查看" ;
    }
    
    if (self.callBackCompleteBlock) {
        
        self.callBackCompleteBlock(error);
    }
}

// 生成二维码
- (UIImage *)qrcodeImageURL:(NSString *)url
{
    //创建过滤器
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //过滤器恢复默认
    [filter setDefaults];
    
    //给过滤器添加数据
    NSString *string = url;
    
    //将NSString格式转化成NSData格式
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    //获取二维码过滤器生成的二维码
    CIImage *image = [filter outputImage];
    
    //将获取到的二维码添加到imageview上
    return [self createNonInterpolatedUIImageFormCIImage:image withSize:40];
}

- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

@end
