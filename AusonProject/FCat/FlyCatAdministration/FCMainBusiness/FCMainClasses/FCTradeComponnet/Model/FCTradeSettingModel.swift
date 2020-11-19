//
//  FCTradeSettingModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/30.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

public enum TradeTradingUnitType: Int {
    
   case TradeTradingUnitType_CONT
   case TradeTradingUnitType_COIN
}

public enum MarginModeType: Int {
    case marginMode_Cross
    case marginMode_Isolated
}

public enum LeverageType: Int {
    
    case LeverageType_long
    case LeverageType_short
}

public enum TradingAccountType: Int {
    
   case tradingAccountType_spot
   case tradingAccountType_swap
}

class FCTradeSettingModel: NSObject, HandyJSON {
    
    required override init() {
        super.init()
    }
    
    /// 交易单位 本地附加
    var tradeTradingUnit: String?
    /// 服务器返回
    var longLeverage: String?
    var shortLeverage: String?
    var accountMode: String?
    var maxLongLeverage: String?
    var maxShortLeverage: String?
    var symbol: String?
    var userId: String?
    
    init(dict: [String: AnyObject]){
           super.init()
        
        let jsonData = JSON(dict)
        //let jsonData = data["strategy"].dictionaryValue
        tradeTradingUnit = jsonData["tradingUnit"].stringValue
        accountMode = jsonData["accountMode"].stringValue
        longLeverage = jsonData["longLeverage"].stringValue
        shortLeverage = jsonData["shortLeverage"].stringValue
        maxLongLeverage = jsonData["maxLongLeverage"].stringValue
        maxShortLeverage = jsonData["maxShortLeverage"].stringValue
        symbol = jsonData["symbol"].stringValue
        userId = jsonData["userId"].stringValue
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCTradeSettingModel {
        return FCTradeSettingModel.deserialize(from: jsonData) ?? FCTradeSettingModel()
    }
}
