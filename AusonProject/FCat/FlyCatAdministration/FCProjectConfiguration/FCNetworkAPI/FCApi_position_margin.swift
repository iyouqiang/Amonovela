//
//  FCApi_position_margin.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/30.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_position_margin: YTKRequest {

    var volume = ""
    var positionId = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    // Increase: 增加保证金，Decrease: 减少保证金
    var marginSide = ""
    var symbol = ""
    
    init(positionId:String, volume: String, symbol: String, marginSide: String) {
        super.init()
        
        self.symbol = symbol
        self.volume = volume
        self.positionId = positionId
        self.marginSide = marginSide
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/position/margin/set"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
        
        return ["symbol":symbol,
                "userId" : userId,
                "positionId" : positionId,
                "volume" : Float(volume)!,
                "marginSide" : marginSide,
                ]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
    
}
