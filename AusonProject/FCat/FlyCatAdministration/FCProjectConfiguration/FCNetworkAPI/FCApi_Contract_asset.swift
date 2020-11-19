//
//  FCApi_Contract_asset.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_Contract_asset: YTKRequest {

    var symbol = ""
    var tradingUnit = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol:String, tradingUnit: String) {
        super.init()
        self.symbol = symbol
        self.tradingUnit = tradingUnit
    }
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
        
    override func requestUrl() -> String {
        return "/api/v1/cts/account/info/get"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
        
    override func requestArgument() -> Any? {
            
        return ["symbol":symbol, "userId" : self.userId, "tradingUnit" : tradingUnit]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
