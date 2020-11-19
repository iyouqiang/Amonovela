//
//  FCContractHistoryModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/6.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractHistoryModel: NSObject {

    /**
    action = Close;
    avgFilledPrice = "425.45";
    bankruptcyPrice = "0.0";
    commission = "-0.4255 USDT";
    commissionAmount = "-0.4255";
    cumFilledVolume = 100;
    currency = USDT;
    entrustPrice = "0.00";
    entrustTime = "2020-09-03T18:48:38+0800";
    entrustTm = "2020-09-03 18:48:38";
    entrustVolume = 100;
    fairPrice = "0.0";
    filledTime = "2020-09-03T18:48:38+0800";
    leverage = 50X;
    liquidatedMarginRate = "";
    liquidatedPrice = "0.0";
    liquidatedTime = "1970-01-01T08:00:00+0800";
    margin = "0.0000 USDT";
    marginAmount = "0.0000";
    orderId = 207766243;
    orderStatus = Filled;
    profit = "-42.0100 USDT";
    profitAmount = "-42.0100";
    side = Ask;
    stopLossPrice = "";
    symbol = "ETH-USDT";
    takeProfitPrice = "";
    tradeRate = "100.00";
    tradeType = Market;
    triggerPrice = "0.00";
    triggerSettingTime = "2020-09-03T18:48:38+0800";
    triggerSource = FairPrice;
    triggerType = LimitOrder;
    triggeredTime = "2020-09-03T18:48:38+0800";
    userId = 3;
 */
   var action: String?
   var avgFilledPrice: String?
   var bankruptcyPrice: String?
   var commission: String?
   var commissionAmount: String?
   var cumFilledVolume: String?
   var currency: String?
   var entrustPrice: String?
   var entrustTime: String?
   var entrustTm: String?
   var entrustVolume: String?
   var fairPrice: String?
   var filledTime: String?
   var leverage: String?
   var liquidatedMarginRate: String?
    
   var liquidatedPrice: String?
   var liquidatedTime: String?
   var margin: String?
   var marginAmount: String?
   var orderId: String?
   var orderStatus: String?
   var profit: String?
   var profitAmount: String?
   var side: String?
   var stopLossPrice: String?
   var symbol: String?
   var takeProfitPrice: String?
   var tradeRate: String?
   var tradeType: String?
   var triggerPrice: String?
   var triggerSettingTime: String?
   var triggerSource: String?
   var triggerType: String?
   var triggeredTime: String?
   var userId: String?
    var symbolName: String?
    var pnlShare: FCPnlShareModel?
    var pnlRate: String?
    var contractAsset: String?
    
    init(dict: [String: AnyObject]){
           super.init()
        
        let jsonData = JSON(dict)
        action = jsonData["action"].stringValue
        avgFilledPrice = jsonData["avgFilledPrice"].stringValue
        bankruptcyPrice = jsonData["bankruptcyPrice"].stringValue
        commission = jsonData["commission"].stringValue
        commissionAmount = jsonData["commissionAmount"].stringValue
        cumFilledVolume = jsonData["cumFilledVolume"].stringValue
        currency = jsonData["currency"].stringValue
        entrustPrice = jsonData["entrustPrice"].stringValue
        entrustTime = jsonData["entrustTime"].stringValue
        entrustTm = jsonData["entrustTm"].stringValue
        leverage = jsonData["leverage"].stringValue
        entrustVolume = jsonData["entrustVolume"].stringValue
        fairPrice = jsonData["fairPrice"].stringValue
        filledTime = jsonData["filledTime"].stringValue
        liquidatedMarginRate = jsonData["liquidatedMarginRate"].stringValue
        liquidatedPrice = jsonData["liquidatedPrice"].stringValue
        liquidatedTime = jsonData["liquidatedTime"].stringValue
        orderId = jsonData["orderId"].stringValue
        marginAmount = jsonData["marginAmount"].stringValue
        orderStatus = jsonData["orderStatus"].stringValue
        profit = jsonData["profit"].stringValue
        profitAmount = jsonData["profitAmount"].stringValue
        side = jsonData["side"].stringValue
        stopLossPrice = jsonData["stopLossPrice"].stringValue
        symbol = jsonData["symbol"].stringValue
        takeProfitPrice = jsonData["takeProfitPrice"].stringValue
        tradeRate = jsonData["tradeRate"].stringValue
        tradeType = jsonData["tradeType"].stringValue
        triggerPrice = jsonData["triggerPrice"].stringValue
        triggerSettingTime = jsonData["triggerSettingTime"].stringValue
        triggerSource = jsonData["triggerSource"].stringValue
        triggerType = jsonData["triggerType"].stringValue
        triggeredTime = jsonData["triggeredTime"].stringValue
        userId = jsonData["userId"].stringValue
        symbolName = jsonData["symbolName"].stringValue
        pnlRate = jsonData["pnlRate"].stringValue
        contractAsset = jsonData["contractAsset"].stringValue
        pnlShare = FCPnlShareModel(dict: jsonData["pnlShare"].dictionaryValue as [String : AnyObject])    }
}

class FCHistoryDelModel: NSObject {
    
    /**
     amount = "60.7932";
     commission = "-0.0607";
     currency = USDT;
     filledTm = "2020-09-05T14:56:15+0800";
     price = "10481.58";
     volume = 58;
     */
    
    var amount: String?
    var commission: String?
    var currency: String?
    var filledTm: String?
    var price: String?
    var volume: String?
    
    init(dict: [String: AnyObject]){
           super.init()
        
        let jsonData = JSON(dict)
        amount = jsonData["amount"].stringValue
        commission = jsonData["commission"].stringValue
        currency = jsonData["currency"].stringValue
        commission = jsonData["commission"].stringValue
        filledTm = jsonData["filledTm"].stringValue
        price = jsonData["price"].stringValue
        currency = jsonData["currency"].stringValue
        volume = jsonData["volume"].stringValue
    }
}
