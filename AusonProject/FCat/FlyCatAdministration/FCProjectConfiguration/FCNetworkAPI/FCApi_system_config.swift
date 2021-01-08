//
//  FCApi_system_config.swift
//  Auson
//
//  Created by Yochi on 2021/1/4.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit

class FCApi_system_config: YTKRequest {

    override init() {
        
        super.init()
    }
            
    override func requestUrl() -> String {
        return "api/v1/app/system/config/get"
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
