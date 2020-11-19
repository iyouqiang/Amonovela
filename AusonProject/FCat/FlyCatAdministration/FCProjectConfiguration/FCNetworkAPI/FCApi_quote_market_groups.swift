//
//  FCApi_quote_market_groups.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/20.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_quote_market_groups: YTKRequest {

    override init() {
        super.init()
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/quote/market/groups/get"
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

