//
//  FCApi_quote_one_contract.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_quote_one_contract: YTKRequest {

    var symbol = ""
    var tradingUnit:String = ""
    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(tradingUnit: String, symbol: String) {
        
        super.init()
        
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        self.tradingUnit = tradingUnit
        self.symbol = symbol
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/one/contract/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
        
        return ["tradingUnit" : tradingUnit, "symbol": symbol]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
