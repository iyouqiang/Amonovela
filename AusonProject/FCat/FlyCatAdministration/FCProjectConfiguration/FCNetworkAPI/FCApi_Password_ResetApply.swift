//
//  FC_Password_ResetApply.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/22.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_Password_ResetApply: YTKRequest {

    // 通道类型 Phone表示手机注册，Email表示邮箱注册
    var channelType = ""
    var phoneCode = ""
    var phoneNumber = ""
    var email = ""
    
    init(channelType:String, phoneCode: String = "", phoneNumber: String = "", email: String = "") {
        
        super.init()
        
        self.channelType = channelType
        self.phoneCode = phoneCode
        self.phoneNumber = phoneNumber
        self.email = email
            
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
        
    override func requestUrl() -> String {
        return "/api/v1/user/password/reset/apply"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
        
    override func requestArgument() -> Any? {
            
        return ["channelType" : channelType, "email" : email ,"phoneCode":phoneCode, "phoneNumber":phoneNumber]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
}
}
