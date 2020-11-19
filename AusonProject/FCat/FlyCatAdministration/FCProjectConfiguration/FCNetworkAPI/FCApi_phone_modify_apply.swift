//
//  FCApi_phone_modify_apply.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_phone_modify_apply: YTKRequest {

        var phoneCode: String?
        var phoneNumber: String?
        
        init(phoneCode:String, phoneNumber: String) {
            
            super.init()
            
            self.phoneCode = phoneCode
            self.phoneNumber = phoneNumber
                
            self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        }
            
    //    override func baseUrl() -> String {
    //        return "http://api.chainxp.io"
    //    }
            
        override func requestUrl() -> String {
            return "/api/v1/user/phone/modify/apply"
        }
            
        override func requestMethod() -> YTKRequestMethod {
            return .POST
        }
            
        override func requestArgument() -> Any? {
                
            return ["phoneCode":phoneCode, "phoneNumber":phoneNumber]
        }
            
        override func requestHeaderFieldValueDictionary() -> [String : String]? {
            return requestHeaderFieldValue()
        }
        
        override func requestSerializerType() -> YTKRequestSerializerType {
            return .JSON
    }
}
