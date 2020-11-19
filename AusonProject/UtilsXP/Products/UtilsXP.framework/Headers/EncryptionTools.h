//
//  HYEncryptionTools.h
//  HYWidget
//
//  Created by Yochi on 2019/12/30.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>

/**
 *  终端测试指令
 *
 *  DES(ECB)加密
 *  $ echo -n hello | openssl enc -des-ecb -K 616263 -nosalt | base64
 *
 * DES(CBC)加密
 *  $ echo -n hello | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 *  AES(ECB)加密
 *  $ echo -n hello | openssl enc -aes-128-ecb -K 616263 -nosalt | base64
 *
 *  AES(CBC)加密
 *  $ echo -n hello | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt | base64
 *
 *  DES(ECB)解密
 *  $ echo -n HQr0Oij2kbo= | base64 -D | openssl enc -des-ecb -K 616263 -nosalt -d
 *
 *  DES(CBC)解密
 *  $ echo -n alvrvb3Gz88= | base64 -D | openssl enc -des-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  AES(ECB)解密
 *  $ echo -n d1QG4T2tivoi0Kiu3NEmZQ== | base64 -D | openssl enc -aes-128-ecb -K 616263 -nosalt -d
 *
 *  AES(CBC)解密
 *  $ echo -n u3W/N816uzFpcg6pZ+kbdg== | base64 -D | openssl enc -aes-128-cbc -iv 0102030405060708 -K 616263 -nosalt -d
 *
 *  提示：
 *      1> 加密过程是先加密，再base64编码
 *      2> 解密过程是先base64解码，再解密
 */


NS_ASSUME_NONNULL_BEGIN

@interface EncryptionTools : NSObject

/**
 *  加密字符串并返回base64编码字符串
 *
 *  @param string    要加密的字符串
 *  @param keyString 加密密钥
 *  @param iv        初始化向量(8个字节 必须为8个 eg. "12345678")
 *  @param alg       加密算法
 *
 *  @return 返回加密后的base64编码字符串
 */
+ (NSString *)encryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData * __nullable)iv algorithm:(uint32_t)alg;

/**
 *  解密字符串
 *
 *  @param string    加密并base64编码后的字符串
 *  @param keyString 解密密钥
 *  @param iv        初始化向量(8个字节 必须为8个 eg. "12345678")
 *  @param alg       解密算法
 *
 *  @return 返回解密后的字符串
 */
+ (NSString *)decryptString:(NSString *)string keyString:(NSString *)keyString iv:(NSData * __nullable)iv algorithm:(uint32_t)alg;

/**
*  base64编码
*/
+ (NSString *)base64Encode:(NSString *)keyString;

/**
*  base64解码
*/
+ (NSString *)base64Decode:(NSString *)keyString;

/**
*  md5摘要16位
*/
+ (NSString *)md5HexDigest:(NSString *)keyString;

/**
*  md5摘要32位
*/
+ (NSString *)md5Digest:(NSString *)keyString;

/**
 *  ROT13码意思是将字母左移13位
 */
+ (NSString *)rot13String:(NSString *)keyString;

/**
 *  URL encode
 */
+ (NSString *)URLEncodedString:(NSString *)keyString;

/**
 * @parame originFilePath 需要加密的文件
 * @parame encryptFilePath 保存加密文件路径
 * 保存地址为nil,默认保存在document文件下
 */
+ (void)encryptFileDataPath:(NSString *)originFilePath filePath:(nullable NSString *)encryptFilePath;

/**
 * @parame desfilePath 需要解密的文件
 * 对应上面的加密方法
 * 返回 NSData 类型数据
 */
+ (NSData *)decryptFileDataPath:(NSString *)desfilePath;

/// 解密plist文件
+ (id)decryptPlist:(NSString *)filePath;

/// 解密json文件
+ (id)decryptJson:(NSString *)filePath;

/** json 转 plist文件 */
+ (void)jsonDataTransferplist:(NSData *)jsonData;

@end

NS_ASSUME_NONNULL_END
