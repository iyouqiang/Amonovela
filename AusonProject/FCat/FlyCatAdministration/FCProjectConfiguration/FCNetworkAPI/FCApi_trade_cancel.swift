
//
//  FCApi_trade_cancel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trade_cancel: YTKRequest {
    var symbol = ""
    var orderId = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(symbol:String, orderId: String) {
        super.init()
        self.symbol = symbol
        self.orderId = orderId
        //        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/spot/trade/order/cancel/post"
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
