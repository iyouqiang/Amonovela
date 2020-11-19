//
//  TextInputLimit.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/7.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "TextInputLimit.h"
#import <objc/runtime.h>

@implementation UITextField (Limit)

- (id)valueForUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"limit"]) {
        
        return objc_getAssociatedObject(self, key.UTF8String);
    }
    
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"limit"]) {
        
        objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);
    }
}

@end

@implementation UITextView (Limit)

- (id)valueForUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"limit"]) {
        
        return objc_getAssociatedObject(self, key.UTF8String);
    }
    
    return nil;
}

- (void)setValue:(id)value forKey:(NSString *)key
{
    if ([key isEqualToString:@"limit"]) {
        
        objc_setAssociatedObject(self, key.UTF8String, value, OBJC_ASSOCIATION_RETAIN);
    }
}

@end

@implementation TextInputLimit

+ (void)load
{
    [super load];
    [TextInputLimit sharedTextLimit];
}

+ (TextInputLimit *)sharedTextLimit
{
    static TextInputLimit *textLimit;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        textLimit = [[TextInputLimit alloc] init];
    });
    return textLimit;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldDidChange:)
                                                     name:UITextFieldTextDidChangeNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textViewDidChange:)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:nil];
    }
    
    return self;
}

- (void)textFieldDidChange:(NSNotification *)note
{
    UITextField *textField = (UITextField *)note.object;
    
    NSNumber *number = [textField valueForKey:@"limit"];
    
    if (number && textField.text.length > [number integerValue] && textField.markedTextRange == nil) {
        
        textField.text = [textField.text substringWithRange:NSMakeRange(0, [number integerValue])];
    }
}

- (void)textViewDidChange:(NSNotification *)note
{
    UITextView *textView = (UITextView *)note.object;
    
    NSNumber *number = [textView valueForKey:@"limit"];
    
    if (number && textView.text.length > [number integerValue] && textView.markedTextRange == nil) {
        
        textView.text = [textView.text substringWithRange:NSMakeRange(0, [number integerValue])];
    }
}

@end
