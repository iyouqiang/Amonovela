//
//  FCApi_ccount_positions.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/29.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_Account_positions: YTKRequest {

    /**
     // 请求参数: symbol=BTC-USDT,userId=1001,tradingUnit=CONT
     
        symbol表示请求合约产品
        userId表示请求指定用户ID
        tradingUnit表示交易单位，CONT表示张，COIN直接表示BTC，ETH等资产
     */
    
    var symbol = ""
    var tradingUnit = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol:String, tradingUnit: String) {
        super.init()
        self.symbol = symbol
        self.tradingUnit = tradingUnit
    }
    
    override func baseUrl() -> String {
        return "http://spot.chainxp.io"
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/account/positions/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
        
        return ["symbol":symbol,
                "userId" : userId,
                "tradingUnit" : tradingUnit
        ]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
