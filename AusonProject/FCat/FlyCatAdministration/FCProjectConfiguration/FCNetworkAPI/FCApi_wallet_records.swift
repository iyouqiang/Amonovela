//
//  FCApi_wallet_records.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_wallet_records: YTKRequest {

    var userId = ""
    // All或者空表示不过滤
    // Deposit表示只显示入金
    // Withdrawal表示只显示出金
    var action = ""
    // 资产过滤，All或者空表示不过滤，BTC表示按只要BTC的，ETH表示只要ETH的
    var asset = ""
    var page = 0
    var pageSize = 0
    var startTime = ""
    var endTime = ""
        
    init(userId:String, action:String, asset:String, page:Int, pageSize:Int, startTime:String, endTime: String) {
        super.init()
        self.userId = userId
        self.action = action
        self.asset = asset
        self.page = page
        self.pageSize = pageSize
        self.pageSize = pageSize
        self.startTime = startTime
        self.endTime = endTime
            
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
        
    override func baseUrl() -> String {
        return HOSTURL_API
    }
        
    override func requestUrl() -> String {
        return "/api/v1/wallet/records/search"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
        
    override func requestArgument() -> Any? {
            
        return ["userId":userId, "action":action, "asset":asset, "page":page, "pageSize":pageSize, "startTime":startTime, "endTime":endTime]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
