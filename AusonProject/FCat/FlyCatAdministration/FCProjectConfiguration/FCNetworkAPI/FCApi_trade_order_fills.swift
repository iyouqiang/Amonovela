//
//  FCApi_trade_order_fills.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trade_order_fills: YTKRequest {

    /**
     // 请求参数: symbol=BTC-USDT,userId=1001,startTime=2019-12-01 00:00:00,endTime=2019-12-01 23:59:59
     // tradingUnit=CONT
     // symbol表示请求合约产品
     // userId表示请求指定用户ID
     // orderId表示开始时间
     // endTime表示结束时间
     //             tradingUnit表示交易单位，CONT表示张，COIN直接表示BTC，ETH等资产
     */
    
    var symbol = ""
    var orderId = ""
    var tradingUnit:String = ""
    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(orderId:String, tradingUnit: String, symbol: String = "") {
        
        super.init()
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        self.tradingUnit = tradingUnit
        self.symbol = symbol
        self.orderId = orderId
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trade/order/fills/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
        
        return ["userId" : userId,
                "tradingUnit" : tradingUnit,
                "orderId" :  orderId,
                "symbol" : self.symbol]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
    
}
