//
//  FCApi_all_contracts.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_all_contracts: YTKRequest {

    var symbol = ""
    var tradingUnit:String = ""
    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(tradingUnit: String) {
        
        super.init()
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        self.tradingUnit = tradingUnit
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/all/contracts/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
        
        return ["tradingUnit" : tradingUnit]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
