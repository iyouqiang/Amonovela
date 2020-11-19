//
//  _set.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/31.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_trading_strategy_set: YTKRequest {

     var symbol = ""
    // 保证金模式，Isolated:逐仓 Cross:全仓
    var accountMode = ""
    var longLeverage:String = ""
    var shortLeverage:String = ""
    var maxLongLeverage:String = ""
    var maxShortLeverage:String = ""
    var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
    
    init(symbol:String = FCTradeSettingconfig.sharedInstance.symbol ?? "",
         accountModeType: MarginModeType = FCTradeSettingconfig.sharedInstance.marginMode ?? .marginMode_Cross,
         longLeverage: String = FCTradeSettingconfig.sharedInstance.longLeverage ?? "0",
         shortLeverage: String = FCTradeSettingconfig.sharedInstance.shortLeverage ?? "0",
         maxLongLeverage: String = FCTradeSettingconfig.sharedInstance.tradeSettingInfoModel?.maxLongLeverage ?? "100",
         maxShortLeverage: String = FCTradeSettingconfig.sharedInstance.tradeSettingInfoModel?.maxShortLeverage ?? "100") {
        super.init()
        
        self.symbol = symbol
        if accountModeType == .marginMode_Cross {
            self.accountMode = "Cross"
        }else {
            self.accountMode = "Isolated"
        }
            
        self.longLeverage = longLeverage
        self.shortLeverage = shortLeverage
        self.maxLongLeverage = maxLongLeverage
        self.maxShortLeverage = maxShortLeverage
    }
    
    override func baseUrl() -> String {
        return HOSTURL_SWAP
    }
    
    override func requestUrl() -> String {
        return "/api/v1/cts/trading/strategy/set"
    }
    
    override func requestMethod() -> YTKRequestMethod {
        return .POST
    }
    
    override func requestArgument() -> Any? {
        
        let strategy = ["userId" : userId,
                        "symbol":symbol,
                        "accountMode":accountMode,
                        "longLeverage" : Int(longLeverage)!,
                        "shortLeverage" : Int(shortLeverage)!,
                        "maxLongLeverage" : Int(maxLongLeverage)!,
                        "maxShortLeverage" : Int(maxShortLeverage)!] as [String : Any]
        
        return ["userId" : userId,
                "strategy" : strategy]
    }
    
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
    
    /**
    func getJSONStringFromDictionary(dictionary:NSDictionary) -> String {
           if (!JSONSerialization.isValidJSONObject(dictionary)) {
               print("无法解析出JSONString")
               return ""
           }
           let data : NSData! = try? JSONSerialization.data(withJSONObject: dictionary, options: []) as NSData!
           let JSONString = NSString(data:data as Data,encoding: String.Encoding.utf8.rawValue)
           return JSONString! as String
       }
     */
}
