//
//  FCApi_swap_kline_history.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/19.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_swap_kline_history: YTKRequest {

    var symbol = ""
    var klineType  = ""
    var startTs = ""
    var endTs = ""
    var tradingUnit = ""
    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol: String, klineType:String, tradingUnit: String, startTs: String, endTs: String) {
        
        super.init()
    
        self.tradingUnit = tradingUnit
        self.symbol = symbol
        self.klineType = klineType
        self.startTs = startTs
        self.endTs = endTs
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/kline/history/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["symbol" : symbol, "klineType": klineType, "startTs": startTs, "endTs" : endTs, "tradingUnit": tradingUnit]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
