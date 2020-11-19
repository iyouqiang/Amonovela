//
//  FCApi_homedata.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_homedata: YTKRequest {

    override init() {
        super.init()
       
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
    
    override func requestUrl() -> String {
        return "/api/v1/app/home/data/get"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
}
