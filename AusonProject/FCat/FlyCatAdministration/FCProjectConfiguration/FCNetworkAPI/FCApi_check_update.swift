//
//  FCApi_check_update.swift
//  Auson
//
//  Created by Yochi on 2021/1/16.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit

class FCApi_check_update: YTKRequest {

    override init() {
        
        super.init()
    }
            
    override func requestUrl() -> String {
        return "/api/v1/app/check/update/version/post"
    }
    
    override func requestArgument() -> Any? {
        return ["platform":"IOS", "currentVersion":"1.0.0(\(NSString.getAppBuildNumber() ?? ""))"]
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
