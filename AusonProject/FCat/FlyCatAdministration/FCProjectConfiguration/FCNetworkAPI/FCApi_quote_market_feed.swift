//
//  FCApi_quote_market_feed.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_quote_market_feed: YTKRequest {

    var symbol = ""
    var tradingUnit:String = ""
    var precision = ""
    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(tradingUnit: String, symbol: String, precision: String) {
        
        super.init()
    
        self.tradingUnit = tradingUnit
        self.symbol = symbol
        self.precision = precision
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/market/feed/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["tradingUnit" : tradingUnit, "symbol": symbol, "precision": precision]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
