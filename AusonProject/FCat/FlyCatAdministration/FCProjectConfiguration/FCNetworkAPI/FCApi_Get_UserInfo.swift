//
//  FCApi_Get_UserInfo.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/22.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_Get_UserInfo: YTKRequest {

    override init() {
        
        super.init()
            
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
            
    override func requestUrl() -> String {
        return "/api/v1/user/info"
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
