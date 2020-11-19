//
//  TextInputLimit.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/7.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UITextField (Limit)

@end

@interface UITextView (Limit)

@end

@interface TextInputLimit : NSObject

+ (TextInputLimit *)sharedTextLimit;

@end
