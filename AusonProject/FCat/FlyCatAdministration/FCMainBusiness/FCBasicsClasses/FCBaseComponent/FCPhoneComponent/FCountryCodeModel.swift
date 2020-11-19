
//
//  FCountryCodeModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON


class FCCountryCodeItem: NSObject, HandyJSON, Codable {
    public var name: String? = nil
    public var code: String? = nil
    required public override init() {
        
    }
    
}

 class FCountryCodeModel: NSObject, HandyJSON, Codable {
    public var defaultCountryCode: FCCountryCodeItem?
    public var countryCodes: [FCCountryCodeItem]?
     
    required public override init() {
        
    }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCountryCodeModel {
        return FCountryCodeModel.deserialize(from: jsonData) ?? FCountryCodeModel()
    }
    
}
