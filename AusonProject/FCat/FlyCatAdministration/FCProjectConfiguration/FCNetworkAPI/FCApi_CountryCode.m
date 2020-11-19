
//
//  FCApi_CountryCode.m
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCApi_CountryCode.h"

@implementation FCApi_CountryCode

- (instancetype)init{
    
    if (self = [super init]) {
        
        [self addAccessory:[YTKAnimatingRequestAccessory accessoryWithAnimatingView]];
    }
    
    return self;
}

-(NSString *)requestUrl{
    
    return @"/api/v1/user/country/codes";
}

- (YTKRequestMethod)requestMethod{
    
    return YTKRequestMethodGET;
}

//- (id)requestArgument{
//    
//     NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
////     [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
//    
//    return parameter;
//}



@end
