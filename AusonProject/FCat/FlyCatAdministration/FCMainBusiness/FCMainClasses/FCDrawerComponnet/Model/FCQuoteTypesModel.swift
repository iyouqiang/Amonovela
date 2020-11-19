//
//  FCQuoteTypesModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON


class FCQuoteTypeItem: NSObject, HandyJSON, Codable {
    
    var tickers: [FCMarketModel]?
    var quote: String = ""
    var name: String = ""
    
    /// 合约type
    var group: String = ""
    var contracts: [FCContractsModel]?
    var ticker: FCMarketModel?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCQuoteTypeItem{
        return FCQuoteTypeItem.deserialize(from: jsonData) ?? FCQuoteTypeItem()
    }
}

class FCQuoteTypesModel: NSObject, HandyJSON, Codable{
    
    
    var quoteTypes: [FCQuoteTypeItem]?
    var marketGroups: [FCQuoteTypeItem]?
    var defaultGroup: String?
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCQuoteTypesModel{
        return FCQuoteTypesModel.deserialize(from: jsonData) ?? FCQuoteTypesModel()
    }
    
}
