//
//  FCPerpetualEntrustModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCPerpetualEntrustModel: NSObject, HandyJSON, Codable {
    
    var symbol: String?
    var userId: String?
    var orderId: String?
    var side: String?
    var action: String?
    var tradeType: String?
    var entrustVolume: String?
    var entrustPrice: String?
    var cumFilledVolume: String?
    var avgFilledPrice: String?
    var tradeRate: String?
    var profit: String?
    var commission: String?
    var margin: String?
    var leverage: String?
    var profitAmount: String?
    var commissionAmount: String?
    var marginAmount: String?
    var currency: String?
    var orderStatus: String?
    var entrustTm: String?
    var filledTime: String?
    var liquidatedTime: String?
    var liquidatedPrice: String?
    var bankruptcyPrice: String?
    var fairPrice: String?
    var stopLossPrice: String?
    var takeProfitPrice: String?
    var liquidatedMarginRate: String?
    var triggerType: String?
    var triggerSettingTime: String?
    var triggeredTime: String?
    var triggerSource: String?
    var triggerPrice: String?
    var symbolName: String?
    var contractAsset: String?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCPerpetualEntrustModel{
        return FCPerpetualEntrustModel.deserialize(from: jsonData) ?? FCPerpetualEntrustModel()
    }
}
