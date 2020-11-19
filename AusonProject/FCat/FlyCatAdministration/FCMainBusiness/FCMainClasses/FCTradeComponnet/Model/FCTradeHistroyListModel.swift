//
//  FCTradeHistroyListModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/24.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCTradeHistroyListModel: NSObject, HandyJSON, Codable {

    var symbol: String = ""
    var userId: String = ""
    var orderId: String = ""
    var side: String = ""
    var tradeType: String = ""
    var entrustVolume: String = ""
    var entrustPrice: String = ""
    var cumFilledVolume: String = ""
    var avgFilledPrice: String = ""
    var cumFilledAmount: String = ""
    var commission: String = ""
    var tradeRate: String = ""
    var orderStatus: String = ""
    var entrustTm: String = ""
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCTradeHistroyListModel{
        return FCTradeHistroyListModel.deserialize(from: jsonData) ?? FCTradeHistroyListModel()
    }
}
