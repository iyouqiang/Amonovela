//
//  FCNetAddress.m
//  EncryptionTool
//
//  Created by Yochi on 2020/11/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import "FCNetAddress.h"
#import "EncryptionTools.h"

@interface FCNetAddress()

@end

@implementation FCNetAddress

+ (FCNetAddress *)netAddresscl
{
    static FCNetAddress *netAddress;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
       netAddress = [[FCNetAddress alloc] init];
        
        NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"UtilsXPBundle" ofType:@"bundle"]];
        
        NSString *plistPath = [bundle pathForResource:@"NetworkAddress" ofType:nil];
        
        NSLog(@"plistPath : %@", plistPath);
        
        NSData *plistData = [EncryptionTools decryptFileDataPath:plistPath];
        
        NSLog(@"plistData : %@", plistData);
        
        if (!plistData) {
            NSLog(@"未获取解密数据");
            return;
        }
        
        NSError *error;
        NSPropertyListFormat format;
        NSDictionary *dictionary = [NSPropertyListSerialization propertyListWithData:plistData options:NSPropertyListImmutable format:&format error:&error];
        NSLog(@"AAdictionary : %@ %@", dictionary, error);
        [netAddress setValuesForKeysWithDictionary:dictionary];
    });
    
    /**
     "" = "https://api.chex.pro";
     "HOSTURL_ASSETS" = "\"https://c2c.chex.pro/assets";
     "HOSTURL_CPEEXCHANGE" = "https://supportchex.zendesk.com/hc/zh-cn/articles/900003238606-%E5%85%B3%E4%BA%8EChampagne-Exchange";
     "HOSTURL_DOMAIN" = "https://app-api.chex.pro";
     "HOSTURL_EASYTRADE" = "https://c2c.chex.pro/easy-trade";
     "HOSTURL_INVITE" = "https://www.chex.pro/invite";
     "HOSTURL_KYC" = "https://www.chex.pro/account/kyc";
     "HOSTURL_MASSETS" = "https://c2c.chex.pro/assets";
     "HOSTURL_NEWGUIDE" = "https://supportchex.zendesk.com/hc/zh-cn/categories/900000201863-%E6%96%B0%E6%89%8B%E6%8C%87%E5%8D%97";
     "HOSTURL_SPOT" = "https://spot.chex.pro";
     "HOSTURL_SWAP" = "https://swap.chex.pro";
     "HOSTURL_TRADE" = "https://c2c.chex.pro/easy-trade";
     "HOSTURL_TRADESKILL" = "https://supportchex.zendesk.com/hc/zh-cn/sections/900000476043-%E6%93%8D%E4%BD%9C%E6%8C%87%E5%BC%95";
 }
     */
    return netAddress;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
