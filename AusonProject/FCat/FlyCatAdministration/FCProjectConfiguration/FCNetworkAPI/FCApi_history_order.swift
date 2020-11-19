
//
//  FCApi_history_order.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/18.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_history_order: YTKRequest {
    var symbol = ""
    var startTime: Int = 0
    var endTime: Int = 0
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol:String, startTime: Int, endTime: Int) {
           super.init()
           self.symbol = symbol
           self.startTime = startTime
           self.endTime = endTime
           //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
       }
           
       override func baseUrl() -> String {
           return HOSTURL_SPOT
       }
           
       override func requestUrl() -> String {
           return "/api/v1/spot/trade/history/orders/get"
       }
           
       override func requestMethod() -> YTKRequestMethod {
           return .GET
       }
           
       override func requestArgument() -> Any? {
        
        return ["symbol":symbol,
                "userId" : userId,
                "startTime" : startTime,
                "endTime" : endTime
         ]
       }
           
       override func requestHeaderFieldValueDictionary() -> [String : String]? {
           return requestHeaderFieldValue()
       }
       
       override func requestSerializerType() -> YTKRequestSerializerType {
           return .JSON
       }
       
}

//extension Date {
//    /// 获取当前 毫秒级 时间戳 - 13位
//    var milliStamp : String {
//        let timeInterval: TimeInterval = self.timeIntervalSince1970
//        let millisecond = CLongLong(round(timeInterval*1000))
//        return "\(millisecond)"
//    }
//}
