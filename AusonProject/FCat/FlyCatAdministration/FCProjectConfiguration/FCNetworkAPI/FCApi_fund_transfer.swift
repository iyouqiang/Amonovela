//
//  FCApi_fund_transfer.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/1.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_fund_transfer: YTKRequest {

    var fromAccount:String = ""
    var toAccount:String = ""
    var asset:String = ""
    var amount:Float = 0.0
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    
    init(fromAccount:String, toAccount:String, asset: String ,amount: Float) {
        super.init()
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        
        self.amount = amount
        self.toAccount = toAccount
        self.asset = asset
        self.fromAccount = fromAccount
        self.toAccount = toAccount
    }
    
    override func baseUrl() -> String {
        return HOSTURL_API
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/transfer/asset/post"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
        
        return ["userId" : userId,
                "fromAccount":fromAccount,
                "toAccount":toAccount,
                "asset" : asset,
                "amount":amount]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
