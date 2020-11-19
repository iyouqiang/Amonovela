//
//  FCApi_all_symbol.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/25.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_all_symbol: YTKRequest {

    override init() {
        super.init()
        self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    
    override func baseUrl() -> String {
        return HOSTURL_SPOT
    }
    
    override func requestUrl() -> String {
        return "/api/v1/spot/market/all/symbols/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }

}
