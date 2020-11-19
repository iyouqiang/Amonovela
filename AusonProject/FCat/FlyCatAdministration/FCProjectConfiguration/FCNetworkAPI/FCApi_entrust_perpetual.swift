//
//  FCApi_entrust_perpetual.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_entrust_perpetual: YTKRequest {
    
    var symbol = ""
    var tradingUnit = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol:String, tradingUnit: String) {
        super.init()
        self.symbol = symbol
        self.tradingUnit = tradingUnit
//        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trade/pending/orders/get"
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
