//
//  APICommon_config.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APICommon_config : YTKRequest

//客户端获取配置，每次启动时重新拉取更新即可
- (instancetype)initWithBaseSymbol:(NSString *)baseSymbol;


@end
