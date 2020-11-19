//
//  FCApi_transfer_records.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/25.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_transfer_records: YTKRequest {

    
    var startTime = ""
    var endTime = ""
    var Asset = ""
    var fromAccount = ""
    var toAccount = ""
    var page = ""
    var pageSize = ""

    var userId =  FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    init(startTime: String, endTime: String, Asset: String, fromAccount: String, toAccount: String, page: String, pageSize: String) {
        
        super.init()
    
        self.startTime = startTime
        self.endTime = endTime
        self.Asset = Asset
        self.fromAccount = fromAccount
        self.toAccount = toAccount
        self.page = page
        self.pageSize = pageSize
    }
    
    override func baseUrl() -> String {
        return HOSTURL_API
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/transfer/records/search/post"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
                
        return ["userId" : userId, "startTime" : startTime, "endTime": endTime, "Asset" : Asset, "fromAccount" : fromAccount, "toAccount" : toAccount, "page" : page, "pageSize" : pageSize]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
