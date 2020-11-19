//
//  FCApi_spot_market_depth.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/21.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_spot_market_depth: YTKRequest {

    var symbol = ""
    var step = ""
    
    init(symbol: String,step: String) {
        
        super.init()
        
        self.symbol = symbol
        self.step = step
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/spot/market/depth/get"
    }
    
    override func requestArgument() -> Any? {

        return ["symbol" : symbol,
                "step" : step]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
