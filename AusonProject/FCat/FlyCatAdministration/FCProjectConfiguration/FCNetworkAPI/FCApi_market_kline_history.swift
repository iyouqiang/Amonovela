//
//  FCApi_market_kline_history.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/19.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_market_kline_history: YTKRequest {
    
    var symbol = ""
    var klineType  = ""
    var startTs = ""
    var endTs = ""
    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol: String, klineType:String, startTs: String, endTs: String) {
        
        super.init()
    
        self.symbol = symbol
        self.klineType = klineType
        self.startTs = startTs
        self.endTs = endTs
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/spot/market/kline/history/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["symbol" : symbol, "klineType": klineType, "startTs": startTs, "endTs" : endTs]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
