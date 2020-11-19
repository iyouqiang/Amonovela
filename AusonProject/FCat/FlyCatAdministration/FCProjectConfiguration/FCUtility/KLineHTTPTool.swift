
//
//  KLineHTTPTool.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import KLineXP

class KLineHTTPTool: NSObject {
    
    static let tool = KLineHTTPTool()
    
    var historyApi: YTKRequest?
    var lastklineApi: YTKRequest?
    
    /// 默认现货k线数据
    var accountType:TradingAccountType = .tradingAccountType_spot
    
    var currentDataTask: URLSessionDataTask?
    var latesDataTask: URLSessionDataTask?
    
    func getData(symbol: String, period: String, startTs: String, endTs:String, complationBlock: @escaping (([KLineModel]) -> Void)) {
        
        historyApi?.stop()
        
        if self.accountType == .tradingAccountType_spot {
            
            let historyklineApi = FCApi_market_kline_history(symbol: symbol, klineType: period, startTs: startTs, endTs: endTs)
            historyklineApi.startWithCompletionBlock(success: { (response) in
                 
                let dict = response.responseObject as? [String:Any]
                
                if let dicts = dict?["data"] as? [String:Any], let klines = dicts["klines"] as? [[String : Any]]  {
                    let datas =  klines.map { (dict) -> KLineModel in
                        return KLineModel(dict: dict)
                    }
                    DispatchQueue.main.async {
                         complationBlock(datas)
                    }
                    return
                }
                
            }, failure: nil)
            historyApi = historyklineApi
            return
        }
        
        var tradingUnit = "COIN"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            
            tradingUnit = "CONT"
        }
        
        let historyklineApi = FCApi_swap_kline_history(symbol: symbol, klineType: period,tradingUnit: tradingUnit,startTs: startTs, endTs: endTs)
        historyklineApi.startWithCompletionBlock(success: { (response) in
             
            let dict = response.responseObject as? [String:Any]
            
            if let dicts = dict?["data"] as? [String:Any], let klines = dicts["klines"] as? [[String : Any]]  {
                let datas =  klines.map { (dict) -> KLineModel in
                    return KLineModel(dict: dict)
                }
                DispatchQueue.main.async {
                     complationBlock(datas)
                }
                return
            }
            
        }, failure: nil)
        historyApi = historyklineApi
    }
    
    /// 获取最新一条k线
   func getLatestData(symbol: String, period: String, complationBlock: @escaping ((KLineModel) -> Void)) {
    
        lastklineApi?.stop()
    
    if self.accountType == .tradingAccountType_spot {
        
        /// 现货k线
        let lastKlineApi = FCApi_kline_latest(symbol: symbol, klineType: period)
        lastKlineApi.startWithCompletionBlock(success: { (response) in
        
            let dict = response.responseObject as? [String:Any]
            if let dicts = dict?["data"] as? [String:Any], let kline = dicts["kline"] as? [String : Any] {
                    let datas = KLineModel(dict: kline)
                DispatchQueue.main.async {
                     complationBlock(datas)
                }
                return
            }
            
        }, failure: nil)
        
        self.lastklineApi = lastKlineApi
        
        return
    }
    
    var tradingUnit = "COIN"
    if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
    
        tradingUnit = "CONT"
    }
    
    let lastKlineApi = FCApi_swap_kline_latest(symbol: symbol, klineType: period, tradingUnit: tradingUnit)
    lastKlineApi.startWithCompletionBlock(success: { (response) in
    
        let dict = response.responseObject as? [String:Any]
        if let dicts = dict?["data"] as? [String:Any], let kline = dicts["kline"] as? [String : Any] {
                let datas = KLineModel(dict: kline)
            DispatchQueue.main.async {
                 complationBlock(datas)
            }
            return
        }
        
    }, failure: nil)
    
    self.lastklineApi = lastKlineApi

    }
}

extension KLineHTTPTool: KLineRequestToolDelegate
{
    func klinegetData(symbol: String, period: String, startTs: String, endTs:String, complationBlock: @escaping (([KLineModel]) -> Void))
    {
        print("periodperiod : ", period);
        KLineHTTPTool.tool.getData(symbol: symbol, period: period, startTs: startTs, endTs: endTs, complationBlock: complationBlock)
    }
    
    func klinegetLatestData(symbol: String, period: String, complationBlock: @escaping ((KLineModel) -> Void))
    {
        print("klinegetLatestData : ", period);
        KLineHTTPTool.tool.getLatestData(symbol: symbol, period: period, complationBlock: complationBlock)
    }
}
