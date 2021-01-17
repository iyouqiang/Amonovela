//
//  FCTransferRecordModel.swift
//  Auson
//
//  Created by Yochi on 2021/1/11.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCTransferRecordModel: NSObject,HandyJSON, Codable {

    /**
     records =         (
                     {
             amount = "1.000000";
             asset = USDT;
             fromAccount = Spot;
             status = Filled;
             time = "2021-01-09 21:34:50";
             toAccount = Swap;
         }
     );
     */
    
    var amount = ""
    var asset = ""
    var fromAccount = ""
    var status = ""
    var time = ""
    var toAccount = ""
    
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCTransferRecordModel{
        return FCTransferRecordModel.deserialize(from: jsonData) ?? FCTransferRecordModel()
    }
}
