//
//  FCPositionInfoModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/29.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCPositionInfoModel: NSObject {
    
    var symbol: String?
    var currency: String?
    var volume: String?
    var availableVolume: String?
    var positionSide: String?
    /// 保证金模式，Cross表示全仓，Isolated表示逐仓
    var marginMode: String?
    var avgPrice: String?
    var liquidatedPrice: String?
    var margin: String?
    var availableMargin: String?
    var unrealisedPNL: String?
    var realisedPNL: String?
    var leverage: String?
    var positionId: String?
    var updateTm: String?
    var priceDigitalNum: String?
    var contractSize: String?
    var commissionRate: String?
    var pnlRate: String?
    var adlRiskLevel: String?
    var latestPrice: String?
    var marginRatio: String?
    var marketTakeLevel: String?
    var symbolName: String?
    var contractAsset: String?
    var fairPrice: String?
    var pnlShare: FCPnlShareModel?
    
    init(dict: [String: AnyObject]){
        super.init()
        
        let json = JSON(dict)
    
        adlRiskLevel = json["adlRiskLevel"].stringValue
        availableMargin = json["availableMargin"].stringValue
        availableVolume = json["availableVolume"].stringValue
        avgPrice = json["avgPrice"].stringValue
        commissionRate = json["commissionRate"].stringValue
        contractSize = json["contractSize"].stringValue
        currency = json["currency"].stringValue
        latestPrice = json["latestPrice"].stringValue
        leverage = json["leverage"].stringValue
        liquidatedPrice = json["liquidatedPrice"].stringValue
        margin = json["margin"].stringValue
        marginMode = json["marginMode"].stringValue
        marginRatio = json["marginRatio"].stringValue
        marketTakeLevel = json["marketTakeLevel"].stringValue
        pnlRate = json["pnlRate"].stringValue
        positionId = json["positionId"].stringValue
        positionSide = json["positionSide"].stringValue
        priceDigitalNum = json["priceDigitalNum"].stringValue
        realisedPNL = json["realisedPNL"].stringValue
        symbol = json["symbol"].stringValue
        unrealisedPNL = json["unrealisedPNL"].stringValue
        updateTm = json["updateTm"].stringValue
        volume = json["volume"].stringValue
        symbolName = json["symbolName"].stringValue
        contractAsset = json["contractAsset"].stringValue
        fairPrice = json["fairPrice"].stringValue
        
        pnlShare = FCPnlShareModel(dict: json["pnlShare"].dictionaryValue as [String : AnyObject])
    }
}

class FCPnlShareModel: NSObject {
    
    var closePrice: String?
    var openPrice: String?
    var descriptionStr: String?
    var leverage: String?
    var makeSide: String?
    var pnlRate: String?
    var qrcodeUrl: String?
    var symbolName: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        
        closePrice = json["closePrice"].stringValue
        openPrice = json["openPrice"].stringValue
        descriptionStr = json["description"].stringValue
        leverage = json["leverage"].stringValue
        makeSide = json["makeSide"].stringValue
        pnlRate = json["pnlRate"].stringValue
        qrcodeUrl = json["qrcodeUrl"].stringValue
        symbolName = json["symbolName"].stringValue
    }
}

class FCPositionAccountInfoModel: NSObject {
    /**
     account =         {
         availableMargin = "64943.0063";
         balance = "65012.7145";
         currency = USDT;
         equity = "65043.7794";
         freezedMargin = "0.0000";
         holdMarginRatio = "0.50";
         longLeverage = 10;
         marginRatio = "937.81";
         realisedPNL = "75.6873";
         shortLeverage = 10;
         unrealisedPNL = "31.0649";
         usedMargin = "100.7731";
         userId = 3;
     };
     symbolAccount =         {
         availableLongVolume = 4681789;
         availableShortVolume = 2553703;
         currency = USDT;
         symbol = "BTC-USDT";
         userId = 3;
     };
     */
    
    var symbolAccount: FCPositionSymbolAccountModel?
    var account: FCPositionSingleAccountModel?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        
        symbolAccount = FCPositionSymbolAccountModel(dict: json["symbolAccount"].dictionaryValue as [String : AnyObject])
        account = FCPositionSingleAccountModel(dict: json["account"].dictionaryValue as [String : AnyObject])
    }
}

class FCPositionSymbolAccountModel: NSObject {
    
    var availableLongVolume: String?
    var availableShortVolume: String?
    var currency: String?
    var symbol: String?
    var userId: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        
        availableLongVolume = json["availableLongVolume"].stringValue
        availableShortVolume = json["availableShortVolume"].stringValue
        currency = json["currency"].stringValue
        symbol = json["symbol"].stringValue
        userId = json["userId"].stringValue
    }
}

class FCPositionSingleAccountModel: NSObject {
    
    var availableMargin: String?
    var balance: String?
    var currency: String?
    var equity: String?
    var freezedMargin: String?
    var holdMarginRatio: String?
    var longLeverage: String?
    var marginRatio: String?
    var realisedPNL: String?
    var shortLeverage: String?
    var unrealisedPNL: String?
    var usedMargin: String?
    var userId: String?
    var pendingOrderNum: String?
    var positionNum: String?
    var contractAsset: String?
    var contractSize: String?
    var triggerCloseOrderNum: String?
    var triggerOpenOrderNum: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        
        availableMargin = json["availableMargin"].stringValue
        balance = json["balance"].stringValue
        currency = json["currency"].stringValue
        equity = json["equity"].stringValue
        pendingOrderNum = json["pendingOrderNum"].string
        positionNum = json["positionNum"].string
        freezedMargin = json["freezedMargin"].stringValue
        holdMarginRatio = json["holdMarginRatio"].stringValue
        longLeverage = json["longLeverage"].stringValue
        marginRatio = json["marginRatio"].stringValue
        realisedPNL = json["realisedPNL"].stringValue
        shortLeverage = json["shortLeverage"].stringValue
        unrealisedPNL = json["unrealisedPNL"].stringValue
        usedMargin = json["usedMargin"].stringValue
        userId = json["userId"].stringValue
        contractAsset = json["contractAsset"].stringValue
        contractSize = json["contractSize"].stringValue
        triggerCloseOrderNum = json["triggerCloseOrderNum"].stringValue
        triggerOpenOrderNum = json["triggerOpenOrderNum"].stringValue
    }
}

