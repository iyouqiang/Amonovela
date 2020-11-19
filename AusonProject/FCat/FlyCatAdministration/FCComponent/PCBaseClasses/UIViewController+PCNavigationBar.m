//
//  UIViewController+PCNavigationBar.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/13.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "UIViewController+PCNavigationBar.h"
#import "PCPublicClassDefinition.h"
#import <objc/runtime.h>
#import "UIViewController+PCNavigationBar.h"

static void *kNAVIGATiONRIGHTITESKEY = &kNAVIGATiONRIGHTITESKEY;
static void *kNAVIGATiON_LEFTITESKEY = &kNAVIGATiON_LEFTITESKEY;
static void *kNAVIGATiONLEFTBLOCKKEY = &kNAVIGATiONLEFTBLOCKKEY;
static void *kNAVIGATiONRIGHTBLOCKEVENTKEY = &kNAVIGATiONRIGHTBLOCKEVENTKEY;
static void *kNAVIGATiON_LEFTBLOCKEVENTKEY = &kNAVIGATiON_LEFTBLOCKEVENTKEY;

@implementation UIViewController (PCNavigationBar)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        CATSwizzeMethod([self class],
                        @selector(viewWillAppear:),
                        @selector(at_viewWillAppear:));
        
        CATSwizzeMethod([self class],
                        @selector(viewDidAppear:),
                        @selector(at_viewDidAppear:));
        
        CATSwizzeMethod([self class],
                        @selector(viewDidLoad),
                        @selector(at_viewDidLoad));
        
        CATSwizzeMethod([self class],
                        @selector(viewWillDisappear:),
                        @selector(at_viewWillDisAppear:));
    });
}

- (void)at_viewDidLoad
{
    [self adjuestInsets];
    
    [self.navigationController.navigationBar at_setBackgroundColor:COLOR_BarNormalColor]; 
    [self.navigationController.navigationBar at_setBottomLineColor:COLOR_HexColor(0x1A1A21)];
    [self.navigationController.navigationBar at_setNavigationtitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    //self.navigationController.navigationBar.translucent = NO;
    //NSFontAttributeName navigationGobackAction
    
    if (self.navigationController.viewControllers.count != 1) {
        
        Weak_Self(self);
        [self addleftNavigationItemImgNameStr:@"navbar_back" title:nil textColor:nil textFont:nil clickCallBack:^{
            Strong_Self(self);
            
            /** 外部调用返回事件 - (void)navigationGobackAction */
#pragma clang diagnostic push
            
#pragma clang diagnostic ignored"-Wundeclared-selector"
            
            if ([self respondsToSelector:@selector(navigationGobackAction)]) {
                
                [self performSelector:@selector(navigationGobackAction)];
            }else {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
#pragma clang diagnostic pop
            
        }];
    }
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self at_viewDidLoad];
}

- (void)at_viewWillAppear:(BOOL)animated
{
    [self at_viewWillAppear:animated];
}

- (void)at_viewDidAppear:(BOOL)animated
{
    [self at_viewDidAppear:animated];
}


- (void)at_viewWillDisAppear:(BOOL)animated
{
    [self at_viewWillDisAppear:animated];
    
    //停止所有加载样式
    [self allIndicatorViewStop];
}

- (void)adjuestInsets
{
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

#pragma mark - 导航栏事件

/** 移除左右两侧按钮 */
- (void)removeLeftItems
{
    [self.leftBlockArrays removeAllObjects];
    [self.leftItems removeAllObjects];
    self.navigationItem.leftBarButtonItem = nil;
    self.navigationItem.leftBarButtonItems = nil;
}

- (void)removeRightItems
{
    [self.rightBlockArrays removeAllObjects];
    [self.rightItems removeAllObjects];
    self.navigationItem.rightBarButtonItems = nil;
    self.navigationItem.rightBarButtonItem = nil;
}

/** 左侧添加多个按钮 */
- (UIButton *)addmutableleftNavigationItemImgNameStr:(NSString *)imgName title:(NSString *)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont clickCallBack:(void(^)(void))clickCallBackBlock
{
    if (clickCallBackBlock) {
        
        [self.leftBlockArrays addObject:clickCallBackBlock];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.contentHorizontalAlignment =  UIControlContentHorizontalAlignmentLeft;
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (textFont) {
        button.titleLabel.font = textFont;
    }else {
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    CGFloat imgsizewidth = 0.0;
    if (imgName.length>0) {
        
        UIImage *btnImg = [UIImage imageNamed:imgName];
        imgsizewidth = btnImg.size.width;
        [button setImage:btnImg forState:UIControlStateNormal];
    }
    
    if (title.length > 0) {
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: button.titleLabel.font} context:nil].size;
        button.frame = CGRectMake(0, 0, size.width + 10 + imgsizewidth, 40);
        [button setTitle:title forState:UIControlStateNormal];
        
        if (textColor) {
            
            [button setTitleColor:textColor forState:UIControlStateNormal];
        }else {
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    button.tag = self.leftItems.count + 411;
    [button addTarget:self action:@selector(leftNavigationBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.leftItems addObject:barItem];
    self.navigationItem.leftBarButtonItems = self.leftItems;
    
    return button;
}

/** 左侧添加导航栏按钮  */
- (UIButton *)addleftNavigationItemImgNameStr:(NSString *)imgName title:(NSString *)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont clickCallBack:(void(^)(void))clickCallBackBlock;
{
    self.navigationItem.leftBarButtonItem = nil;
    
    if (clickCallBackBlock) {
        
        self.leftNavigationItemBlock = clickCallBackBlock;
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    if (textFont) {
        button.titleLabel.font = textFont;
    }else {
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    button.frame = CGRectMake(0, 0, 40, 40);
    CGFloat imgsizewidth = 0.0;
    if (imgName.length>0) {
        
        UIImage *btnImg = [UIImage imageNamed:imgName];
        imgsizewidth = btnImg.size.width;
        [button setImage:btnImg forState:UIControlStateNormal];
    }
    
    if (title.length > 0) {
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: button.titleLabel.font} context:nil].size;
        button.frame = CGRectMake(0, 0, size.width + 10 + imgsizewidth, 40);
        [button setTitle:title forState:UIControlStateNormal];
        
        if (textColor) {
            
            [button setTitleColor:textColor forState:UIControlStateNormal];
        }else {
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    [button addTarget:self action:@selector(leftNavigationBarItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barItem;
    
    return button;
}

/** 右侧添加导航栏按钮 */
- (UIButton *)addrightNavigationItemImgNameStr:(NSString *)imgName title:(NSString *)title textColor:(UIColor*)textColor textFont:(UIFont*)textFont clickCallBack:(void(^)(void))clickCallBackBlock;
{
    if (clickCallBackBlock) {
        
        [self.rightBlockArrays addObject:clickCallBackBlock];
    }
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 40, 40);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    
    if (textFont) {
        button.titleLabel.font = textFont;
    }else {
        button.titleLabel.font = [UIFont systemFontOfSize:14];
    }
    
    CGFloat imgsizewidth = 0.0;
    if (imgName.length>0) {
        
        UIImage *btnImg = [UIImage imageNamed:imgName];
        imgsizewidth = btnImg.size.width;
        [button setImage:btnImg forState:UIControlStateNormal];
    }
    
    if (title.length > 0) {
        
        CGSize size = [title boundingRectWithSize:CGSizeMake(MAXFLOAT, 40.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: button.titleLabel.font} context:nil].size;
        button.frame = CGRectMake(0, 0, size.width + 10 + imgsizewidth, 40);
        [button setTitle:title forState:UIControlStateNormal];
        
        if (textColor) {
            
            [button setTitleColor:textColor forState:UIControlStateNormal];
        }else {
            
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    button.tag = self.rightItems.count + 114;
    [button addTarget:self action:@selector(rightNavigationBarItemAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    [self.rightItems addObject:barItem];
    self.navigationItem.rightBarButtonItems = self.rightItems;
    
    return button;
}

/** 左右按钮方法 */
- (void)rightNavigationBarItemAction:(UIButton *)sender
{
    if (self.rightBlockArrays.count > (sender.tag - 114)) {
        
        void(^callBack)(void) = self.rightBlockArrays[sender.tag - 114];
        
        if (callBack) {
            
            callBack();
        }
    }
}

- (void)leftNavigationBarItemAction:(UIButton *)sender
{
    if (self.leftBlockArrays.count > (sender.tag - 411)) {
        
        void(^callBack)(void) = self.leftBlockArrays[sender.tag - 411];
        
        if (callBack) {
            
            callBack();
        }
    }
}

- (void)leftNavigationBarItemAction
{
    Weak_Self(self);
    if (self.leftNavigationItemBlock) {
    
        Strong_Self(self);
        self.leftNavigationItemBlock();
    }
}

#pragma mark - 属性初始化
- (void)setRightItems:(NSMutableArray *)rightItems
{
    objc_setAssociatedObject(self, kNAVIGATiONRIGHTITESKEY, rightItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setRightBlockArrays:(NSMutableArray *)rightBlockArrays
{
    objc_setAssociatedObject(self, kNAVIGATiONRIGHTBLOCKEVENTKEY, rightBlockArrays, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLeftItems:(NSMutableArray *)leftItems
{
    objc_setAssociatedObject(self, kNAVIGATiON_LEFTITESKEY, leftItems, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLeftBlockArrays:(NSMutableArray *)leftBlockArrays
{
    objc_setAssociatedObject(self, kNAVIGATiON_LEFTBLOCKEVENTKEY, leftBlockArrays, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLeftNavigationItemBlock:(void (^)(void))leftNavigationItemBlock
{
    objc_setAssociatedObject(self, kNAVIGATiONLEFTBLOCKKEY, leftNavigationItemBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray*)rightItems
{
    NSMutableArray *rightItems = objc_getAssociatedObject(self, kNAVIGATiONRIGHTITESKEY);
    
    if (!rightItems) {
        
        rightItems = [NSMutableArray array];
        
        self.rightItems = rightItems;
    }
    
    return rightItems;
}

- (NSMutableArray *)leftItems
{
    NSMutableArray *leftItems = objc_getAssociatedObject(self, kNAVIGATiON_LEFTITESKEY);
    
    if (!leftItems) {
        
        leftItems = [NSMutableArray array];
        
        self.leftItems = leftItems;
    }
    
    return leftItems;
}

- (NSMutableArray *)rightBlockArrays
{
    NSMutableArray *rightBlockArrays = objc_getAssociatedObject(self, kNAVIGATiONRIGHTBLOCKEVENTKEY);
    
    if (!rightBlockArrays) {
        
        rightBlockArrays = [NSMutableArray array];
        
        self.rightBlockArrays = rightBlockArrays;
    }
    
    return rightBlockArrays;
}

- (NSMutableArray *)leftBlockArrays
{
    NSMutableArray *leftBlockArrays = objc_getAssociatedObject(self, kNAVIGATiON_LEFTBLOCKEVENTKEY);
    
    if (!leftBlockArrays) {
        
        leftBlockArrays = [NSMutableArray array];
        
        self.leftBlockArrays = leftBlockArrays;
    }
    
    return leftBlockArrays;
}

- (void (^)(void))leftNavigationItemBlock
{
    return  objc_getAssociatedObject(self, kNAVIGATiONLEFTBLOCKKEY);
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma - mark 视图消失 强制停止所有加载样式

- (void)allIndicatorViewStop{
    
    NSArray *subviews = [UIApplication sharedApplication].keyWindow.subviews;
    for (UIView *subview in subviews) {
        
        if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
            
            [(UIActivityIndicatorView *)subview stopAnimating];
        }
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

#pragma - mark 拦截导航栏返回事件




@end
