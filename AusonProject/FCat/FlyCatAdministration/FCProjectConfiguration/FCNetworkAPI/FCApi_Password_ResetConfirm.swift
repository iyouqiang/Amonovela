//
//  FCApi_Password_ResetConfirm.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/22.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_Password_ResetConfirm: YTKRequest {

    var verificationId: String?
    var verificationCode: String?
    var password: String?
    
    init(verificationId:String, verificationCode: String, password: String) {
        
        super.init()
        
        self.verificationId = verificationId
        self.verificationCode = verificationCode
        self.password = password
            
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
            
    override func requestUrl() -> String {
        return "/api/v1/user/password/reset/confirm"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
        
    override func requestArgument() -> Any? {
            
        return ["verificationId":verificationId, "verificationCode":verificationCode, "password" : (password! as NSString).md5()]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
