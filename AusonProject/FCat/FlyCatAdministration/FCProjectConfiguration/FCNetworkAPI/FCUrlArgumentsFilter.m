//
//  FCUrlArgumentsFilter.m
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCUrlArgumentsFilter.h"
#import "AFURLRequestSerialization.h"


@implementation FCUrlArgumentsFilter
{
    NSDictionary *_arguments;
}
+ (FCUrlArgumentsFilter *)filterWithArguments:(NSDictionary *)arguments {
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments {
    self = [super init];
    if (self) {
        _arguments = arguments;
    }
    return self;
}
- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request {
    
//    request.requestHeaderFieldValueDictionary
//    var token = ""
//    if let userInfo = FCUserInfoManager.sharedInstance.userInfo {
//        token = userInfo.token ?? ""
//    }
    
    return [self urlStringWithOriginUrlString:originUrl appendParameters:_arguments];
}
- (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters {
    NSString *paraUrlString = AFQueryStringFromParameters(parameters);
    
    if (!(paraUrlString.length > 0)) {
        return originUrlString;
    }
    
    BOOL useDummyUrl = NO;
    static NSString *dummyUrl = nil;
    NSURLComponents *components = [NSURLComponents componentsWithString:originUrlString];
    if (!components) {
        useDummyUrl = YES;
        if (!dummyUrl) {
            dummyUrl = @"";
        }
        components = [NSURLComponents componentsWithString:dummyUrl];
    }
    
    NSString *queryString = components.query ?: @"";
    NSString *newQueryString = [queryString stringByAppendingFormat:queryString.length > 0 ? @"&%@" : @"%@", paraUrlString];
    
    components.query = newQueryString;
    
    if (useDummyUrl) {
        return [components.URL.absoluteString substringFromIndex:dummyUrl.length - 1];
    } else {
        return components.URL.absoluteString;
    }
}

@end
