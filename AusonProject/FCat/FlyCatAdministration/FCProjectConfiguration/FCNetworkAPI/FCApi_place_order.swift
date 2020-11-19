
//
//  FCApi_place_order.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/18.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_place_order: YTKRequest {
    
    // 交易量类型: Percentage表示下单百分比, Value表示按合约张数下单, default is Value
    var volumeType = ""
    var symbol = ""
    var entrustVolume = ""
    var entrustPrice = ""
    var side = ""
    var tradeType = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol:String, price: String, volume: String, orderType: String, markerSide: String, volumeType: String) {
        super.init()
        self.symbol = symbol
        self.entrustPrice = price
        self.entrustVolume = volume
        self.side = markerSide
        self.tradeType = orderType
        self.volumeType = volumeType
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        //return "/api/v1/spot/trading/order/place/post"
        return "/api/v1/spot/trade/order/place/post"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
        
        return [
            "symbol":symbol,
            "entrustPrice": Float64(entrustPrice) ?? 0.0,
            "entrustVolume": Float64(entrustVolume) ?? 0.0,
            "side":side,
            "tradeType": tradeType,
            "userId": userId,
            "volumeType": volumeType
        ]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
