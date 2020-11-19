//
//  HYEncryptionTools.m
//  HYWidget
//
//  Created by Yochi on 2019/12/30.
//

#import "EncryptionTools.h"
#import <CommonCrypto/CommonDigest.h>
 
@implementation EncryptionTools

+ (NSString *)encryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData * __nullable)iv algorithm:(uint32_t)alg {
    
    NSInteger keyLength;
    if (alg == kCCAlgorithmDES) {
        keyLength = kCCKeySizeDES;
    } else {
        keyLength = kCCKeySizeAES128;
    }
    
    // 设置秘钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keyLength];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keyLength];
    
    // 设置iv
    uint8_t cIv[keyLength];
    bzero(cIv, keyLength);
    int option = 0;
    if (iv) {
        [iv getBytes:cIv length:keyLength];
        option = kCCOptionPKCS7Padding;
    } else {
        option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    }
    
    // 设置输出缓冲区
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    size_t bufferSize = [data length] + keyLength;
    void *buffer = malloc(bufferSize);
    
    // 开始加密
    size_t encryptedSize = 0;
    //加密解密都是它 -- CCCrypt
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          alg,
                                          option,
                                          cKey,
                                          keyLength,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:encryptedSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 加密失败|状态编码: %d", cryptStatus);
    }
    
    return [result base64EncodedStringWithOptions:0];
}

+ (NSString *)decryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData * __nullable)iv algorithm:(uint32_t)alg {
    
    NSInteger keyLength;
    if (alg == kCCAlgorithmDES) {
        keyLength = kCCKeySizeDES;
    } else {
        keyLength = kCCKeySizeAES128;
    }
    
    // 设置秘钥
    NSData *keyData = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t cKey[keyLength];
    bzero(cKey, sizeof(cKey));
    [keyData getBytes:cKey length:keyLength];
    
    // 设置iv
    uint8_t cIv[keyLength];
    bzero(cIv, keyLength);
    int option = 0;
    if (iv) {
        [iv getBytes:cIv length:keyLength];
        option = kCCOptionPKCS7Padding;
    } else {
        option = kCCOptionPKCS7Padding | kCCOptionECBMode;
    }
    
    // 设置输出缓冲区
    NSData *data = [[NSData alloc] initWithBase64EncodedString:string options:0];
    size_t bufferSize = [data length] + keyLength;
    void *buffer = malloc(bufferSize);
    
    // 开始解密
    size_t decryptedSize = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          alg,
                                          option,
                                          cKey,
                                          keyLength,
                                          cIv,
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &decryptedSize);
    
    NSData *result = nil;
    if (cryptStatus == kCCSuccess) {
        result = [NSData dataWithBytesNoCopy:buffer length:decryptedSize];
    } else {
        free(buffer);
        NSLog(@"[错误] 解密失败|状态编码: %d", cryptStatus);
    }
    
    return [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
}

/**
*  base64编码
*/
+ (NSString *)base64Encode:(NSString *)keyString
{
    NSData *data = [keyString dataUsingEncoding:NSUTF8StringEncoding];
    NSData *base64Data = [data base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    NSString *baseString = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
    return baseString;
}
/**
*  base64解码
*/
+ (NSString *)base64Decode:(NSString *)keyString
{
    NSData *data = [[NSData alloc] initWithBase64EncodedString:keyString options:NSDataBase64DecodingIgnoreUnknownCharacters];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

/**
*  md5摘要16位
*/
+ (NSString *)md5HexDigest:(NSString *)keyString
{
    if (!self) {
        return nil;
    }
    const char *str = [keyString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    NSString *md5Code = @"um!:#";
      
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        if (i == 6) {
            [ret appendString:md5Code];
        }
        [ret appendFormat:@"%02x", result[i]];
    }
    
    const char *str2 = [ret UTF8String];
    CC_MD5(str2, (CC_LONG)strlen(str2), result);
    NSMutableString *finalRet = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [finalRet appendFormat:@"%02x", result[i]];
    }
    return finalRet.copy;
}
/**
*  md5摘要32位
*/
+ (NSString *)md5Digest:(NSString *)keyString
{
    if (!self) {
        return nil;
    }
    const char *str = [keyString UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), result);
    NSMutableString *finalRet = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [finalRet appendFormat:@"%02x", result[i]];
    }
    return finalRet.copy;
}

/**
 *  ROT13码意思是将字母左移13位
 */
+ (NSString *)rot13String:(NSString *)keyString
{
    const char *source = [keyString cStringUsingEncoding:NSASCIIStringEncoding];
    char *dest = (char *)malloc((keyString.length + 1 ) * sizeof(char));
    if (!dest) {
        return nil ;
    }
    
    NSUInteger i = 0;
    for (; i < keyString.length; i++) {
        char c = source[i];
        if (c >= 'A' && c <= 'Z') {
            c = (c - 'A' + 13 ) % 26 + 'A';
        } else if (c >= 'a' && c <= 'z') {
            c = (c - 'a' + 13 ) % 26 + 'a';
        }
        dest[i] = c;
    }
    dest[i] = '\0';
    NSString *result = [[NSString alloc] initWithCString:dest encoding:NSASCIIStringEncoding];
    free(dest);
    return result;
}

/**
 *  URL encode
 */
+ (NSString *)URLEncodedString:(NSString *)keyString
{
    NSString *encodedValue = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,
                                                                                (CFStringRef)keyString, nil,
                                                                                (CFStringRef)@"!*'();:@&=+$,/ %#[]", kCFStringEncodingUTF8));
    
    return encodedValue;
}

/**
 *  originFilePath 原文件地址
 *  encryptFilePath 需要保存的文件地址
 *  plist文件需要去掉后缀，进行加密
 *  传nil文件保存默认保存在document位置下
 */
+ (void)encryptFileDataPath:(NSString *)originFilePath filePath:(nullable NSString *)encryptFilePath
{
    //获得纯文件名，带后缀
    NSString *fileName  = [originFilePath lastPathComponent];
    //获得文件路径，不带后缀
    //NSString *fileName     = [originFilePath stringByDeletingPathExtension];
    //获得文件后缀
    //NSString *suffix       = [originFilePath pathExtension];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
           if (originFilePath) {
               
               NSString *encodeFilePath = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:originFilePath]
                                                                   encoding:NSUTF8StringEncoding
                                                                      error:NULL];
               
               // 默认aes加密
               NSString *enStr = [EncryptionTools encryptString:encodeFilePath keyString:@"CHEX" iv:[@"YOCHICXP" dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmAES];
               
               NSString *documentFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
               
               if (encryptFilePath.length > 0) {
                   documentFilePath = encryptFilePath;
               }
               
               NSString *enfilename = [documentFilePath stringByAppendingPathComponent:fileName];
               NSError *error = nil;
               [enStr writeToFile:enfilename atomically:YES encoding:NSUTF8StringEncoding error:&error];
               
               NSLog(@"documentFilePath : %@ %@", enfilename, error);
           }
       });
}

+ (NSData *)decryptFileDataPath:(NSString *)desfilePath
{
    if (desfilePath) {
        
        NSError *error = nil;
        NSString *encodeFilePath = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:desfilePath]
                                                            encoding:NSUTF8StringEncoding
                                                               error:&error];
        
        // 对应默认aes解密
        NSString *desStr = [EncryptionTools decryptString:encodeFilePath keyString:@"CHEX" iv:[@"YOCHICXP" dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmAES];
        
        if (desStr) {
            
            NSData *desData = [desStr dataUsingEncoding:NSUTF8StringEncoding];
            return desData;
        }
        
        NSLog(@"error : %@", error);
    }
    return nil;
}

/** 弃用，仅参考 */
+ (void)encryptString:(NSString *)fileName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *enfilePath = [[NSBundle mainBundle] pathForResource:fileName ofType:nil];
        if (enfilePath) {
            
            NSString *encodeFilePath = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:enfilePath]
                                                                encoding:NSUTF8StringEncoding
                                                                   error:NULL];
            
            // 对应默认aes解密 key随意 iv 必须是8位
            NSString *enStr = [EncryptionTools encryptString:encodeFilePath keyString:@"CHEX" iv:[@"YOCHICXP" dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmAES];
            
            NSString *documentFilePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            
            NSString *enfilename = [documentFilePath stringByAppendingPathComponent:fileName];
            
            [enStr writeToFile:enfilename atomically:YES encoding:NSUTF8StringEncoding error:nil];
            
            //NSLog(@"documentFilePath : %@", enfilename);
        }
    });
}

/** 弃用，仅参考 */
+ (NSDictionary *)decryptfile:(NSString *)filename
{
    // 使用加密文件
    NSString *desfilePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
    
    if (desfilePath) {
        
        NSString *encodeFilePath = [NSString stringWithContentsOfURL:[NSURL fileURLWithPath:desfilePath]
                                                            encoding:NSUTF8StringEncoding
                                                               error:NULL];
        
        // 对应默认aes解密 key随意 iv 必须是8位
        NSString *desStr = [EncryptionTools decryptString:encodeFilePath keyString:@"CHEX" iv:[@"YOCHICXP" dataUsingEncoding:NSUTF8StringEncoding] algorithm:kCCAlgorithmAES];
        
        if (desStr) {
            
            NSData *desData = [desStr dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSPropertyListFormat format;
            NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:desData options:NSPropertyListImmutable format:&format error:&error];
        
            if (!plist) {
                
                NSLog(@"desStrerror : %@", error);
            }
            
            return plist;
        }
    }
    return nil;
}

/// 解密plist文件
+ (id)decryptPlist:(NSString *)filePath
{
    NSData *plistData = [EncryptionTools decryptFileDataPath:filePath];
    
    if (!plistData) {
        NSLog(@"未获取解密数据");
        return nil;
    }
    
    NSError *error;
    NSPropertyListFormat format;
    NSDictionary *plist = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
    
    NSLog(@"解密plist文件数据 plist : %@", plist);
    
    return plist;
}

/// 解密json文件
+ (id)decryptJson:(NSString *)filePath
{
    NSData *JSONData = [EncryptionTools decryptFileDataPath:filePath];
    NSDictionary *dataInfo = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
    NSLog(@"解密json文件 : %@", dataInfo);
    
    return dataInfo;
}

#pragma mark - test

+ (void)plistConvertJson:(NSData *)plistData
{
    NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *Json_path = [path stringByAppendingPathComponent:@"SensorsAnalytics.json"];
    //==写入文件
    NSLog(@"Json_path : %@ %@", path,[plistData writeToFile:Json_path atomically:YES] ? @"Succeed":@"Failed");
}

/** json 转 plist文件 */
+ (void)jsonDataTransferplist:(NSData *)jsonData
{
    NSString *filePath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *newPath = [filePath stringByAppendingString:@"/SensorsAnalytics.json"];
    [jsonData writeToFile:newPath atomically:YES];

    NSArray *array = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:newPath] options:NSJSONReadingMutableLeaves error:nil];
    NSString *newPlistPath = [NSString stringWithFormat:@"%@%@", [[NSBundle mainBundle] bundlePath], @"/SensorsAnalytics.plist"];
    [array writeToFile:newPlistPath atomically:YES];

    NSLog(@"SensorsAnalytics = %@", newPlistPath);
}


@end
