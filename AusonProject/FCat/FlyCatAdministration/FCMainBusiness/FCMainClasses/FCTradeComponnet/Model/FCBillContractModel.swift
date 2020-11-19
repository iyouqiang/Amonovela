//
//  FCBillContractModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/1.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCBillContractModel: NSObject {

    var action:String?
    var commission:String?
    var contractAsset:String?
    var contractVolume:String?
    var serialNo:String?
    var symbol:String?
    var transactionId:String?
    var updateTime:String?
    var userId:String?
    var volume:String?
    var updateTm: String?
    
    
    init(dict: [String: AnyObject]){
           super.init()
        
        let jsonData = JSON(dict)
        action = jsonData["action"].stringValue
        commission = jsonData["commission"].stringValue
        contractAsset = jsonData["contractAsset"].stringValue
        contractVolume = jsonData["contractVolume"].stringValue
        serialNo = jsonData["serialNo"].stringValue
        symbol = jsonData["symbol"].stringValue
        transactionId = jsonData["transactionId"].stringValue
        updateTime = jsonData["updateTime"].stringValue
        userId = jsonData["userId"].stringValue
        volume = jsonData["volume"].stringValue
        updateTm = jsonData["updateTm"].stringValue
    }
}
