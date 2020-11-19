

//
//  FCMarketTypesModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

import Foundation
import HandyJSON


class FCMarketTypesItem: NSObject, HandyJSON, Codable  {
    var type: String?
    var name: String?
    
    required public override init() {
        
    }
}


class FCMarketTypesModel: NSObject, HandyJSON, Codable {
    var marketTypes: [FCMarketTypesItem]?
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCMarketTypesModel {
        return FCMarketTypesModel.deserialize(from: jsonData) ?? FCMarketTypesModel()
    }
}
