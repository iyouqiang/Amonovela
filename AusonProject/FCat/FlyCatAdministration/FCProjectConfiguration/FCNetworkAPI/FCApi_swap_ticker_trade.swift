//
//  FCApi_swap_ticker_trade.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/19.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_swap_ticker_trade: YTKRequest {

    /// 合约最新成交
    var symbol = ""
    var precision  = ""

    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol: String, precision:String) {
        
        super.init()
    
        self.symbol = symbol
        self.precision = precision
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/spot/market/trade/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["symbol" : symbol, "precision": precision]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
