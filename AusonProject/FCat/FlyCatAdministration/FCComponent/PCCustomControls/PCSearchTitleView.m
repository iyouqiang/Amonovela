//
//  PCSearchTitleView.m
//  PurCowExchange
//
//  Created by Yochi on 2018/8/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCSearchTitleView.h"
#import "PCStyleDefinition.h"
@interface PCSearchTitleView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITextField *searchTextField;
@property (nonatomic, strong) NSString *searchStr;

@end

@implementation PCSearchTitleView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        /** 搜索框 参考值 CGRectMake(-10, 0, SCREENWIDTH - 80, 30.0f) */
        _searchView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        [_searchView setBackgroundColor:COLOR_HexColor(0x282833)];
        [self addSubview:_searchView];

        UITextField *searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(self.frame) - 30, CGRectGetHeight(self.frame))];
        searchTextField.delegate = self;
        searchTextField.keyboardType = UIKeyboardTypeURL;
        searchTextField.returnKeyType = UIReturnKeySearch;
        searchTextField.spellCheckingType = UITextSpellCheckingTypeNo;
        searchTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        searchTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        searchTextField.backgroundColor = COLOR_HexColor(0x282833);
        searchTextField.font =[UIFont font_customTypeSize:13];
        searchTextField.textColor = [UIColor whiteColor];
        searchTextField.tintColor = COLOR_BtnTouchDownColor;
        searchTextField.placeholder = @"搜索币种";
        [searchTextField setValue:COLOR_TitleSectionColor forKeyPath:@"_placeholderLabel.textColor"];
        //[textField setValue:[UIColor redColor] forKeyPath:@"_placeholderLabel.textColor"];
        //[textField setValue:[UIFont boldSystemFontOfSize:16] forKeyPath:@"_placeholderLabel.font"];


        searchTextField.leftViewMode=UITextFieldViewModeAlways;
        UIImageView *imgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"asset_searchIcon"]];
        searchTextField.leftView = imgView;
        [_searchView addSubview:searchTextField];
        
        self.searchTextField = searchTextField;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNotification) name:UITextFieldTextDidChangeNotification object:nil];
    }
    
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   [self searchKeywordsWithKey:self.searchTextField.text];
}

- (void)textFieldTextDidChangeNotification
{
    if (self.isfuzzySearch) {
        
        [self searchKeywordsWithKey:self.searchTextField.text];
    }
}

- (void)setPlaceholderStr:(NSString *)placeholderStr
{
    if (![_placeholderStr isEqualToString:placeholderStr]) {
        
        self.searchTextField.placeholder = placeholderStr;
        
        _placeholderStr = placeholderStr;
    }
}

- (void)searchKeywordsWithKey:(NSString*)word
{
    if (![self.searchStr isEqualToString:self.searchTextField.text]) {
        
        if (self.searchBlock) {
            
            self.searchBlock(word);
        }
    }
    
    self.searchStr = self.searchTextField.text;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchKeywordsWithKey:self.searchTextField.text];

    [self.searchTextField endEditing:YES];
    
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
