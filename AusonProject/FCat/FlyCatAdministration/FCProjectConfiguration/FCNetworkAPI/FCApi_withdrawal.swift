//
//  FCApi_withdrawal.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_withdrawal: YTKRequest {

    var userId = ""
    var digitalSymbol = ""
    var digitalAddress = ""
    var volume = ""
        
    init(userId:String, digitalSymbol:String, digitalAddress:String, volume:String) {
        super.init()
        self.userId = userId
        self.digitalSymbol = digitalSymbol
        self.digitalAddress = digitalAddress
        self.volume = volume
            
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
        
    override func baseUrl() -> String {
        return HOSTURL_API
    }
    
    override func requestUrl() -> String {
        return "/api/v1/wallet/withdrawal"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
        
    override func requestArgument() -> Any? {
            
        // "volume":(volume as NSString).floatValue
        return ["userId":userId, "digitalSymbol":digitalSymbol, "digitalAddress":digitalAddress, "volume":volume]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
