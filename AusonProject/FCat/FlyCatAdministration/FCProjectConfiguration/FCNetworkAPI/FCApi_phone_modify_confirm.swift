//
//  FCApi_phone_modify_confirm.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_phone_modify_confirm: YTKRequest {

        var verificationId: String?
        var verificationCode: String?
        var loginPassword: String?
        
        init(verificationId:String, verificationCode: String, loginPassword: String) {
            
            super.init()
            
            self.verificationId = verificationId
            self.verificationCode = verificationCode
            self.loginPassword = loginPassword
                
            self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
        }
            
    //    override func baseUrl() -> String {
    //        return "http://api.chainxp.io"
    //    }
            
        override func requestUrl() -> String {
            return "/api/v1/user/phone/modify/confirm"
        }
            
        override func requestMethod() -> YTKRequestMethod {
            return .POST
        }
            
        override func requestArgument() -> Any? {
                
            return ["verificationId":verificationId, "verificationCode":verificationCode, "loginPassword" : (loginPassword! as NSString).md5()]
        }
            
        override func requestHeaderFieldValueDictionary() -> [String : String]? {
            return requestHeaderFieldValue()
        }
        
        override func requestSerializerType() -> YTKRequestSerializerType {
            return .JSON
        }
}
