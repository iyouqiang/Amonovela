//
//  FCApi_trigger_pending_orders.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trigger_pending_orders: YTKRequest {

    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    var symbol = ""
    var tradingUnit = ""
    
    /// Open表示计划委托，Close表示止盈止损，不填或者填All，则一起返回
    var triggerType = ""
    
    init(symbol:String,tradingUnit:String,triggerType:String = "") {
        
        super.init()
        
        self.symbol = symbol
        self.triggerType = triggerType
        self.tradingUnit = tradingUnit
        
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trigger/pending/orders/get"
    }
    
    override func requestArgument() -> Any? {
                
        return ["symbol" : symbol,
                "triggerType" : triggerType,
                "tradingUnit" : tradingUnit,
                "userId" : userId
        ]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
