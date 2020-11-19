//
//  FCApi_trigger_history.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trigger_history: YTKRequest {

    var symbol = ""
    var tradingUnit = ""
    var startTime = ""
    var endTime = ""
    
    //Open表示计划委托，Close表示止盈止损，不填或者填All，则一起返回
    
    var triggerType = ""
    /**
     订单状态，
        Triggered表示已触发，
        Canceled表示已撤销，
        TriggerStopLoss表示止损触发，
        TriggerTakeProfit表示止盈触发，
        不填或者填All，则一起返回
     */
    var state = ""
    /**
     交易行为，不填或者填All，则一起返回
        OpenLong表示买入开多，OpenShort表示卖出开空，
        CloseShort表示买入平空，CloseLong表示卖出平多
     */
    var tradingAction = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    
    init(symbol: String,tradingUnit: String, startTime: String, endTime: String, triggerType: String, state: String, tradingAction: String) {
        
        super.init()
        
        self.symbol = symbol
        self.tradingUnit = tradingUnit
        self.startTime = startTime
        self.endTime = endTime
        self.triggerType = triggerType
        self.state = state
        self.tradingAction = tradingAction
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trigger/history/orders/get"
    }
    
    override func requestArgument() -> Any? {

        return ["symbol" : symbol,
                "tradingUnit" : tradingUnit,
                "startTime" : startTime,
                "endTime" : endTime,
                "triggerType" : triggerType,
                "state" : state,
                "userId" : userId,
                "tradingAction" : tradingAction
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
