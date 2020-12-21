//
//  FCApi_home_feed.swift
//  Auson
//
//  Created by Yochi on 2020/12/6.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_home_feed: YTKRequest {

    var sort = ""  // Volume Change
    var order = "" // Desc Asc

    init(sort: String, order: String) {
   
        self.order = order
        self.sort = sort
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/home/feed/get"
    }
    
    override func requestArgument() -> Any? {
                
        return ["sort" : sort, "order" : order]
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
}
