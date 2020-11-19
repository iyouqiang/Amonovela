//
//  FCKLineRestingModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCKLineDepthModel: NSObject, HandyJSON, Codable {

    var id: String = ""
    var volume: String = ""
    var accumulateVolume = ""
    var price = ""
    var barPercent = 0.0
    
    required public override init() {
        
    }
}

class FCLatestTradeModel: NSObject, HandyJSON, Codable {

    var change = ""
    var changePercentage = ""
    var estimatedCurrency = ""
    var estimatedValue = ""
    var id = ""
    var indexPrice = ""
    var makerSide = ""
    var price = ""
    var priceSide = ""
    var rawTs = ""
    var time = ""
    var volume = ""
    
    required public override init() {
        
    }
}

class FCPrecisionsModel: NSObject, HandyJSON, Codable {
    
    var precision = ""
    var id = ""
    
    required public override init() {
        
    }
}

class FCContractTradesModel: NSObject, HandyJSON, Codable {
    
   var id = ""
   var makerSide = ""
   var price = ""
   var priceSide = ""
   var rawTs = ""
   var time = ""
   var volume = ""
    
    required public override init() {
        
    }
}

class FCKLineRestingModel: NSObject, HandyJSON, Codable {

    required public override init() {
        
    }
    //卖
    var asks: [FCKLineDepthModel]?
    //买
    var bids: [FCKLineDepthModel]?
    
    /// 下列为合约下单model
    var defaultLevelStep: String?
    var defaultPrecision: String?
    var fundingRate: String?
    var leftSeconds: String?

    var latestTrade: FCLatestTradeModel?
    var trades: [FCContractTradesModel]?
    var precisions: [FCPrecisionsModel]?
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCKLineRestingModel{
        return FCKLineRestingModel.deserialize(from: jsonData) ?? FCKLineRestingModel()
    }
}
