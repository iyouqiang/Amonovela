//
//  FCMarketModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/18.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCMarketModel: NSObject, HandyJSON, Codable {
    required public override init() {
        
    }
    
    
    //    @objc public var name: String?
    //    @objc public var rank: String?
    ////    @objc public var symbol: String?
    //    @objc public var total_supply: String?
    //    @objc public var favStr: String?
    //    @objc public var rmb_price_24hour_ago: String?
    //    @objc public var usdt_price_24hour_ago: String?
    //    @objc public var rmb_price: String?
    //    @objc public var usdt_price = "0.00"
    //    @objc public var total_market_cap_rmb: String?
    //    var priceAccuracy: Int = 4
    //    public var fav: Bool?
    //    public var topicModel: FCMarketTopicModel?
    //
    //    public var changeRate = 0.00
    
    
    
    //    "symbol": "ETH-USDT",
    //        "marketType": "Spot",
    //        "isOptional": false,
    //        "latestPrice": "0.0",
    //        "estimatedValue": "0.0",
    //        "priceTrend": "Stable",
    //        "open": "",
    //        "close": "",
    //        "high": "0.0",
    //        "low": "0.0",
    //        "volume": "0.0",
    //        "amount": "",
    //        "change": "0.0",
    //        "changePercent": "0.0"
    
    //CXP
    @objc public var symbol: String?
    var marketType: String = ""
    var isOptional: Bool = false
    var latestPrice: String = "0"
    var estimatedValue: String = ""
    var estimatedCurrency: String = ""
    var priceTrend: String = ""
    var open: String = ""
    var close: String = ""
    var high: String = ""
    var low: String = ""
    var volume: String = ""
    var amount: String = ""
    var change: String = ""
    var changePercent: String = ""
    var tradingType: String = ""
    var name: String = ""
    /// 传值用，未赋值不要获取
    var asset: String = ""
    var size: String = ""
    
//    init(dict: [String: AnyObject]) {
//        super.init()
//        
//        let marketData = JSON(dict)
//        
//        name = marketData["name"].stringValue
//        rank = marketData["rank"].stringValue
//        symbol = marketData["symbol"].stringValue
//        total_supply = marketData["total_supply"].stringValue
//        fav = marketData["fav"].boolValue
//        favStr = marketData["fav"].stringValue
//        changeRate = marketData["24hour_rate"].doubleValue
//        rmb_price = marketData["rmb_price"].stringValue
//        usdt_price = marketData["usdt_price"].stringValue
//        total_market_cap_rmb  = marketData["total_market_cap_rmb"].stringValue
//        usdt_price_24hour_ago = marketData["usdt_price_24hour_ago"].string
//        rmb_price_24hour_ago  = marketData["rmb_price_24hour_ago"].stringValue
//        
//    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCMarketModel{
        return FCMarketModel.deserialize(from: jsonData) ?? FCMarketModel()
    }
    
}
