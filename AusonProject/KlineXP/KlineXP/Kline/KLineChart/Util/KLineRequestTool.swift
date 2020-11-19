//
//  KLineRequestTool.swift
//  KLineXP
//
//  Created by Yochi on 2020/11/5.
//

import UIKit

public protocol KLineRequestToolDelegate : NSObjectProtocol {
    
    func klinegetData(symbol: String, period: String, startTs: String, endTs:String, complationBlock: @escaping (([KLineModel]) -> Void))
    
    func klinegetLatestData(symbol: String, period: String, complationBlock: @escaping ((KLineModel) -> Void))
}

open class KLineRequestTool: NSObject {

    public weak var delegate : KLineRequestToolDelegate?
    
    public static let tool = KLineRequestTool()
    
    public func getData(symbol: String, period: String, startTs: String, endTs:String, complationBlock: @escaping (([KLineModel]) -> Void)) {
        
        self.delegate?.klinegetData(symbol: symbol, period: period, startTs: startTs, endTs: endTs, complationBlock: complationBlock)
    }
    
    /// 获取最新一条k线
    public func getLatestData(symbol: String, period: String, complationBlock: @escaping ((KLineModel) -> Void)) {
    
    self.delegate?.klinegetLatestData(symbol: symbol, period: period, complationBlock: complationBlock)
    }
}
