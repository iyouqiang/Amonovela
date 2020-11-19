//
//  FCApi_Contract_cancel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_Contract_cancel: YTKRequest {

    var symbol = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    var orderId = ""
    
    init(symbol:String, orderId: String) {
        super.init()
        self.symbol = symbol
        self.orderId = orderId
        
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trade/order/cancel/post"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
        
        return ["symbol":symbol,
                "userId" : userId,
                "orderId" : orderId
              ]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
