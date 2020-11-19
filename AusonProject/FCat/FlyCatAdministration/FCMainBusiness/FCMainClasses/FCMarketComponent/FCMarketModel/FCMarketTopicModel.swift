//
//  FCMarketTopicModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/29.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCMarketTopicModel: NSObject {
    
    /**
     
     {
     "topic":"eth_applies",
     "data":{
     "usdt_price":"230.6712000000",
     }
     }
     */
    
    @objc public var topic: String?
    @objc public var usdt_price = "0.00"
    
    init(responseObject: Any) {
        super.init()
        
        let marketData = JSON(responseObject)
        
        topic = marketData["topic"].stringValue
        
        let tempDic = marketData["data"].dictionary
        
        if let str = tempDic?["usdt_price"]?.string {
            
            usdt_price = str
        }else {
        
            usdt_price = "0.00"
        }
    }
}
