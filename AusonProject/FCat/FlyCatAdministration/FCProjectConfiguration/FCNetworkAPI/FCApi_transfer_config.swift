//
//  FCApi_transfer_config.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/25.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_transfer_config: YTKRequest {
    
    override init() {
        
        super.init()
        
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_API
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/transfer/config/get"
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
