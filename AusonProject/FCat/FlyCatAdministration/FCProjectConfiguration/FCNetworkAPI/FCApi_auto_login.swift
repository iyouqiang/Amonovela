//
//  FCApi_auto_login.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_auto_login: YTKRequest {
        
    override init() {
            
        super.init()
            
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
            
    //    override func baseUrl() -> String {
    //        return "http://api.chainxp.io"
    //    }
            
        override func requestUrl() -> String {
            return "/api/v1/user/auto/login"
        }
            
        override func requestMethod() -> YTKRequestMethod {
            return .POST
        }
            
        override func requestArgument() -> Any? {
                
            let token = FCUserInfoManager.sharedInstance.userInfo?.token ?? ""
            return ["token":token]
        }
            
        override func requestHeaderFieldValueDictionary() -> [String : String]? {
            return requestHeaderFieldValue()
        }
        
        override func requestSerializerType() -> YTKRequestSerializerType {
            return .JSON
        }
}
