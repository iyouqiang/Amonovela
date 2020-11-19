//
//  FCApi_trading_strategy.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/31.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trading_strategy: YTKRequest {

    var symbol = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    
    init(symbol:String) {
        super.init()
        
        self.symbol = symbol
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trading/strategy/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
        
        return ["symbol":symbol,
                "userId" : userId]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
