//
//  FCHomeModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCHomeModel: NSObject {

    var bannersArray:[FCHomeBannerModel]?
    var hotSymbolsArray:[FCHomeSymbolsModel]?
    var mainSymbolsArray:[FCHomeSymbolsModel]?
    var noticesArray:[FCHomenoticesModel]?
    
    init(dict: [String: AnyObject]){
        super.init()
        let jsonData = JSON(dict)
        
        bannersArray = [FCHomeBannerModel]()
        hotSymbolsArray = [FCHomeSymbolsModel]()
        mainSymbolsArray = [FCHomeSymbolsModel]()
        noticesArray = [FCHomenoticesModel]()
        
        for (_, subJSON) : (String, JSON) in jsonData["banners"] {
            let bannerModel = FCHomeBannerModel.init(dict: subJSON.dictionaryValue as [String : AnyObject])
            bannersArray?.append(bannerModel)
        }
        for (_, subJSON) : (String, JSON) in jsonData["hotSymbols"] {
            let symbolModel = FCHomeSymbolsModel.init(dict: subJSON.dictionaryValue as [String : AnyObject])
            hotSymbolsArray?.append(symbolModel)
        }
        for (_, subJSON) : (String, JSON) in jsonData["mainSymbols"] {
            let mainSymbolModel = FCHomeSymbolsModel.init(dict: subJSON.dictionaryValue as [String : AnyObject])
            mainSymbolsArray?.append(mainSymbolModel)
        }
        for (_, subJSON) : (String, JSON) in jsonData["notices"] {
            let noticeModel = FCHomenoticesModel.init(dict: subJSON.dictionaryValue as [String : AnyObject])
            noticesArray?.append(noticeModel)
        }
        
    }
}

class FCHomeBannerModel: NSObject {
    
    var bid: String?
    var linkUrl: String?
    var picUrl: String?
    var text: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        bid = json["bid"].stringValue
        linkUrl = json["linkUrl"].stringValue
        picUrl = json["picUrl"].stringValue
        text = json["text"].stringValue
    }
}

class FCHomeSymbolsModel: NSObject {
    
    var changePercent: String?
    var close: String?
    var fiatCurrency: String?
    var fiatPrice: String?
    var high: String?
    var isOptional: String?
    var latestPrice: String?
    var low: String?
    var marketType: String?
    var name: String?
    var open: String?
    var symbol: String?
    var tradingAmount: String?
    var priceTrend: String?
    var tradingType: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        changePercent = json["changePercent"].stringValue
        close = json["close"].stringValue
        fiatCurrency = json["fiatCurrency"].stringValue
        fiatPrice = json["fiatPrice"].stringValue
        high = json["high"].stringValue
        isOptional = json["isOptional"].stringValue
        latestPrice = json["latestPrice"].stringValue
        low = json["low"].stringValue
        marketType = json["marketType"].stringValue
        name = json["name"].stringValue
        open = json["open"].stringValue
        symbol = json["symbol"].stringValue
        tradingAmount = json["tradingAmount"].stringValue
        priceTrend = json["priceTrend"].stringValue
        tradingType = json["tradingType"].stringValue
    }
}

class FCHomenoticesModel: NSObject {
    var date: String?
    var linkUrl: String?
    var nid: String?
    var text: String?
    
    init(dict: [String: AnyObject]){
           super.init()
           let json = JSON(dict)
           text = json["text"].stringValue
           nid = json["nid"].stringValue
           linkUrl = json["linkUrl"].stringValue
           date = json["date"].stringValue
       }
}

class FCWalletOrderInfoModel: NSObject {
    
    var transactionId: String?
    var transactionHash: String?
    // 资产，有ETH，BTC，USDT等
    var digitalAsset: String?
    // 区块链网络，有BTC，ETH，ERC20，OMNI等
    var blockchainNetwork: String?
    // 区块链钱包地址
    var digitalAddress: String?
    var action: String?
    var volume: String?
    var obtainedVolume: String?
    var commission: String?
    // 链上已经确认的数目
    var confirmationNum: String?
    // 要求必须达到的链上确认的数目
    var requiredConfirmationNum: String?
    // 订单状态，已完成，审核中等，目前直接中文返回
    var state: String?
    var updateTm: String?
    var createTm: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        transactionId = json["transactionId"].stringValue
        transactionHash = json["transactionHash"].stringValue
        digitalAsset = json["digitalAsset"].stringValue
        blockchainNetwork = json["blockchainNetwork"].stringValue
        digitalAddress = json["digitalAddress"].stringValue
        action = json["action"].stringValue
        volume = json["volume"].stringValue
        obtainedVolume = json["obtainedVolume"].stringValue
        commission = json["commission"].stringValue
        confirmationNum = json["confirmationNum"].stringValue
        requiredConfirmationNum = json["requiredConfirmationNum"].stringValue
        state = json["state"].stringValue
        updateTm = json["updateTm"].stringValue
        createTm = json["createTm"].stringValue
       }
}


