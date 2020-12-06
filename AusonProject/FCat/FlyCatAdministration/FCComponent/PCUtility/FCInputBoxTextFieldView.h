//
//  FCInputBoxTextFieldView.h
//  Auson
//
//  Created by Yochi on 2020/11/24.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol InputPasswordViewDelegate <NSObject>

@optional

- (void)inputBoxString:(NSString *)inputBoxString;

@end

@interface FCInputBoxTextFieldView : UIView<UITextFieldDelegate>

@property(nonatomic,assign)id<InputPasswordViewDelegate> delegate;

/** 那些位置输入字符，数字中传字符串的位置,起始位零 */
@property(nonatomic,strong) NSArray *characterPositionArray;

- (NSString *)getAllInputBoxString;
- (void)inputBoxbecomeFirstResponder;
- (void)inputBoxresignFirstResponder;
/** 赋值初始化数据是否可以改变 */
- (void)inputInitializeStr:(NSString *)inputStr isPermitChange:(BOOL)isPermitChange;
/** 泊位框创建 */
- (instancetype)initWithInputBoxFrame:(CGRect)frame boxNumber:(NSInteger)boxNumber isPasswordformat:(BOOL)isPasswordformat;

@end

NS_ASSUME_NONNULL_END
