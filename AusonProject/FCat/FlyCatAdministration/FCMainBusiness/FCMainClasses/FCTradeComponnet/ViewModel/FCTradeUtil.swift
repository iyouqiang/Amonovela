//
//  FCTradeUtil.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/9.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCTradeUtil: NSObject {
  static let shareInstance = FCTradeUtil()
    lazy var tradeModel: FCMarketModel = {
        let model = FCMarketModel()
        model.symbol = "BTC-USDT"
        model.size = "0.0001"
        return model
    }()
    var makerSide: String?  //Ask卖出， Bid买入
    
    override init() {
        super.init()
        
    }
}
