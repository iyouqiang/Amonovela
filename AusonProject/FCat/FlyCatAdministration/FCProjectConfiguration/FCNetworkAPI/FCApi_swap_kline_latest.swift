//
//  FCApi_swap_kline_latest.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/19.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_swap_kline_latest: YTKRequest {

    var symbol = ""
    var klineType  = ""
    var tradingUnit = ""
    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol: String, klineType:String, tradingUnit: String) {
        
        super.init()
    
        self.symbol = symbol
        self.klineType = klineType
        self.tradingUnit = tradingUnit
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/kline/latest/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["symbol" : symbol, "klineType": klineType, "tradingUnit": tradingUnit]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
