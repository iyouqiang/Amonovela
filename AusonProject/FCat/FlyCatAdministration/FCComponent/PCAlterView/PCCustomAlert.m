//
//  PCCustomAlert.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/21.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCCustomAlert.h"
#import "PCUnderLineTextFileld.h"
#import "Masonry.h"
#import "PCPublicClassDefinition.h"
#import "FCAPPConstructionView.h"
#import "FCShareItemView.h"
#import "PCMacroDefinition.h"
@implementation PCCustomAction

@end

@interface PCCustomAlert ()

@property (nonatomic, assign) PCCustomAlertStyle preferredStyle;
@property (nonatomic, strong) NSMutableArray *eventActions;
@property (nonatomic, assign) CGFloat totlaheight;
@property (nonatomic, strong) UIView *shadeView;
@property (nonatomic, strong) UIView *customView;

@end

@implementation PCCustomAlert

+ (instancetype)alertViewWithTitle:(nullable NSString *)title message:(nullable NSString *)message preferredStyle:(PCCustomAlertStyle)preferredStyle
{
    if (preferredStyle != PCCustomAlert_Input && (!message || message.length == 0) ) {
        return nil;
    }
    
    PCCustomAlert *alert =[kAPPDELEGATE.window viewWithTag:198];
    if (!alert) {
    
        alert = [[PCCustomAlert alloc] init];
        alert.tag = 198;
    }
    
    alert.backgroundColor = [UIColor whiteColor];
    alert.message = message;
    alert.inputTextField.placeholder = message;
    alert.title   = title;
    alert.preferredStyle = preferredStyle;
    alert.eventActions = [NSMutableArray array];
    alert.layer.cornerRadius = 5;
    alert.clipsToBounds = YES;
    
    [alert loadCustomAlert];
    
    return alert;
}

/** 界面完全外部自定义 */
+ (instancetype _Nullable )alertCustomView:(UIView *_Nullable)customView
{
    PCCustomAlert *alert = [[PCCustomAlert alloc] init];
    alert.arbitrarilyDisappear = YES;
    alert.frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT);
    [alert addSubview:alert.shadeView];
    [kAPPDELEGATE.window addSubview:alert];
    
    if (customView) {
        customView.layer.cornerRadius = 10;
        customView.clipsToBounds = YES;
        customView.frame = CGRectMake(0, kSCREENHEIGHT, kSCREENWIDTH, CGRectGetHeight(customView.frame));
        [alert addSubview:customView];
        
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:1.0 options:(UIViewAnimationOptionTransitionFlipFromBottom) animations:^{
            
            customView.frame = CGRectMake(0, kSCREENHEIGHT -  CGRectGetHeight(customView.frame) + 10 , kSCREENWIDTH, CGRectGetHeight(customView.frame));
            
        } completion:^(BOOL finished) {
            
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillShowNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                
            [UIView animateWithDuration:0.25 animations:^{
                
                customView.frame = CGRectMake(0, kSCREENHEIGHT -  CGRectGetHeight(customView.frame) + 10 - 150 , kSCREENWIDTH, CGRectGetHeight(customView.frame));
            }];
        }];
        
        [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
                
            [UIView animateWithDuration:0.25 animations:^{
                
                customView.frame = CGRectMake(0, kSCREENHEIGHT -  CGRectGetHeight(customView.frame) + 10 , kSCREENWIDTH, CGRectGetHeight(customView.frame));
            }];
        }];
    }
    
    return alert;
}

+ (instancetype _Nullable )alertShareCustomView:(UIView *_Nullable)customView
{
    PCCustomAlert *alert = [[PCCustomAlert alloc] init];
    alert.arbitrarilyDisappear = YES;
    alert.frame = CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT);
    [alert addSubview:alert.shadeView];
    [kAPPDELEGATE.window addSubview:alert];
    
    if (customView) {
        customView.layer.cornerRadius = 10;
        customView.clipsToBounds = YES;
        customView.frame = CGRectMake(20, kSCREENHEIGHT, kSCREENWIDTH - 40, CGRectGetHeight(customView.frame));
        [alert addSubview:customView];
        
        /// 底部按钮界面
        FCShareItemView *itemView = [[[NSBundle mainBundle] loadNibNamed:@"FCShareItemView" owner:nil options:nil] lastObject];
        itemView.frame = CGRectMake(0, kSCREENHEIGHT + customView.frame.size.height, kSCREENWIDTH, 170);
        itemView.clipsToBounds = YES;
        itemView.layer.cornerRadius = 8;
        [alert addSubview:itemView];
        
        UIImage *shareImage = [UIImage screenShotView:customView];
                
        itemView.shareImage = shareImage;
        
        itemView.cancelShareItemBlock = ^ {
            
            [alert disappearAlert];
        };
        
        CGFloat scaleVale = 0.8;
        
        if (iPhonePlusPRO) {scaleVale = 1.0;};
        
        #ifdef TARGET_VERSION_CPE
        
        #elif defined TARGET_VERSION_CXP
        
        scaleVale = 0.5;
        if (iPhonePlusPRO) {scaleVale = 0.6;};

        #else
        
        #endif

        CGFloat topSpace = ((customView.frame.size.height)/2.0) * (1 - scaleVale);
        
        [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.85 initialSpringVelocity:1.0 options:(UIViewAnimationOptionTransitionFlipFromBottom) animations:^{
            
            customView.frame = CGRectMake(20, kNAVIGATIONHEIGHT - 20 - topSpace, kSCREENWIDTH - 40, CGRectGetHeight(customView.frame));
            
            itemView.frame = CGRectMake(0,  kSCREENHEIGHT - 165, kSCREENWIDTH, 170);
            
        } completion:^(BOOL finished) {
            
        }];
        
        /// swift 不适用
        #ifdef TARGET_VERSION_CPE
        ///
        [itemView setHidden:NO];
        #elif defined TARGET_VERSION_CXP
        
        /// 系统分享
        [itemView setHidden:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [FCShareTool showTitle:@"" shareImg:shareImage shareUrl:@"" completionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                
                [alert disappearAlert];
                
                if (completed) {
                    
                    [FCToast showToastAction:@"操作完成"];
                }else {
                    
                    NSLog(@"分享失败");
                }
            }];
        });

        #else
        /// defalse
        #endif
        
        customView.transform = CGAffineTransformMakeScale(scaleVale, scaleVale);
    }
    
    return alert;
}

- (void)addAction:(NSString *)btnTitle style:(PCCustomActionStyle)style btnAction:(void(^)(NSString *message))btnActionBlock
{
    PCCustomAction *customAction = [[PCCustomAction alloc] init];
    customAction.btnTitle = btnTitle;
    customAction.preferredStyle = style;
    customAction.PCCustomActionBlock = btnActionBlock;
    
    [self.eventActions addObject:customAction];
    
    [self loadCustomAlert];
}

#pragma mark - 弹窗构造
- (void)loadCustomAlert
{
    for (UIView *subView in self.subviews) {
        
        [subView removeFromSuperview];
    }
    
    /** 弹窗高度构造：标题：固定 40 message:上下：10，超过两行左对齐，否则居中显示 btn:固定高度43  */
    CGFloat alertHeight = 0;

    UILabel *titleL = [[UILabel alloc] init];
    [self addSubview:titleL];
    
    if (_title.length > 0 && _title) {
        
        titleL.font = [UIFont font_customTypeSize:17];
        titleL.textColor = COLOR_HexColor(0x1a1a1a);
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.text = _title;
        
        CGFloat lineHeight = titleL.font.lineHeight;
        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(self).offset(20);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(lineHeight);
        }];
        
        alertHeight = lineHeight+20;
    }
    
    /** 普通弹窗 富文本弹窗 输入框弹窗 */
    switch (self.preferredStyle) {
        case PCCustomAlert_Input:
        {
            [self addSubview:self.inputTextField];
            [self.inputTextField mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.mas_equalTo(titleL.mas_bottom).offset(20);
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-15);
                make.height.mas_equalTo(30);
            }];
            
            alertHeight = 75 + alertHeight;
        }
            break;
    
        default:
        {
            //self.messageL.backgroundColor = [UIColor orangeColor];
            [self addSubview:self.messageL];
            
            /** 计算富文本大小 */
            NSString *tempMessage = [self.message stringByReplacingOccurrencesOfString:@" " withString:@"k"];
        
            CGSize messageSize = [tempMessage boundingRectWithSize:CGSizeMake(kSCREENWIDTH-140, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.messageL.font} context:nil].size;
            
            self.messageL.text = self.message;
            
            if (messageSize.height/_messageL.font.lineHeight > 1) {
                
                self.messageL.textAlignment = NSTextAlignmentLeft;
            }else {
                self.messageL.textAlignment = NSTextAlignmentCenter;
            }
            
            // 没有标题，增加文本高度
            CGFloat addHeight = 0;
            CGFloat titleSpace = 15;
            if (self.title.length == 0) {
                self.messageL.font = [UIFont systemFontOfSize:17];
                addHeight = 25.5;
                titleSpace = 20;
            }
            
            [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {

                make.top.mas_equalTo(titleL.mas_bottom).offset(titleSpace);
                make.left.mas_equalTo(20);
                make.right.mas_equalTo(-20);
                make.height.mas_equalTo(messageSize.height + 0.5 + addHeight);
            }];
            
 
            alertHeight = messageSize.height + 30.5 + alertHeight + addHeight;
        }
            break;
    }
    
    if (self.eventActions.count == 0) {
        
        _totlaheight = alertHeight;
        return;
    }
    
    /** 配置底部按钮 是取最后两个按钮 */
    if (self.eventActions.count == 1) {
     
        PCCustomAction *alertEventAction = [self.eventActions firstObject];
        UIView *underLine = [[UIView alloc] init];
        underLine.backgroundColor = COLOR_HexColor(0xF3F5F9);
        [self addSubview:underLine];
        [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
           
            if (self.preferredStyle == PCCustomAlert_Input) {
                
                make.top.mas_offset(alertHeight);
            }else {
                make.top.mas_equalTo(self.messageL.mas_bottom).offset(15);
            }
        
            make.left.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        /**********************/
        // alertAction.preferredStyle 根据不同的样式配置不同的按钮
        /**********************/
        if (alertEventAction.preferredStyle == PCCustomAction_highlight) {
            
            [actionBtn setBackgroundImage:[UIImage at_imageWithColor:COLOR_HexColor(0xffad17) withSize:CGSizeMake(5, 5)] forState:UIControlStateNormal];
            [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else {
            
             [actionBtn setTitleColor:COLOR_HexColor(0x696A6D) forState:UIControlStateNormal];
        }
        /** 点击颜色 */

        //[actionBtn setTitleColor:COLOR_BackgroundColor forState:UIControlStateHighlighted];
        
        [actionBtn setTitle:alertEventAction.btnTitle forState:UIControlStateNormal];
        actionBtn.titleLabel.font = [UIFont font_customTypeSize:17];
        [actionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        actionBtn.tag = 144;
        [self addSubview:actionBtn];
        
        [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(underLine.mas_bottom);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(43);
        }];
        
    }else {
        
        UIView *underLine = [[UIView alloc] init];
        underLine.backgroundColor = COLOR_HexColor(0xF3F5F9);
        [self addSubview:underLine];
        [underLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.mas_offset(alertHeight);
            make.left.right.equalTo(self);
            make.height.mas_equalTo(0.5);
        }];
        
        CGFloat btnWidth = (kSCREENWIDTH-100)/2.0;
        if (PCiPhone5SE) {
            btnWidth = (kSCREENWIDTH-60)/2.0;;
        }
        
        for (int i = 0; i < 2; i ++) {
            
            PCCustomAction *alertAction = [self.eventActions objectAtIndex:i];
            
            UIButton *actionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            
            /**********************/
            // alertAction.preferredStyle 根据不同的样式配置不同的按钮
            
            if (alertAction.preferredStyle == PCCustomAction_highlight) {
                [actionBtn setBackgroundImage:[UIImage at_imageWithColor:COLOR_HexColor(0xffad17) withSize:CGSizeMake(5, 5)] forState:UIControlStateNormal];
                [actionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }else {
                
                [actionBtn setTitleColor:COLOR_HexColor(0x696A6D) forState:UIControlStateNormal];
            }
            /**********************/
            
            /** 点击颜色 */
            [actionBtn setBackgroundImage:[UIImage at_imageWithColor:COLOR_BtnTouchDownColor withSize:CGSizeMake(5, 5)] forState:UIControlStateHighlighted];
            [actionBtn setTitleColor:COLOR_BackgroundColor forState:UIControlStateHighlighted];
            
            [actionBtn setTitle:alertAction.btnTitle forState:UIControlStateNormal];
            
            actionBtn.titleLabel.font = [UIFont font_customTypeSize:17];
            [actionBtn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            actionBtn.tag = 144 + i;
            [self addSubview:actionBtn];
            
            [actionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
               
                make.top.equalTo(underLine.mas_bottom);
                make.left.mas_equalTo(i*btnWidth);
                make.width.mas_equalTo(btnWidth);
                make.height.mas_equalTo(43);
            }];
        }
        
        UIView *centerLine = [[UIView alloc] init];
        centerLine.backgroundColor = COLOR_HexColor(0xF3F5F9);
        [self addSubview:centerLine];
        
        [centerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(underLine.mas_bottom);
            make.left.mas_equalTo(btnWidth-0.25);
            make.width.mas_equalTo(0.5);
            make.height.mas_equalTo(43);
        }];
    }
    
    alertHeight = alertHeight + 43;
    
    _totlaheight = alertHeight;
}

- (void)setAlertAttributedText:(NSAttributedString *)attributedString
{
    [self.messageL setAttributedText:attributedString];
}

/// APP建设中
+ (void)showAppInConstructionAlert
{
    FCAPPConstructionView *constructionView = [[[NSBundle mainBundle] loadNibNamed:@"FCAPPConstructionView" owner:nil options:nil] lastObject];
    constructionView.backgroundColor = [UIColor clearColor];

    PCCustomAlert *alertVeiw = [[PCCustomAlert alloc] init];
    alertVeiw.arbitrarilyDisappear = YES;
    alertVeiw.backgroundColor = [UIColor clearColor];
    [alertVeiw addSubview:constructionView];
    alertVeiw.totlaheight = 300;
    [constructionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(alertVeiw);
    }];
    
    [alertVeiw presentViewAlert];
    
    CGFloat bothSideGap = 50;
    if (PCiPhone5SE) {
        bothSideGap = 30;
    }
    CGRect rect = CGRectMake(0.0, 0.0, 203, 174);
    CAShapeLayer *shapeLayer = [alertVeiw
                                hs_AllRoundedShapeLayerWithStrokeColor:COLOR_HexColor(0xAFB1B3)
                                FillColor:nil
                                BezierPathWithRoundedRect:rect
                                CornerRadius:0
                                LineWidth:1.0
                                LineDashPattern:@[@4,@2]
                                BorderFrame:rect];
    

    
    [constructionView.alertConstructionView.layer addSublayer:shapeLayer];
}

- (CAShapeLayer *)hs_AllRoundedShapeLayerWithStrokeColor:(UIColor *)strokeColor FillColor:(UIColor *)fillColor BezierPathWithRoundedRect:(CGRect)bezierRect CornerRadius:(CGFloat)cornerRadius LineWidth:(CGFloat)lineWidth LineDashPattern:(NSArray*)lineDashPatter BorderFrame:(CGRect)frame{

    CAShapeLayer *border = [CAShapeLayer layer];

    border.strokeColor = strokeColor.CGColor;

    border.fillColor = fillColor.CGColor;

    border.path = [UIBezierPath bezierPathWithRoundedRect:bezierRect cornerRadius:cornerRadius].CGPath;

    border.lineWidth = lineWidth;

    border.lineDashPattern = lineDashPatter;

    border.frame = frame;

    return border;
}

- (void)presentViewAlert
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIView *alertView = [kAPPDELEGATE.window viewWithTag:1998];
        
        if (alertView) {
            return;
        }
        
        [kAPPDELEGATE.window addSubview:self.shadeView];
        [kAPPDELEGATE.window addSubview:self];
        
        if (self.preferredStyle != PCCustomAlert_Input) {
            
            [kAPPDELEGATE.window endEditing:YES];
        }
        
        CGFloat bothSideGap = 50;
        if (PCiPhone5SE) {
            bothSideGap = 30;
        }
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.mas_equalTo(bothSideGap);
            make.right.mas_equalTo(-bothSideGap);
            make.height.mas_equalTo(self->_totlaheight);
            make.top.mas_equalTo(((kSCREENHEIGHT-kNAVIGATIONHEIGHT-kTABBARHEIGHT) - self->_totlaheight)/2.0);
        }];
        
        /** 配置出弹窗方式动画 */
        CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        popAnimation.duration = 0.25;
        popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.3f, 0.3f, 1.0f)],
                                [NSValue valueWithCATransform3D:CATransform3DIdentity]];
        //popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
        popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                         [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [self.layer addAnimation:popAnimation forKey:nil];
    });
}

#pragma mark - eventAction
- (void)btnClick:(UIButton *)btn
{
    __weak PCCustomAlert *weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
       
        PCCustomAction *alertAction = [self.eventActions objectAtIndex:btn.tag-144];
        
        if (self.preferredStyle == PCCustomAlert_Input) {
            [weakSelf endEditing:YES];
            alertAction.PCCustomActionBlock(weakSelf.inputTextField.text);
            [weakSelf.shadeView removeFromSuperview];
            [weakSelf removeFromSuperview];
        }else {
            alertAction.PCCustomActionBlock(weakSelf.message);
            [UIView animateWithDuration:0.2 animations:^{
                
                weakSelf.shadeView.alpha = 0.0;
                weakSelf.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                [weakSelf.shadeView removeFromSuperview];
                [weakSelf removeFromSuperview];
            }];
        }
    });
}

- (void)disappearAlert
{
    if (!self.arbitrarilyDisappear) {
        return;
    }
    [UIView animateWithDuration:0.2 animations:^{
        
        self.shadeView.alpha = 0.0;
        self.alpha = 0.0;
        
    } completion:^(BOOL finished) {
        
        [self.shadeView removeFromSuperview];
        [self removeFromSuperview];
    }];
}

#pragma mark - layz
- (NSArray *)actions
{
    return [NSArray arrayWithArray:self.eventActions];
}

- (UITextField *)inputTextField
{
    if (!_inputTextField) {
        
        _inputTextField = [[UITextField alloc] init];
        //_inputTextField.secureTextEntry = YES;
        _inputTextField.font = [UIFont font_customTypeSize:13];
        //_inputTextField.spellCheckingType = UITextSpellCheckingTypeNo;
        _inputTextField.borderStyle = UITextBorderStyleNone;
        _inputTextField.layer.borderColor = COLOR_HexColor(0x8E8E93).CGColor;
        _inputTextField.layer.borderWidth = 0.5;
        _inputTextField.placeholder = @"输入信息";
        UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 20)];
        _inputTextField.leftView = gapView;
        _inputTextField.leftViewMode = UITextFieldViewModeAlways;
        //[_inputTextField setValue:@20 forKey:@"limit"];
        [_inputTextField becomeFirstResponder];
        _inputTextField.backgroundColor = [UIColor whiteColor];
    }
    
    return _inputTextField;
}

- (UILabel *)messageL
{
    if (!_messageL) {
        
        _messageL = [[UILabel alloc] init];
        _messageL.font = [UIFont font_customTypeSize:14];
        _messageL.textColor = COLOR_HexColor(0x696A6D);
        _messageL.textAlignment = NSTextAlignmentLeft;
        _messageL.numberOfLines = 0;
    }
    return _messageL;
}

- (UIView *)shadeView
{
    _shadeView = [kAPPDELEGATE.window viewWithTag:199];
    
    if (!_shadeView) {
        
        _shadeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSCREENWIDTH, kSCREENHEIGHT)];
        _shadeView.tag = 199;
        _shadeView.backgroundColor = [UIColor blackColor];
        _shadeView.alpha = 0.6;
        
        // UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disappearAlert)];
        // [_shadeView addGestureRecognizer:tapGesture];
        
        UIControl *control = [[UIControl alloc] initWithFrame:_shadeView.bounds];
        [control addTarget:self action:@selector(disappearAlert) forControlEvents:UIControlEventTouchUpInside];
        [_shadeView addSubview:control];
    }
    
    return _shadeView;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
