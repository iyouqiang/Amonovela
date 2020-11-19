//
//  FCApi_swap_latest_ticker.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/19.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_swap_latest_ticker: YTKRequest {

    /// 合约最新成交
    var symbol = ""

    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol: String) {
        
        super.init()
    
        self.symbol = symbol
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/market/latest/ticker/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["symbol" : symbol]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
