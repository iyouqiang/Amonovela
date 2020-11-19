//
//  Common_report_deviceinfoAPI.h
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "YTKRequest.h"

@interface APICommon_report_deviceinfo : YTKRequest

//客户端上报设备信息，在每次启动APP的时候触发
- (id)initWithMember_id:(NSString *)member_id;

@end
