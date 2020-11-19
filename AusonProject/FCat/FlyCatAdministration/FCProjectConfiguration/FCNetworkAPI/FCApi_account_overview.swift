//
//  FCApiAccountoverview.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/12.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_account_overview: YTKRequest {

    override init() {
        super.init()
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_DOMAIN
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/account/overview/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestArgument() -> Any? {
        
        return ["platform":"IOS"]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
}
