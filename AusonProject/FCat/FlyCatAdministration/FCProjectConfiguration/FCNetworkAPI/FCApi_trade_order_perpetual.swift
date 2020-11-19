//
//  FCApi_trade_order_perpetual.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/2.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trade_order_perpetual: YTKRequest {
    /**
        UserID        string  `json:"userId"`        // 用户ID
        Symbol        string  `json:"symbol"`        // 下单指定的交易对
        EntrustVolume float64 `json:"entrustVolume"` // 委托合约数量
        EntrustPrice  float64 `json:"entrustPrice"`  // 委托合约价格
        Side          string  `json:"side"`          // 委托方向: Bid表示买单，Ask表示卖单
        Action        string  `json:"action"`        // 操作类型: Open表示开仓, Close表示平仓
        TradeType     string  `json:"tradeType"`     // 委托类型: Market表示市价单，Limit表示限价单
        // 交易量类型: Percentage表示下单百分比, Cont表示按合约张数下单, default is Cont
        VolumeType string `json:"volumeType"`
        // 交易单位，CONT表示张，COIN直接表示BTC，ETH等资产
        TradingUnit string `json:"tradingUnit"`
        */
       var symbol = ""
       var tradingUnit = ""
       var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
       var entrustVolume = "0.00"
       var entrustPrice = "0.00"
       var side = ""
       var action = ""
       var tradeType = ""
       var volumeType = ""
       
       init(symbol:String, tradingUnit: String, entrustVolume: String, entrustPrice: String, side: String, action: String, tradeType: String, volumeType: String) {
           super.init()
           self.symbol = symbol
           self.tradingUnit = tradingUnit
           self.entrustVolume = entrustVolume
           self.entrustPrice = entrustPrice
           self.side = side
           self.action = action
           self.tradeType = tradeType
           self.volumeType = volumeType
           
       }
       
       override func baseUrl() -> String {
           return HOSTURL_SPOT
       }
       
       override func requestUrl() -> String {
           return "/api/v1/cts/trade/order/place/post"
       }
       
       override func requestMethod() -> YTKRequestMethod {
           return .POST
       }
       
       override func requestArgument() -> Any? {
           
           return ["symbol":symbol,
                   "userId" : userId,
                   "tradingUnit" : tradingUnit,
                   "entrustVolume":Float(entrustVolume)!,
                   "entrustPrice" : Float(entrustPrice)!,
                   "side" : side,
                   "action":action,
                   "tradeType" : tradeType,
                   "volumeType" : volumeType,]
       }
       
       override func requestHeaderFieldValueDictionary() -> [String : String]? {
           return requestHeaderFieldValue()
       }
       
       override func requestSerializerType() -> YTKRequestSerializerType {
           return .JSON
       }
}
