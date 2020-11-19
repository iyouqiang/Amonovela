//
//  FCApi_quote_tickers.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_quote_tickers: YTKRequest {
    var parmas: [String : Any] = [:]
    
    init(quote: String) {
        super.init()
        parmas["quote"] = quote
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/spot/market/tickers/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        
       return requestHeaderFieldValue()
    }
    
    override func requestArgument() -> Any? {
        return parmas
    }
}
