//
//  FCNetworkUtils.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCNetworkUtils: NSObject {

    static func handleResponse (response: YTKBaseRequest, success: ([String : Any]?) -> Void, failure: ((String?) -> Void)? ) {

        let responseData = response.responseObject as?  [String : AnyObject]
        if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
            let data = responseData?["data"] as? [String : Any]
            success(data)
        } else{
            let err = responseData?["err"]?["msg"] as? String
            failure?(err)
        }
    }
    
    static func handleError (response: YTKBaseRequest, loacalErr: ((String?) -> Void)) {
        
        loacalErr(response.error?.localizedDescription)
    }
}

/// 功能请求头
public func requestHeaderFieldValue() -> [String : String] {

    let token = FCUserInfoManager.sharedInstance.userInfo?.token ?? ""
    print("X-token: ", token)
    return ["X-token" : token]
}
