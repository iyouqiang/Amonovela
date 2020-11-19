//
//  FCApi_deposit.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_deposit: YTKRequest {

    var userId = ""
    var digitalSymbol = ""
    
    init(userId:String, digitalSymbol:String) {
        super.init()
        self.userId = userId
        self.digitalSymbol = digitalSymbol
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_API
    }
    
    override func requestUrl() -> String {
        return "/api/v1/wallet/deposit"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
        
        return ["userId":userId, "digitalSymbol":digitalSymbol,"platform":"IOS"]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}

