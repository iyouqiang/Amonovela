
//
//  FCApi_symbol_asset.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/18.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_symbol_asset: YTKRequest {

    var symbol = ""
    init(symbol:String) {
        super.init()
        self.symbol = symbol
            
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
        
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
        
    override func requestUrl() -> String {
        return "/api/v1/spot/account/symbol/assets/get"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
        
    override func requestArgument() -> Any? {
            
        return ["symbol":symbol]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
    
    
    
}
