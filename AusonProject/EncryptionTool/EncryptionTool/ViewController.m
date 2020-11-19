//
//  ViewController.m
//  EncryptionTool
//
//  Created by Yochi on 2020/8/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "ViewController.h"
#import "EncryptionTools.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    /// 获取文件路径
    NSString *configPlistPath = [self mainBundelPath:@"NetworkAddress" suffix:nil];
    //NSString *addressPlistPath = [self mainBundelPath:@"MBANetAddress" suffix:nil];
    //NSString *sensorsAnalyticspath = [self mainBundelPath:@"SensorsAnalytics" suffix:@"json"];
    
    // 对文件加密
    [self encryptionFile:configPlistPath];
//    [self encryptionFile:addressPlistPath];
//    [self encryptionFile:sensorsAnalyticspath];
    
    /// 对文件解密
//    [self decryptPlist:configPlistPath];
//    [self decryptPlist:addressPlistPath];
//    [self decryptJson:sensorsAnalyticspath];
}

#pragma mark - 文件加解密

- (NSString *)mainBundelPath:(NSString *)fileName suffix:(NSString *)suffix
{
    NSString * path = [[NSBundle mainBundle] pathForResource:fileName ofType:suffix];
    return path;
}

/// 加密文件
- (void)encryptionFile:(NSString *)filePath
{   /// ⚠️plist文件需要先将文件后缀移除，json不用
    [EncryptionTools encryptFileDataPath:filePath filePath:nil];
}

/// 解密plist文件
- (void)decryptPlist:(NSString *)filePath
{
    NSData *plistData = [EncryptionTools decryptFileDataPath:filePath];
    
    if (!plistData) {
        NSLog(@"为获取解密数据");
        return;
    }
    
    NSError *error;
    NSPropertyListFormat format;
    NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
    
    NSLog(@"解密plist文件数据 plist : %@", plist);
}

/// 解密json文件
- (void)decryptJson:(NSString *)filePath
{
    NSData *JSONData = [EncryptionTools decryptFileDataPath:filePath];
    NSDictionary *dataInfo = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"解密json文件 : %@", dataInfo);
}

#pragma mark - test

- (void)plistConvertJson:(NSData *)plistData
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *Json_path = [path stringByAppendingPathComponent:@"SensorsAnalytics.json"];
    //==写入文件
    NSLog(@"Json_path : %@ %@", path,[plistData writeToFile:Json_path atomically:YES] ? @"Succeed":@"Failed");
}

/** json 转 plist文件 */
- (void)jsonDataTransferplist:(NSData *)jsonData {
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *newPath = [filePath stringByAppendingString:@"/SensorsAnalytics.json"];
    [jsonData writeToFile:newPath atomically:YES];

    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:newPath] options:NSJSONReadingMutableLeaves error:nil];
    NSString *newPlistPath = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] bundlePath], @"/SensorsAnalytics.plist"];
    [array writeToFile:newPlistPath atomically:YES];

    NSLog(@"SensorsAnalytics = %@", newPlistPath);
}



@end
