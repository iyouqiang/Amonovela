//
//  PCCMethod.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/14.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#ifndef PCCMethod_h
#define PCCMethod_h

#include <stdio.h>
#include <objc/runtime.h>

void CATSwizzeMethod(Class aClass, SEL originalSelector, SEL swizzledSelector);

#endif /* PCCMethod_h */
