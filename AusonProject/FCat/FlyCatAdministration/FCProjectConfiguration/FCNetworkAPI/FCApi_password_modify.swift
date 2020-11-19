//
//  FCApi_password_modify.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/21.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_password_modify: YTKRequest {

    var userId: String?
    var oldPassword: String?
    var newPassword: String?
    
    init(userId:String, oldPassword: String, newPassword: String) {
        
        super.init()
        
        self.userId = userId
        self.oldPassword = oldPassword
        self.newPassword = newPassword
            
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
        
//    override func baseUrl() -> String {
//        return "http://api.chainxp.io"
//    }
        
    override func requestUrl() -> String {
        return "/api/v1/user/password/modify"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
        
    override func requestArgument() -> Any? {
            
        return ["userId":userId, "oldPassword":(oldPassword! as NSString).md5(), "newPassword" : (newPassword! as NSString).md5()]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
