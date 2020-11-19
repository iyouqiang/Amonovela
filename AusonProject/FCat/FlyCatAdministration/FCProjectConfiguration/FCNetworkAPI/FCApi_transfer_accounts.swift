//
//  FCApi_transfer_accounts.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/1.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_transfer_accounts: YTKRequest {
    
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    var firstAccount: String?
    var secondAccount: String?
    var asset: String?
    init(firstAccount: String, secondAccount: String, asset: String) {
        super.init()
        
        self.firstAccount = firstAccount
        self.secondAccount = secondAccount
        self.asset = asset
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_API
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/transfer/accounts/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
        
        return ["userId" : userId, "firstAccount": firstAccount, "secondAccount" : secondAccount, "asset" : asset]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
