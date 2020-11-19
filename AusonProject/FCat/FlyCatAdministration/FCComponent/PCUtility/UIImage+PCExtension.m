//
//  UIImage+PCExtension.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/14.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UIImage+PCExtension.h"
#import <objc/runtime.h>
@implementation UIImage (PCExtension)

+ (UIImage *)at_imageWithColor:(UIColor *)color withSize:(CGSize)size
{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)at_launchImageForOrientation:(UIDeviceOrientation)orientation {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSArray *launchImagesArray = [infoDict objectForKey:@"UILaunchImages"];
    
    CGSize viewSize = [UIScreen mainScreen].bounds.size;
    NSString *viewOrientation = @"Portrait";
    if (UIDeviceOrientationIsLandscape(orientation)) {
        viewSize = CGSizeMake(viewSize.height, viewSize.width);
        viewOrientation = @"Landscape";
    }
    
    NSString *launchImageName = @"Default";
    for (NSDictionary *launchImageDict in launchImagesArray) {
        CGSize imageSize = CGSizeFromString(launchImageDict[@"UILaunchImageSize"]);
        if (CGSizeEqualToSize(imageSize, viewSize)
            && [viewOrientation isEqualToString:launchImageDict[@"UILaunchImageOrientation"]]) {
            launchImageName = launchImageDict[@"UILaunchImageName"];
            
            break;
        }
    }
    
    //UIImage *launchImage = [UIImage imageNamed:launchImageName];
    
    NSString *imageUrl = [[NSBundle mainBundle].resourcePath stringByAppendingFormat:@"/%@.png", launchImageName];
    UIImage *launchImage = [UIImage imageWithContentsOfFile:imageUrl];
    
    return launchImage;
}

+ (UIImage *)at_APPLocalIcon
{
    NSDictionary *infoPlist = [[NSBundle mainBundle] infoDictionary];
    NSString *icon = [[infoPlist valueForKeyPath:@"CFBundleIcons.CFBundlePrimaryIcon.CFBundleIconFiles"] lastObject];
    return [UIImage imageNamed:icon];
}

// 对指定视图进行截图
+ (UIImage *)screenShotView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size,YES, 0.0);
    [view.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage*aImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
        return aImage;//UIImagePNGRepresentation(aImage);
}

@end
