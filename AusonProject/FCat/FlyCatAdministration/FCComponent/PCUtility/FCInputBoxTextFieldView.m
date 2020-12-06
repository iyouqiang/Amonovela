//
//  FCInputBoxTextFieldView.m
//  Auson
//
//  Created by Yochi on 2020/11/24.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCInputBoxTextFieldView.h"
#import "NSString+PCExtend.h"
#import "PCMacroDefinition.h"
#define kletter @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
#import "Masonry.h"

//textField 删除操作
@protocol InputBoxTextFieldDelegate  < NSObject >

@optional
- (void)textFieldDidDelete:(UITextField*)textField;

@end

@interface InputBoxTextField : UITextField<UIKeyInput>

@property (nonatomic, assign) id <InputBoxTextFieldDelegate>inputBoxDelegate;

@end

@implementation InputBoxTextField

- (void)deleteBackward
{
    [super deleteBackward];

    if ([_inputBoxDelegate respondsToSelector:@selector(textFieldDidDelete:)]) {

        [_inputBoxDelegate textFieldDidDelete:self];
    }
}

- (BOOL)keyboardInputShouldDelete:(UITextField *)textField
{
    BOOL shouldDelete = YES;

    if ([UITextField instancesRespondToSelector:_cmd]) {

        BOOL (*keyboardInputShouldDelete)(id, SEL, UITextField *) = (BOOL (*)(id, SEL, UITextField *))[UITextField instanceMethodForSelector:_cmd];

        if (keyboardInputShouldDelete) {

            shouldDelete = keyboardInputShouldDelete(self, _cmd, textField);
        }
    }

    return shouldDelete;
}
@end

@interface FCInputBoxTextFieldView ()<InputBoxTextFieldDelegate>
{
    NSInteger kinputBoxNumber;
    NSInteger kinputBoxHeight;
}

@property (nonatomic, strong) UITextField *currentTextField;
@property (nonatomic, strong) NSString    *passwordStr;
@property (nonatomic, assign) BOOL        isSecret;
@property (nonatomic, assign) CGFloat     viewWidth;
@property (nonatomic, assign) CGFloat     viewHeight;

@end

@implementation FCInputBoxTextFieldView

- (instancetype)initWithInputBoxFrame:(CGRect)frame boxNumber:(NSInteger)boxNumber isPasswordformat:(BOOL)isPasswordformat
{
    self = [super initWithFrame:frame];

    if (self) {

        _isSecret = isPasswordformat;

        _viewHeight = CGRectGetHeight(self.frame);
        _viewWidth = CGRectGetWidth(self.frame);
        //self.layer.borderColor = COLOR_HexColor(0x848D9B).CGColor;
        //self.layer.borderWidth = 1;
        //self.layer.cornerRadius = 5.0f;
        kinputBoxHeight = _viewHeight;
        kinputBoxNumber = boxNumber == 0?6:boxNumber;

        [self createInputBoxView];
    }

    return self;
}

#pragma mark - default data

- (void)createInputBoxView
{
    for (int i = 0;i < kinputBoxNumber; i ++) {

        UITextField *textVi = (UITextField *)[self viewWithTag:i+2016];

        if (!textVi) {

            InputBoxTextField *textField = [[InputBoxTextField alloc] init];
            textField.tag          = i + 2016;
            textField.delegate     = self;
            [textField setTintColor:[UIColor whiteColor]];
            textField.inputBoxDelegate   = self;
            textField.textColor = [UIColor whiteColor];
            textField.font               = [UIFont systemFontOfSize:22];
            textField.borderStyle        = UITextBorderStyleNone;
            textField.clearButtonMode    = UITextFieldViewModeNever;
            textField.textAlignment      = NSTextAlignmentCenter;
            textField.keyboardType       = UIKeyboardTypeNumberPad;
            textField.layer.cornerRadius = 5;
            textField.layer.borderColor = COLOR_HexColor(0x848D9B).CGColor;
            textField.layer.borderWidth = 0.8;
            textField.enabled = YES;
            [textField setUserInteractionEnabled:YES];
            CGFloat gap = 15;
            CGFloat boxWidth = (_viewWidth - gap*(kinputBoxNumber - 1))/kinputBoxNumber;
            [self addSubview:textField];
            /**
            [textField mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(i*(gap + boxWidth));
                make.top.mas_equalTo((_viewHeight-kinputBoxHeight)/2);
                make.width.mas_equalTo(boxWidth);
                make.height.mas_equalTo(kinputBoxHeight);
            }];
             */
            textField.frame = CGRectMake(i*(gap + boxWidth), (_viewHeight-kinputBoxHeight)/2, boxWidth, kinputBoxHeight);
           // textField.frame = CGRectMake(i*_viewWidth/kinputBoxNumber, (_viewHeight-kinputBoxHeight)/2, _viewWidth/kinputBoxNumber, kinputBoxHeight);

            /** 分割线 */
            /**
            if (i != kinputBoxNumber-1) {

                UIView *segLine = [[UIView alloc] initWithFrame:CGRectMake(textField.right - 0.5, textField.top, 1, textField.height)];
                segLine.backgroundColor = ECHexColor(0x525A61);
                [self addSubview:segLine];
            }
             */

            if (self.isSecret) {

                textField.secureTextEntry = YES;
            }

            if (i == 0) {

                //[textField becomeFirstResponder];
                self.currentTextField = textField;
            }
        }
    }

    if (![self viewWithTag:99] && self.isSecret) {

        UIButton *textFieldShadebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        textFieldShadebtn.frame = CGRectMake(0, 0, _viewWidth, _viewHeight);
        [textFieldShadebtn addTarget:self
                              action:@selector(currentTextbecomeFirstResponder)
                    forControlEvents:UIControlEventTouchUpInside];
        textFieldShadebtn.tag = 99;
        [self addSubview:textFieldShadebtn];
    }
}

/** 配置输入字符串的位置 */
- (void)setCharacterPositionArray:(NSArray *)characterPositionArray
{
    if (_characterPositionArray != characterPositionArray) {

        _characterPositionArray = characterPositionArray;

        for (NSString *locStr in characterPositionArray) {

            UITextField *textField = [self viewWithTag:[locStr integerValue] + 2016];
            textField.autocorrectionType = UITextAutocorrectionTypeNo;
            textField.keyboardType = UIKeyboardTypeASCIICapable;
        }
    }
}

#pragma mark - 响应输入框
- (void)currentTextbecomeFirstResponder
{
    [self.currentTextField becomeFirstResponder];
}

- (void)inputInitializeStr:(NSString *)inputStr isPermitChange:(BOOL)isPermitChange;
{

    if (inputStr.length == 0 || inputStr == nil) {
        return;
    }
    
    if (inputStr.length > kinputBoxNumber) {

        inputStr = [inputStr substringToIndex:kinputBoxNumber];
    }

    for (int i = 0; i<kinputBoxNumber; i++) {

        UITextField *textField = (UITextField *)[self viewWithTag:i+2016];

        textField.text = nil;

        if (!isPermitChange) {

            textField.userInteractionEnabled = NO;
            textField.textColor = [UIColor whiteColor];
        }

        if ([inputStr length] >= kinputBoxNumber) {

            NSRange range;

            range.location = i;

            range.length = 1;

            NSString *singleStr = [inputStr substringWithRange:range];

            textField.text = singleStr;
        }
    }

    if ([self.delegate respondsToSelector:@selector(inputBoxString:)]) {

        [self.delegate inputBoxString:[self getAllInputBoxString]];
    }
}

- (void)inputBoxbecomeFirstResponder
{
    if ([self getAllInputBoxString].length == kinputBoxNumber) {

        return;
    }
    UITextField *textFi = (UITextField *)[self viewWithTag:2016];
    [textFi becomeFirstResponder];
}

- (void)inputBoxresignFirstResponder
{
    UITextField *textFi = (UITextField *)[self viewWithTag:2016];
    [textFi resignFirstResponder];
    [self endEditing:YES];
}

- (NSString *)getAllInputBoxString
{
    self.passwordStr = @"";

    for (int i = 0; i < kinputBoxNumber;i ++) {

        UITextField *field =(UITextField*)[self viewWithTag:i+2016];

        if (![field.text isEqualToString:@""] && field.text != nil) {

            self.passwordStr = [self.passwordStr stringByAppendingString:field.text];
        }
    }

    return self.passwordStr;
}

#pragma mark - textField delgate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    self.currentTextField = textField;

    if (![string isEqualToString:@""]) {

        unichar single=[string characterAtIndex:0];

        /** 输入值字符 */
        if ([self.characterPositionArray containsObject:[NSString stringWithFormat:@"%ld", (long)textField.tag-2016]]) {

            if (![string isVerifyLegalNumber]) {

                return NO;
            }

            string = string.uppercaseString;

        }else {

            if (!(single >='0' && single<='9')) {

                return NO;
            }
        }

        textField.text = string;
        UITextField *nextVi = (UITextField *)[self viewWithTag:textField.tag + 1];
        [nextVi becomeFirstResponder];

        if ([self.delegate respondsToSelector:@selector(inputBoxString:)]) {

            [self.delegate inputBoxString:[self getAllInputBoxString]];
        }

    }else {

        [self textFieldDidDelete:textField];
    }

    return NO;
}

- (void)textFieldDidDelete:(UITextField*)textField;
{
    if (textField.text.length == 0)
    {
        if (textField.tag == 2016) {
            return;
        }

        UITextField *previousTextField = (UITextField *)[self viewWithTag:textField.tag - 1];
        previousTextField.text = nil;
        [previousTextField becomeFirstResponder];
        self.currentTextField = previousTextField;
        
    }else {
        
        textField.text = nil;
        [textField becomeFirstResponder];
        self.currentTextField = textField;
    }
    
    if ([self.delegate respondsToSelector:@selector(inputBoxString:)]) {
        
        [self.delegate inputBoxString:[self getAllInputBoxString]];
    }
}

@end

