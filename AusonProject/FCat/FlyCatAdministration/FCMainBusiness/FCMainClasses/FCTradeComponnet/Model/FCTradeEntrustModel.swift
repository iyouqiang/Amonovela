
//
//  FCTradeEntrustModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON


class FCTradeEntrustModel: NSObject, HandyJSON, Codable {

    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCTradeEntrustModel{
        return FCTradeEntrustModel.deserialize(from: jsonData) ?? FCTradeEntrustModel()
    }
    
}
