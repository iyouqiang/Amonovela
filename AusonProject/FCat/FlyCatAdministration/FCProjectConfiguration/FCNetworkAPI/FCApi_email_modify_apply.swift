//
//  FCApi_email_modify_apply.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_email_modify_apply: YTKRequest {

        var email: String?
        
        init(email:String) {
            
            super.init()
            
            self.email = email
                
            self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        }
            
    //    override func baseUrl() -> String {
    //        return "http://api.chainxp.io"
    //    }
            
        override func requestUrl() -> String {
            return "/api/v1/user/email/modify/apply"
        }
            
        override func requestMethod() -> YTKRequestMethod {
            return .POST
        }
            
        override func requestArgument() -> Any? {
                
            return ["email":email]
        }
            
        override func requestHeaderFieldValueDictionary() -> [String : String]? {
            return requestHeaderFieldValue()
        }
        
        override func requestSerializerType() -> YTKRequestSerializerType {
            return .JSON
    }
}
