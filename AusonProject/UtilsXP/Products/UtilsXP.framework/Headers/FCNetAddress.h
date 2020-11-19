//
//  FCNetAddress.h
//  EncryptionTool
//
//  Created by Yochi on 2020/11/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface FCNetAddress : NSObject

+ (FCNetAddress *)netAddresscl;

@property (nonatomic, copy) NSString *HOSTURL_SPOT;
@property (nonatomic, copy) NSString *HOSTURL_SWAP;
@property (nonatomic, copy) NSString *HOSTURL_API;
@property (nonatomic, copy) NSString *HOSTURL_DOMAIN;
@property (nonatomic, copy) NSString *HOSTURL_INVITE;
@property (nonatomic, copy) NSString *HOSTURL_KYC;
@property (nonatomic, copy) NSString *HOSTURL_ASSETS;
@property (nonatomic, copy) NSString *HOSTURL_TRADE;
@property (nonatomic, copy) NSString *HOSTURL_MASSETS;
@property (nonatomic, copy) NSString *HOSTURL_EASYTRADE;
@property (nonatomic, copy) NSString *HOSTURL_NEWGUIDE;
@property (nonatomic, copy) NSString *HOSTURL_CPEEXCHANGE;
@property (nonatomic, copy) NSString *HOSTURL_TRADESKILL;

@end

NS_ASSUME_NONNULL_END
