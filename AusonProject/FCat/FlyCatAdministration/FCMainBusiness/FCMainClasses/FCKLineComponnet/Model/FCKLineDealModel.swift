
//
//  FCKLineDealModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCKLineTradeModel : NSObject, HandyJSON, Codable {
    var id: String = ""
    var volume: String = ""
    var price: String = ""
    var time: String = ""
    var makerSide: String = ""
    var priceSide: String = ""
    var rawTs = 0
    required public override init() {
        
    }
}

class FCKLineDealModel: NSObject, HandyJSON, Codable {
    
    var trades: [FCKLineTradeModel]?
    var latestTrade: FCKLineTradeModel?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCKLineDealModel{
        return FCKLineDealModel.deserialize(from: jsonData) ?? FCKLineDealModel()
    }

}
