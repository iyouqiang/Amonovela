//
//  FCApi_account_all_assets.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/17.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_account_all_assets: YTKRequest {
    
    var hideMicro: Bool?
    
    init(hideMicro:Bool) {
        
        super.init()
        
        self.hideMicro = hideMicro
            
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
        
    override func baseUrl() -> String {
        return HOSTURL_API
    }
        
    override func requestUrl() -> String {
        return "/api/v1/spot/account/all/assets/get"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
        
    override func requestArgument() -> Any? {
            
        return ["hideMicro":hideMicro]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
