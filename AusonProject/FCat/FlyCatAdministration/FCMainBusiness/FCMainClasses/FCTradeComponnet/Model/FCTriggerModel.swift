//
//  FCTriggerModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCTriggerModel: NSObject, HandyJSON, Codable {

    /**
     action = Open;
     avgFilledPrice = "0.00";
     cumFilledVolume = 0;
     entrustPrice = "11339.15";
     entrustTime = "2020-10-15T00:10:50.578+0800";
     entrustVolume = 1;
     leverage = 50X;
     margin = "0.0227 USDT";
     orderId = 16;
     orderStatus = New;
     positionAvailableVolume = 0;
     positionAvgPrice = "0.00";
     positionId = 0;
     positionSide = "";
     side = Ask;
     stopLossPrice = "";
     symbol = "BTC-USDT";
     takeProfitPrice = "";
     tradeType = Limit;
     triggerPrice = "";
     triggerSource = "";
     triggerStatus = Waiting;
     triggerTime = "2020-10-15T00:10:50.578+0800";
     triggerType = "";
     userId = 46;
     contractAsset
     */
    
    var action: String?
    var avgFilledPrice: String?
    var cumFilledVolume: String?
    var entrustPrice: String?
    var entrustTime: String?
    var entrustVolume: String?
    var leverage: String?
    var margin: String?
    var orderId: String?
    var orderStatus: String?
    var positionAvailableVolume: String?
    var positionAvgPrice: String?
    var positionId: String?
    var positionSide: String?
    var side: String?
    var stopLossPrice: String?
    var symbol: String?
    var takeProfitPrice: String?
    var tradeType: String?
    var triggerPrice: String?
    var triggerSource: String?
    var triggerStatus: String?
    var triggerTime: String?
    var triggerType: String?
    var userId: String?
    var symbolName: String?
    var contractAsset: String?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCTriggerModel{
        return FCTriggerModel.deserialize(from: jsonData) ?? FCTriggerModel()
    }
}
