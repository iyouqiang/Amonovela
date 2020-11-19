//
//  FCApi_trigger_order_cancel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trigger_order_cancel: YTKRequest {

    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    var symbol = ""
    var orderId = ""

    init(symbol:String,orderId:String) {
        
        super.init()
        
        self.symbol = symbol
        self.orderId = orderId
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trigger/order/cancel/post"
    }
    
    override func requestArgument() -> Any? {
                
        return ["symbol" : symbol,
                "orderId" : orderId,
                "userId" : userId
        ]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
