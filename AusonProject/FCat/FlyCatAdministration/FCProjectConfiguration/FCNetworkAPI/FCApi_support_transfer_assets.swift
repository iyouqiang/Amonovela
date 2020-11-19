//
//  FCApi_support_transfer_assets.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/25.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_support_transfer_assets: YTKRequest {

    /// 合约最新成交
    var firstAccount = ""
    var secondAccount = ""
    
    // CONT表示张，COIN直接表示BTC，ETH等资产
    // group表示分组，包括: Optional(自选), USDT-Swap(USDT合约), Selected-Swap(精选合约)

    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(firstAccount: String, secondAccount: String) {
        
        super.init()
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    
        self.firstAccount = firstAccount
        self.secondAccount = secondAccount
    }
    
    override func baseUrl() -> String {
        return HOSTURL_API
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/support/transfer/assets/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
                
        return ["firstAccount" : firstAccount, "secondAccount" : secondAccount]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
