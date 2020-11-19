//
//  FCTradeSettingManager.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/30.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

let tradeTradingUnitKEY = "CXP.tradeTradingUnit"
let tradeSelectContractDepthKEY = "CXP.ContractDepthKEY"

class FCTradeSettingconfig: NSObject {

    static let sharedInstance = FCTradeSettingconfig()
    
    var tradeConfigInfo: [String : Any]?
    //var symbol: String?
    var tradingUnitStr = "张"
    
    var tradeSettingInfoModel: FCTradeSettingModel?
    
     /// 0 默认 1 买盘 2 买盘
    var depthType: String? {
        didSet {
            guard let depthType = depthType else {
                return
            }
            
             FCUserDefaults.setObject(depthType as AnyObject, ForKey: tradeSelectContractDepthKEY, synchronize: true)
        }
    }
    
     var symbol: String? {
        didSet {
            guard let symbol = symbol else {
                return
            }
            
            let symbolArray = symbol.split(separator: "-")
            //let symbolStr = symbolArray.last ?? ""
            //let sheetStr = symbolArray.first ?? ""
            
            if self.tradeTradingUnit == .TradeTradingUnitType_CONT {
                self.tradingUnitStr = "张"
            }else {
                self.tradingUnitStr = "\(symbolArray.first ?? "")"
            }
        }
    }
    
    var marginMode: MarginModeType? {
        
        didSet {
            guard let marginMode = marginMode else {
                return
            }
                
            if marginMode == .marginMode_Cross {
             
                self.tradeConfigInfo?["accountMode"] = "Cross"
            }else {
                
                self.tradeConfigInfo?["accountMode"] = "Isolated"
            }
             
             DispatchQueue.global().async {
                
                // do async task
                self.savetradeConfigInfo(self.tradeConfigInfo ?? [String : Any]())
             }
        }
    }
    
    var tradeTradingUnit: TradeTradingUnitType? {
        
        didSet {
            guard let tradeTradingUnit = tradeTradingUnit else {
                return
            }
            var tradingUnit = ""
            let symbolArray = self.symbol?.split(separator: "-")
            
            if tradeTradingUnit == .TradeTradingUnitType_CONT {
             
                //self.tradeConfigInfo?["tradingUnit"] = "CONT"
                tradingUnit = "CONT"
                self.tradingUnitStr = "张"
            }else {
                
                //self.tradeConfigInfo?["tradingUnit"] = "COIN"
                tradingUnit = "COIN"
                self.tradingUnitStr = "\(symbolArray?.first ?? "")"
            }
            
            FCUserDefaults.setObject(tradingUnit as AnyObject, ForKey: tradeTradingUnitKEY, synchronize: true)
             DispatchQueue.global().async {
                
                // do async task
                //self.savetradeConfigInfo(self.tradeConfigInfo ?? [String : Any]())
                
                FCUserDefaults.setObject(tradingUnit as AnyObject, ForKey: tradeTradingUnitKEY, synchronize: true)
             }
        }
    }
        
    var longLeverage: String? {
        
        didSet {
            guard let longLeverage = longLeverage else {
                return
            }
                
             tradeConfigInfo?["longLeverage"] = longLeverage
            
             DispatchQueue.global().async {
                
                // do async task
                self.savetradeConfigInfo(self.tradeConfigInfo ?? [String : Any]())
             }
        }
    }
    
    var shortLeverage: String? {
        
        didSet {
            guard let shortLeverage = shortLeverage else {
                return
            }
                
             self.tradeConfigInfo?["shortLeverage"] = shortLeverage
            
             DispatchQueue.global().async {
                
                // do async task
                self.savetradeConfigInfo(self.tradeConfigInfo ?? [String : Any]())
             }
        }
    }

      func savetradeConfigInfo (_ tradeConfigInfo: [String : Any]) {
       
          self.tradeSettingInfoModel = FCTradeSettingModel.stringToObject(jsonData: tradeConfigInfo)
          
          FCUserDefaults.setObject(tradeConfigInfo as AnyObject, ForKey: kFCCurrentTradeSettingInfo, synchronize: true)
      }
      
      @objc func gettradeConfiInfo() -> FCTradeSettingModel? {
          
          let tradeInfo = FCUserDefaults.objectForKey(kFCCurrentTradeSettingInfo) as? [String : Any]
        self.tradeConfigInfo = tradeInfo ?? [String :
        Any]()
        let tradeInfoModel = FCTradeSettingModel.stringToObject(jsonData: tradeInfo)
        return tradeInfoModel
      }
      
      @objc public func remveTradeSettingInfo() {
          
          FCUserDefaults.removeObjectForKey(kFCCurrentTradeSettingInfo)
      }
    
    override public init() {
             super.init()
             
        /// 初始化数据
        self.tradeSettingInfoModel = self.gettradeConfiInfo()
            
        /// 显示合约深度样式
        var depthType = FCUserDefaults.objectForKey(tradeSelectContractDepthKEY)
        if (depthType == nil) {
            
            depthType = "0" as AnyObject
        }
        self.depthType = depthType as? String
        
        /// 交易策略
        if self.tradeConfigInfo?.count == 0 {
            
               self.tradeConfigInfo = [
                "accountMode": "Cross",
                "tradingUnit" : "COIN",
                "longLeverage":"10",
                "shortLeverage":"10",
                "maxLongLeverage": "100",
                "maxShortLeverage" : "50",
                "symbol" : "BTC-USDT"]
           }

           /// 类型赋值
           let marginModeStr: String = self.tradeConfigInfo?["accountMode"] as! String
           //let tradingUnitStr: String = self.tradeConfigInfo?["tradingUnit"] as! String
        
            let localtradingUnit = "\(FCUserDefaults.objectForKey(tradeTradingUnitKEY) ?? "COIN" as AnyObject)"
           
           if marginModeStr == "Cross" {
               
               self.marginMode = .marginMode_Cross
           }else {
            
               self.marginMode = .marginMode_Isolated
           }
           
           if localtradingUnit == "CONT" {
               
               self.tradeTradingUnit = .TradeTradingUnitType_CONT
           }else {
            
               self.tradeTradingUnit = .TradeTradingUnitType_COIN
           }
           
           self.longLeverage = self.tradeConfigInfo?["longLeverage"] as? String
           self.shortLeverage = self.tradeConfigInfo?["shortLeverage"] as? String
         }
    
    /// 获取交易策略
    func loadSettingCofig(symbol: String, completion: @escaping (_ model: FCTradeSettingModel, _ errMsg: String) -> Void) {
        
        let tradeStrategyApi =  FCApi_trading_strategy(symbol: symbol)
        tradeStrategyApi.startWithCompletionBlock(success: { (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
              
                let data = responseData?["data"] as? [String : AnyObject]
                
                if let strategy = data?["strategy"] as? [String : AnyObject] {

                    /// 本地设置单位
                    //strategy["tradingUnit"] = FCTradeSettingconfig.sharedInstance.tradingUnitStr as AnyObject?
                    
                    /// 数据存储
                    let model = FCTradeSettingModel(dict: strategy)
                    //self?.settingModel = model
                    
                    /// 字典 model 赋值
                    FCTradeSettingconfig.sharedInstance.tradeSettingInfoModel = model
                    FCTradeSettingconfig.sharedInstance.tradeConfigInfo = strategy
                    model.tradeTradingUnit = FCTradeSettingconfig.sharedInstance.tradingUnitStr
                    FCTradeSettingconfig.sharedInstance.shortLeverage = model.shortLeverage
                    FCTradeSettingconfig.sharedInstance.longLeverage = model.longLeverage
                    if model.accountMode == "Cross" {
                        FCTradeSettingconfig.sharedInstance.marginMode = .marginMode_Cross
                    }else {
                        FCTradeSettingconfig.sharedInstance.marginMode = .marginMode_Isolated
                    }
                    
                    /// 数据保存
                    FCTradeSettingconfig.sharedInstance.savetradeConfigInfo(strategy)
                    
                    completion(model, "")                }
                
            } else{
             
                let errMsg = responseData?["err"]?["msg"] as? String
                completion(FCTradeSettingModel(), errMsg ?? "获取数据错误")
            }
            
        }) { (response) in
            
        }
    }
}
