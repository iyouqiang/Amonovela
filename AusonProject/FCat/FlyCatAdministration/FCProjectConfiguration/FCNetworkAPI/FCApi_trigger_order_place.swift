//
//  FCApi_trigger_order_place.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trigger_order_place: YTKRequest {

    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    var symbol = ""
    var action = ""
    // Ask表示触发后委托卖出, Bid表示委托买入
    var side = ""
    // 触发来源, FairPrice表示按标记价格触发，TradePrice表示按最新成交价触发
    var triggerSource = ""
    // 触发价格，价格到达触发条件，计划委托开仓填写这个字段
    var triggerPrice = ""
    // 触发止损价格，价格到达触发条件，止盈止损模式下止损价格填写这个
    var stopLossPrice = ""
    // 触发止盈价格，价格到达触发条件，止盈止损模式下止盈价格填写这个
    var takeProfitPrice = ""
    var entrustVolume: Float = 0.0
    var entrustPrice: Float = 0.0
    // 触发之后委托类型: Market表示市价单，Limit表示限价单
    // 如果是对手价，则是前端在下单的时候，
    // 取到最新的深度的第一层对手价，然后以Limit方式下单
    var tradeType = ""
    // 触发之后交易量类型: Percentage表示下单百分比, Cont表示按合约数量下单, default is Cont
    var volumeType = ""
    // 交易单位，CONT表示张，COIN直接表示BTC，ETH等资产
    var tradingUnit = ""
    // 对应的持仓ID，可选，如果用户是对持仓进行止盈止损则需要填写
    var positionId = ""
    
    init(symbol:String,action:String,side:String,triggerSource:String,triggerPrice:String,stopLossPrice:String =  "0",takeProfitPrice:String = "0",entrustVolume:Float,entrustPrice:Float,tradeType:String,volumeType:String,tradingUnit:String,positionId:String = "") {
        
        super.init()
        
        self.symbol = symbol
        self.action = action
        self.side = side
        self.triggerSource = triggerSource
        self.triggerPrice = triggerPrice
        self.stopLossPrice = stopLossPrice
        self.takeProfitPrice = takeProfitPrice
        self.entrustVolume = entrustVolume
        self.entrustPrice = entrustPrice
        self.tradeType = tradeType
        self.volumeType = volumeType
        self.tradingUnit = tradingUnit
        self.positionId = positionId
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trigger/order/place/post"
    }
    
    override func requestArgument() -> Any? {
                
        return ["trigger" : ["symbol" : symbol,
                             "action" : action,
                             "side" : side,
                             "triggerSource" : triggerSource,
                             "triggerPrice" : triggerPrice,
                             "stopLossPrice" : stopLossPrice,
                             "takeProfitPrice" : takeProfitPrice,
                             "entrustVolume" : entrustVolume,
                             "EntrustPrice" : entrustPrice,
                             "tradeType" : tradeType,
                             "volumeType" : volumeType,
                             "tradingUnit" : tradingUnit,
                             "positionId" : positionId],
                "userId" : userId
        ]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
