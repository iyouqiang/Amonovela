//
//  FCCXPAssetModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/12.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

/**
 
 {
     data =     {
         assets =         (
                         {
                 asset = BCH;
                 chains =                 (
                                         {
                         chainNetwork = BCH;
                         depositCommission = "0.001";
                         minConfirmation = 1;
                         minor = "0.001";
                         symbol = BCH;
                         withdrawalCommission = "0.001";
                     }
                 );
                 name = "\U6bd4\U7279\U5e01\U73b0\U91d1";
             },
                         {
                 asset = BTC;
                 chains =                 (
                                         {
                         chainNetwork = BTC;
                         depositCommission = "0.0001";
                         minConfirmation = 1;
                         minor = "0.0001";
                         symbol = BTC;
                         withdrawalCommission = "0.0001";
                     }
                 );
                 name = "\U6bd4\U7279\U5e01";
             },
                         {
                 asset = LTC;
                 chains =                 (
                                         {
                         chainNetwork = LTC;
                         depositCommission = "0.0001";
                         minConfirmation = 3;
                         minor = "0.001";
                         symbol = LTC;
                         withdrawalCommission = "0.0001";
                     }
                 );
                 name = "\U83b1\U7279\U5e01";
             },
                         {
                 asset = USDT;
                 chains =                 (
                                         {
                         chainNetwork = OMNI;
                         depositCommission = "0.0001";
                         minConfirmation = 1;
                         minor = "0.001";
                         symbol = "USDT_OMNI";
                         withdrawalCommission = "0.0001";
                     },
                                         {
                         chainNetwork = ERC20;
                         depositCommission = "0.0001";
                         minConfirmation = 10;
                         minor = "0.001";
                         symbol = "USDT_ERC20";
                         withdrawalCommission = "0.0001";
                     }
                 );
                 name = "\U6cf0\U8fbe\U5e01";
             },
                         {
                 asset = ETH;
                 chains =                 (
                                         {
                         chainNetwork = ETH;
                         depositCommission = "0.001";
                         minConfirmation = 10;
                         minor = "0.01";
                         symbol = ETH;
                         withdrawalCommission = "0.001";
                     }
                 );
                 name = "\U4ee5\U592a\U574a";
             }
         );
     };
     err =     {
         code = 0;
         msg = Success;
         "msg_debug" = "";
     };
 }
 
 */

/**
 
 {
     defaultAsset = USDT;
     supportAssets =         (
                     {
             asset = USDT;
             balance = "0.0";
             name = "\U6cf0\U8fbe\U5e01";
         }
     );
 };
 
 */

class FCSupportSubAsset:  NSObject, HandyJSON, Codable  {
    
    var asset: String?
    var balance: String?
    var name: String?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCSupportSubAsset{
        return FCSupportSubAsset.deserialize(from: jsonData) ?? FCSupportSubAsset()
    }
}

class FCSupportAssetsModel:  NSObject, HandyJSON, Codable  {
    
    var defaultAsset: String?
    var supportAssets:[FCSupportSubAsset]?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCSupportAssetsModel{
        return FCSupportAssetsModel.deserialize(from: jsonData) ?? FCSupportAssetsModel()
    }
}

class FCTransferConfigSubModel: NSObject, HandyJSON, Codable {
    
    var isOptional:Bool?
    var name:String?
    var type:String?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCTransferConfigSubModel{
        return FCTransferConfigSubModel.deserialize(from: jsonData) ?? FCTransferConfigSubModel()
    }
}


class FCTransferConfigModel: NSObject, HandyJSON, Codable {
    
    var accounts: [FCTransferConfigSubModel]?
    var opponentAccounts: [FCTransferConfigSubModel]?

    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCTransferConfigModel{
        return FCTransferConfigModel.deserialize(from: jsonData) ?? FCTransferConfigModel()
    }
}

class FCChainsModel: NSObject, HandyJSON, Codable {
    
    var chainNetwork: String?
    var depositCommission: String?
    var minConfirmation: String?
    var minor: String?
    var symbol: String?
    var withdrawalCommission: String?
    var withdrawalMinor:String?
    var depositMinor: String?

    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCChainsModel{
        return FCChainsModel.deserialize(from: jsonData) ?? FCChainsModel()
    }
}

class FCAllAssetsConfigModel: NSObject, HandyJSON, Codable {
    
    var asset: String?
    var chains:[FCChainsModel]?
    var name: String?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCAllAssetsConfigModel{
        return FCAllAssetsConfigModel.deserialize(from: jsonData) ?? FCAllAssetsConfigModel()
    }
}

class FCWalletAllConfig: NSObject, HandyJSON, Codable {
    
    var assets:[FCAllAssetsConfigModel]?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCWalletAllConfig{
        return FCWalletAllConfig.deserialize(from: jsonData) ?? FCWalletAllConfig()
    }
}

/**
 responseObject: {
 data =     {
     accounts =         (
                     {
             accountType = Spot;
             digitAsset = USDT;
             digitEquity = "0.0";
             fiatAsset = CNY;
             fiatEquity = "0.0";
             marginAccount =                 {
                 availableMargin = "";
                 balance = "";
                 equity = "";
                 marginAsset = "";
                 marginRatio = "";
                 unrealisedPNL = "";
                 usedMargin = "";
             };
         },
                     {
             accountType = Swap;
             digitAsset = USDT;
             digitEquity = "2971.6895";
             fiatAsset = CNY;
             fiatEquity = "0.0";
             marginAccount =                 {
                 availableMargin = "2971.6895";
                 balance = "2971.6895";
                 equity = "2971.6895";
                 marginAsset = USDT;
                 marginRatio = "99.99";
                 unrealisedPNL = "0.0000";
                 usedMargin = "0.0";
             };
         },
                     {
             accountType = Otc;
             digitAsset = USDT;
             digitEquity = "0.000000";
             fiatAsset = CNY;
             fiatEquity = "0.0";
             marginAccount =                 {
                 availableMargin = "";
                 balance = "";
                 equity = "";
                 marginAsset = "";
                 marginRatio = "";
                 unrealisedPNL = "";
                 usedMargin = "";
             };
         }
     );
 };
 err =     {
     code = 0;
     msg = Success;
     msgDebug = "";
 };
 */

class FCCXPAssetMarginModel: NSObject {
    
    var availableMargin: String?
    var balance: String?
    var equity:String?
    var marginAsset:String?
    var marginRatio:String?
    var unrealisedPNL:String?
    var usedMargin:String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        availableMargin = json["availableMargin"].stringValue
        balance = json["balance"].stringValue
        equity = json["equity"].stringValue
        marginAsset = json["marginAsset"].stringValue
        marginRatio = json["marginRatio"].stringValue
        unrealisedPNL = json["unrealisedPNL"].stringValue
        usedMargin = json["usedMargin"].stringValue
    }
}

class FCCXPAssetModel: NSObject {

    var accountType:String?
    var digitAsset:String?
    var digitEquity:String?
    var fiatAsset:String?
    var fiatEquity:String?
    var marginAccount:FCCXPAssetMarginModel?
    
    init(dict: [String: AnyObject]){
           super.init()
           let jsonData = JSON(dict)
        
        accountType = jsonData["accountType"].stringValue
        digitAsset = jsonData["digitAsset"].stringValue
        digitEquity = jsonData["digitEquity"].stringValue
        fiatAsset = jsonData["fiatAsset"].stringValue
        fiatEquity = jsonData["fiatEquity"].stringValue
        
        marginAccount = FCCXPAssetMarginModel.init(dict: jsonData["marginAccount"].dictionaryValue as [String : AnyObject])
    }
}

class FCCXPAssetDepositModel: NSObject {

    var blockchainNetwork: String?
    var digitalAddress: String?
    var digitalAsset: String?
    var digitalSymbol: String?
    var requiredConfirmationNum: String?
    var depositMinor: String?
    
    init(dict: [String: AnyObject]){
           super.init()
           let jsonData = JSON(dict)
        
        blockchainNetwork = jsonData["blockchainNetwork"].stringValue
        digitalAddress = jsonData["digitalAddress"].stringValue
        digitalAsset = jsonData["digitalAsset"].stringValue
        digitalSymbol = jsonData["digitalSymbol"].stringValue
        requiredConfirmationNum = jsonData["requiredConfirmationNum"].stringValue
        depositMinor = jsonData["depositMinor"].stringValue
    }
}

class FCCXPAssetConfigModel: NSObject {

    /// 手续费
    var commission: String?
    /// 最小交易数量
    var minConfirmation: String?
    /// 最小交易金额
    var minor: String?
    var symbol: String?
    var balance: String?
    
    init(dict: [String: AnyObject]){
           super.init()
           let jsonData = JSON(dict)
        
        commission = jsonData["commission"].stringValue
        minConfirmation = jsonData["minConfirmation"].stringValue
        minor = jsonData["minor"].stringValue
        symbol = jsonData["symbol"].stringValue
        balance = jsonData["balance"].stringValue
    }
}
