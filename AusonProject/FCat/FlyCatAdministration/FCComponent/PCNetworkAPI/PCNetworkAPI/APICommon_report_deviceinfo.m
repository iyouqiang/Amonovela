//
//  Common_report_deviceinfoAPI.m
//  PurCowExchange
//
//  Created by Yochi on 2018/7/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "APICommon_report_deviceinfo.h"
#import "NSString+PCExtend.h"
#import "PCRequesthelper.h"

@implementation APICommon_report_deviceinfo
{
//    "platform":"1",        #系统平台:1=ios,2=android
//    "system_version":"",   #系统版本号
//    "identify":"",         #设备唯一识别号
//    "version":"",          #app软件版本号
//    "channel_id":"",       #app渠道
//    "member_id":"",        #可选，用户member_id，未登录情况下为空
//    "imei":"",             #可选.设备IEMI
//    "mac":"",              #可选.设备MAC地址
//    "model":"",            #设备品牌名/型号
//    "network_type":"",     #设备网络接入方式
//    "ip":"",               #设备IP地址，客户端取到的是内网IP或路由IP
//    "device_name":""       #设备名称

    NSString *_platform;
    NSString *_system_version;
    NSString *_identify;
    NSString *_version;
    NSString *_channel_id;
    NSString *_member_id;
    NSString *_model;
    NSString *_network_type;
    NSString *_ip;
    NSString *_device_name;
}

- (id)initWithMember_id:(NSString *)member_id
{
    self = [super init];
    if (self) {
        _system_version = [UIDevice currentDevice].systemVersion;
        _identify = [NSString getDeviceUUID];
        _version = [NSString getLocalAppVersion];
        _channel_id = @"app";
        _member_id = member_id;
        _model = [NSString getDeviceModel];
        _network_type = [PCRequesthelper shareRequestHelpler].networkType;
        _ip = [NSString getIPAddress:YES];
        _device_name = [NSString getDeviceName];
    }
    return self;
}

- (NSString *)requestUrl {

    //客户端上报设备信息，在每次启动APP的时候触发
    return @"/api/common/reportdeviceinfo";
}

- (YTKRequestMethod)requestMethod {
    return YTKRequestMethodPOST;
}

- (id)requestArgument {
    
    NSMutableDictionary *parameter = [PCRequesthelper globalParameter];
    [parameter setPreventNullValue:_system_version forKey:@"system_version"];
    [parameter setPreventNullValue:_identify forKey:@"identify"];
    [parameter setPreventNullValue:_version forKey:@"version"];
    [parameter setPreventNullValue:_channel_id forKey:@"channel_id"];
    [parameter setPreventNullValue:_member_id forKey:@"member_id"];
    [parameter setPreventNullValue:_model forKey:@"model"];
    [parameter setPreventNullValue:_network_type forKey:@"network_type"];
    [parameter setPreventNullValue:_ip forKey:@"ip"];
    [parameter setPreventNullValue:_device_name forKey:@"device_name"];
    [parameter setPreventNullValue:[PCRequesthelper signString:parameter] forKey:@"sign"];
    
    return parameter;
}

@end
