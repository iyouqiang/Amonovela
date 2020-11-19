//
//  FCContractsModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCContractsModel: NSObject, HandyJSON, Codable {

    /**
     ContractID       string `json:"contractId"`       // 合约ID
     Symbol           string `json:"symbol"`           // 合约符号，比如BTC-USDT，ETH-USDT
     Name             string `json:"name"`             // 合约名字，比如BTC永续，ETH永续，主要用于显示
     TradePrice       string `json:"tradePrice"`       // 最新成交价格
     TradeSide        string `json:"tradeSide"`        // 最新成交吃单方向，Ask: 卖方吃单; Bid: 买方吃单
     TradeDirection   string `json:"tradeDirection"`   // 最新成交上涨下跌，Up: 上涨; Down: 下跌
     FairPrice        string `json:"fairPrice"`        // 标记价格
     FairDirection    string `json:"fairDirection"`    // 标记价格上涨下跌，Up: 上涨; Down: 下跌
     IndexPrice       string `json:"indexPrice"`       // 现货指数价格
     IndexDirection   string `json:"indexDirection"`   // 现货价格上涨下跌，Up: 上涨; Down: 下跌
     FundingRate      string `json:"fundingRate"`      // 当前资金费率
     LeftSeconds      string `json:"leftSeconds"`      // 当期资金费用清算到下一期还剩余多少秒
     Size             string `json:"size"`             // 合约大小，比如BTC合约的大小为0.0001，则一张合约表示0.0001BTC
     Currency         string `json:"currency"`         // 结算资产，目前统一都是USDT
     Asset            string `json:"asset"`            // 合约资产，比如BTC，ETH等
     High             string `json:"high"`             // 从零点开始到现在的最高价
     Low              string `json:"low"`              // 从零点开始到现在的最低价
     Open             string `json:"open"`             // 从零点的开盘价
     Volume           string `json:"volume"`           // 从零点开始到现在的累计交易量
     Change           string `json:"change"`           // 相对于零点的涨跌幅
     ChangePercentage string `json:"changePercentage"` // 相对于零点的涨跌幅百分比
     // 交易单位: CONT（张），COIN (BTC,ETH,EOS等)
     TradingUnit string `json:"tradingUnit"`
     // 市价单吃单层数
     MarketTakeLevel string `json:"marketTakeLevel"`
     // 默认的深度合并小数点位数，0.01
     DefaultPrecision string `json:"defaultPrecision"`
     */

    var asset: String?
    var change: String?
    var changePercentage: String?
    var contractId: String?
    var currency: String?
    var defaultPrecision: String?
    var fairDirection: String?
    var fairPrice: String?
    var fundingRate: String?
    var high: String?
    var indexDirection: String?
    var indexPrice: String?
    var leftSeconds: String?
    var low: String?
    var marketTakeLevel: String?
    var name: String?
    var open: String?
    var size: String?
    var symbol: String?
    var tradeDirection: String?
    var tradePrice: String?
    var tradeSide: String?
    var tradingUnit: String?
    var volume: String?
    var tradingType:String?
    var isOptional: Bool = false
    
    init(dict: [String: AnyObject]){
              super.init()
           
        let jsonData = JSON(dict)
        asset = jsonData["asset"].stringValue
        change = jsonData["change"].stringValue
        changePercentage = jsonData["changePercentage"].stringValue
        contractId = jsonData["contractId"].stringValue
        currency = jsonData["currency"].stringValue
        defaultPrecision = jsonData["defaultPrecision"].stringValue
        fairDirection = jsonData["fairDirection"].stringValue
        fairPrice = jsonData["fairPrice"].stringValue
        fundingRate = jsonData["fundingRate"].stringValue
        high = jsonData["high"].stringValue
        indexDirection = jsonData["indexDirection"].stringValue
        indexPrice = jsonData["indexPrice"].stringValue
        leftSeconds = jsonData["leftSeconds"].stringValue
        low = jsonData["low"].stringValue
        marketTakeLevel = jsonData["marketTakeLevel"].stringValue
        name = jsonData["name"].stringValue
        open = jsonData["open"].stringValue
        size = jsonData["size"].stringValue
        symbol = jsonData["symbol"].stringValue
        tradeDirection = jsonData["tradeDirection"].stringValue
        tradePrice = jsonData["tradePrice"].stringValue
        tradeSide = jsonData["tradeSide"].stringValue
        tradingUnit = jsonData["tradingUnit"].stringValue
        volume = jsonData["volume"].stringValue
        tradingType = jsonData["tradingType"].stringValue
        isOptional = jsonData["isOptional"].boolValue
       }
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCContractsModel{
        return FCContractsModel.deserialize(from: jsonData) ?? FCContractsModel()
    }
}
