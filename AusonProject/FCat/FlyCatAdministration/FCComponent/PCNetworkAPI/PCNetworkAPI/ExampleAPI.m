//
//  ExampleAPI.m
//  PurCowExchange
//
//  Created by Yochi on 2018/6/27.
//  Copyright © 2018年 Yochi. All rights reserved.
//
//  使用示例 https://github.com/yuantiku/YTKNetwork/blob/master/Docs/BasicGuide_cn.md

#import "ExampleAPI.h"
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@implementation ExampleAPI {
    NSString *_username;
    NSString *_password;
    UIImage  *_image;
}

- (id)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (NSString *)requestUrl {
    /**
      http://www.yuantiku.com/iphone/register post请求
     “http://www.yuantiku.com” 在 YTKNetworkConfig 中设置，这里只填除去域名剩余的网址信息
     */
    return @"/iphone/register";
}

- (NSString *)baseUrl
{
    return @"替换配置中的baseurl";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    return @{
             @"username": _username,
             @"password": _password
             };
}

// 返回的json字符串验证
- (id)jsonValidator {
    return @[@{
                 @"id": [NSNumber class],
                 @"imageId": [NSString class],
                 @"time": [NSNumber class],
                 @"status": [NSNumber class],
                 @"question": @{
                         @"id": [NSNumber class],
                         @"content": [NSString class],
                         @"contentType": [NSNumber class]
                         }
                 }];
}

//使用config中的cdn地址
- (BOOL)useCDN {
    return YES;
}

// 缓存三分钟
- (NSInteger)cacheTimeInSeconds {
    // 3 分钟 = 180 秒
    return 60 * 3;
}

/** 上传图片 */
- (AFConstructingBlock)constructingBodyBlock {
    return ^(id<AFMultipartFormData> formData) {
        NSData   *data = UIImageJPEGRepresentation(self->_image, 0.9);
        NSString *name = @"image";
        NSString *formKey = @"image";
        NSString *type = @"image/jpeg";
        [formData appendPartWithFileData:data name:formKey fileName:name mimeType:type];
    };
}

- (NSString *)responseImageId {
    NSDictionary *dict = self.responseJSONObject;
    return dict[@"imageId"];
}

// 自定义头部
- (nullable NSDictionary<NSString *, NSString *> *)requestHeaderFieldValueDictionary
{
    return @{@"Content-Type" : @"application/json;charset=UTF-8;text/html"};
}

//复写它，- (NSURLRequest *)buildCustomUrlReques 上面方法全部失效


/** 外部调用方式 */
/**

// block 
- (void)loginButtonPressed:(id)sender {
    NSString *username = self.UserNameTextField.text;
    NSString *password = self.PasswordTextField.text;
    if (username.length > 0 && password.length > 0) {
        RegisterApi *api = [[RegisterApi alloc] initWithUsername:username password:password];
        [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest *request) {
            // 你可以直接在这里使用 self
            NSLog(@"succeed");
        } failure:^(YTKBaseRequest *request) {
            // 你可以直接在这里使用 self
            NSLog(@"failed");
        }];
    }
}

// delegate：
- (void)loginButtonPressed:(id)sender {
    NSString *username = self.UserNameTextField.text;
    NSString *password = self.PasswordTextField.text;
    if (username.length > 0 && password.length > 0) {
        RegisterApi *api = [[RegisterApi alloc] initWithUsername:username password:password];
        api.delegate = self;
        [api start];
    }
}

- (void)requestFinished:(YTKBaseRequest *)request {
    NSLog(@"succeed");
}

- (void)requestFailed:(YTKBaseRequest *)request {
    NSLog(@"failed");
}

 */

@end
