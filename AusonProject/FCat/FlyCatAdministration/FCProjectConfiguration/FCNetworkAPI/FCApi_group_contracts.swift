//
//  FCApi_group_contracts.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/19.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_group_contracts: YTKRequest {

    /// 合约最新成交
    var tradingUnit = ""
    var optional = ""
    
    // CONT表示张，COIN直接表示BTC，ETH等资产
    // group表示分组，包括: Optional(自选), USDT-Swap(USDT合约), Selected-Swap(精选合约)

    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(optional: String, tradingUnit: String) {
        
        super.init()
    
        self.tradingUnit = tradingUnit
        self.optional = optional
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/group/contracts/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["tradingUnit" : tradingUnit, "group" : optional]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
