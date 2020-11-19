//
//  KLineStateManger.swift
//  KLine-Chart
//
//  Created by He on 2020/3/3.
//  Copyright © 2020 hjs. All rights reserved.
//

import UIKit
//import RxSwift

open class KLineStateManger {
    
  public weak var klineChart: KLineChartView? {
        didSet {
            klineChart?.mainState = mainState
            klineChart?.secondaryState = secondaryState
            klineChart?.isLine = isLine
            klineChart?.datas = datas
        }
    }
    
    private init() {
        
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
  public static let manager = KLineStateManger()
    
    //默认显示1hour的k线 
    var period: String = KLinePeriod.min01.rawValue
    var timer: Timer?
    
    // 主图默认无指标
    //var mainState: MainState = .none
    var mainState: MainState = .ma
    var secondaryState : SecondaryState = .macd
    var isLine = false
    var datas: [KLineModel] = [] {
        didSet {
            klineChart?.datas = datas
            /// 计算k线
            DataUtil.calculate(dataList: datas)
        }
    }
    
    //CXP
    var symbol: String = ""
    var startTs: String = ""
    var endTs: String = ""
//    var disposeBag = DisposeBag()
//    var latesSubscription: Disposable?
    
    public  func setMainState(_ state: MainState) {
        mainState = state
        klineChart?.mainState = state
    }
    
    public  func setSecondaryState(_ state: SecondaryState) {
        secondaryState = state
        klineChart?.secondaryState = state
    }
    
    public  func setisLine(_ isLine: Bool) {
        self.isLine = isLine
        klineChart?.isLine = isLine
    }
    
    public  func setDatas(_ datas: [KLineModel]) {
        self.datas = datas
        klineChart?.datas = datas
    }
    
    public  func setPeriod(_ period: String, _ startTs: String? = "") {
        
        //需要取重新请求数据
        self.period = period
        self.datas = []
        self.endTs = Date().milliStamp
        self.startTs = self.getStartTs(endTs: self.endTs, period: self.period)
        
        KLineRequestTool.tool.getData(symbol: self.symbol, period: self.period, startTs: self.startTs, endTs: self.endTs) {
            (datas) in
            //翻转数组
            DataUtil.calculate(dataList: datas.reversed())
            KLineStateManger.manager.datas = datas.reversed()

            // 先取消上一个订阅, 轮询最新的k线数据
            self.timer?.invalidate()
            if #available(iOS 10.0, *) {
                self.timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (timer) in
                    
                    self?.getLatestKline(period: period)
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    public func cancelPolling () {
        timer?.invalidate()
    }
    
    public func setDefaultState () {
        
        /// 获取主图 副图指标
        self.period = KLinePeriod.min01.rawValue
        self.mainState = .none
        self.secondaryState = .macd
        
        if let period = UserDefaults.standard.object(forKey: KLINEPERIODKEY) {
            
            let periodStr = period as! String
            self.period = periodStr
        }
        
        if let mainTag = UserDefaults.standard.object(forKey: MAINCHARTINDEXKEY) {
            
            let str = mainTag as! String
            switch Int(str) {
            case 1:
                self.mainState = .ma
                break
            case 2:
                self.mainState = .boll
                break
            default:
                self.mainState = .none
            }
        }
        
        if let auxilTag = UserDefaults.standard.object(forKey: AUXILIARYCHARTKEY) {
            
            let str = auxilTag as! String
            
            switch Int(str) {
            case 1:
                self.secondaryState = .macd
            case 2:
                self.secondaryState = .kdj
                break
            case 3:
                self.secondaryState = .rsi
                break
            case 4:
                self.secondaryState = .wr
                break
            default:
                self.secondaryState = .none
            }
        }
    }
    
    public func setKLine(symbol: String, period: String) {
        
        self.setDefaultState()
        
        if period.count > 0 {
            self.period = period
        }
        
        self.symbol = symbol
        
        self.setPeriod(self.period)
    }
    
    public func getLatestKline(period: String) {
        
        KLineRequestTool.tool.getLatestData(symbol: self.symbol, period: period) { (kline) in
            if period != self.period { return }
            self.setKLineRight(kline: kline)
        }
    }
    
    public func getStartTs(endTs: String, period: String) -> String {
        //默认返回500根K对应的时间戳
        var times = 1
        if (period == KLinePeriod.day01.rawValue) {
            times = 24 * 60
        } else if (period == KLinePeriod.week01.rawValue) {
            times = 24 * 60 * 7
        } else if (period == KLinePeriod.month01.rawValue) {
            times = 24 * 60 * 30
        } else {
            times = Int(period) ?? 1
        }
        
        let startTs = (Int(endTs) ?? 0) - 500 * times * 60 * 1000
        print("startTs : ", startTs, endTs)
        return "\(startTs)"
    }
    
    func disposeObservable() {
        
    }
    
    
    //从左边追加数据, 需要正确查找数据插入位置
    func setKLineLeftPart () {
        
    }
    
    //从右边插入数据， 需要正确查找数据插入位置
    public func setKLineRight (kline: KLineModel) {
        var datas = self.datas
        
        if datas.last?.id == kline.id {
            datas[datas.count - 1] = kline
            self.datas = datas
            KLineStateManger.manager.datas = datas
            
        } else if datas.count == 0 {
            
            self.appendKlineAtRight(kline: kline, index: 0, isInsert: true)
        } else {
            // 查找插入位置
            for (index, data) in datas.enumerated() {
                
                if data.id == kline.id {
                    datas[index] = kline
                    self.datas = datas
                    KLineStateManger.manager.datas = datas
                    break
                } else if (data.id < kline.id) {
                    self.appendKlineAtRight(kline: kline, index: index, isInsert: true)
                    break
                }
            }
        }
    }
    
    public func appendKlineAtRight(kline: KLineModel, index: Int, isInsert: Bool) {
        if (isInsert) {
            DataUtil.addLastData(dataList: self.datas, data: kline)
            self.datas.insert(kline, at: index)
            KLineStateManger.manager.datas = self.datas
        }
    }
}

extension Date {
    /// 获取当前 毫秒级 时间戳 - 13位
    public var milliStamp : String {
        let timeInterval: TimeInterval = self.timeIntervalSince1970
        let millisecond = CLongLong(round(timeInterval*1000))
        return "\(millisecond)"
    }
}
