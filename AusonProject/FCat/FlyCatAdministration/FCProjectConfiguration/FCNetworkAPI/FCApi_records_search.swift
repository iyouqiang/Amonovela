//
//  FCApi_records_search.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/1.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_records_search: YTKRequest {
    
     var symbol = ""
    /**
     UserID    string `json:"userId"`    // 用户ID
     StartTime string `json:"startTime"` // 起始时间，格式为2019-12-01 00:00:00
     EndTime   string `json:"endTime"`   // 结束时间，格式为2019-12-01 23:59:59
     // 交易单位，CONT表示张，COIN直接表示BTC，ETH等资产
     TradingUnit string `json:"tradingUnit"`
     */
    var startTime:String = ""
    var endTime:String = ""
    var tradingUnit:String = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    
    init(startTime:String , endTime: String ,tradingUnit: String) {
        super.init()
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        
        self.startTime = startTime
        self.endTime = endTime
        self.tradingUnit = tradingUnit
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "api/v1/cts/fund/records/search/post"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
        
        return ["userId" : userId,
                "startTime":startTime,
                "endTime":endTime,"tradingUnit" : tradingUnit]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
    
}
