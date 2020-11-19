//
//  FCShareItemView.m
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCShareItemView.h"
#import "FlyCatAdministration-Swift.h"
#import "FCToast.h"

@interface FCShareItemView ()

@end

@implementation FCShareItemView

- (void)awakeFromNib
{
    [super awakeFromNib];
}

#pragma mark - save Image

- (void)saveImage:(UIImage *)image{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    };
}

//保存完成后调用的方法
- (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    
    if (error) {
        NSLog(@"save error%@", error.localizedDescription);
        [FCToast showToastAction:error.localizedDescription];
    }
    else {
        
        if (self.cancelShareItemBlock) {
            self.cancelShareItemBlock();
        }
        
        [FCToast showToastAction:@"保存成功"];
    }
}

#pragma mark - btnAction
- (IBAction)shareItemSaveImgAction:(id)sender {
    
    /// 保存图片到相册
    [self saveImage:self.shareImage];
}

- (IBAction)shareItemWechatCircleAction:(id)sender {
    
    if (self.cancelShareItemBlock) {
        self.cancelShareItemBlock();
    }
}

- (IBAction)shareItemWechatAction:(id)sender {
    
    if (self.cancelShareItemBlock) {
        self.cancelShareItemBlock();
    }
}

- (IBAction)shareItemTelegramAction:(id)sender {
    
    if (self.cancelShareItemBlock) {
        self.cancelShareItemBlock();
    }
}

- (IBAction)shareItemCancelAction:(id)sender {
    
    if (self.cancelShareItemBlock) {
        self.cancelShareItemBlock();
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
