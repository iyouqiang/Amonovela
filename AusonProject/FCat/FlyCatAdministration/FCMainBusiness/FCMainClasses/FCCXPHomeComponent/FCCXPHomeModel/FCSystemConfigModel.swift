//
//  FCSystemConfigModel.swift
//  Auson
//
//  Created by Yochi on 2021/1/4.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit

public let user_invitation_jumpkey = "user-invitation"
public let help_center_jumpkey     = "help-center"
public let user_kyc_jumpkey        = "user-kyc"
public let easy_buy_coin           = "easy-buy-coin"
public let fiat_assets             = "fiat-assets"

class FCAppJumpModel: NSObject {

    var jumpKey: String = ""
    var jumpName: String = ""
    var jumpType: String = ""
    var jumpLink: String = ""
    var requiredAuth: Bool = false
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        jumpKey  = json["jumpKey"].stringValue
        jumpName = json["jumpName"].stringValue
        jumpType = json["jumpType"].stringValue
        jumpLink = json["jumpLink"].stringValue
        requiredAuth = json["requiredAuth"].boolValue
    }
}

class FCCountryCodeModel: NSObject {
    
    var code: String = ""
    var name: String = ""
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        code = json["code"].stringValue
        name = json["name"].stringValue
    }
}

class FCSystemConfigModel: NSObject, NSCoding {

    var countryCodes = [FCCountryCodeModel]()
    var jumps = [String:FCAppJumpModel]()
    
    init(dict: [String: AnyObject]){
        super.init()
        let jsonData = JSON(dict)
        
        for (_, subJSON) : (String, JSON) in jsonData["jumps"] {
            let jumpModel = FCAppJumpModel.init(dict: subJSON.dictionaryValue as [String : AnyObject])
            jumps[jumpModel.jumpKey] = jumpModel
        }
        for (_, subJSON) : (String, JSON) in jsonData["countryCodes"] {
            let countryCodeModel = FCCountryCodeModel.init(dict: subJSON.dictionaryValue as [String : AnyObject])
            countryCodes.append(countryCodeModel)
        }
    }
    
    /// 归档 
    func encode(with aCoder: NSCoder) {
        aCoder.encode(countryCodes, forKey: "countryCodes")
        aCoder.encode(jumps, forKey: "jumps")
    }

    required init?(coder aDecoder: NSCoder) {
        countryCodes = aDecoder.decodeObject(forKey: "countryCodes") as? [FCCountryCodeModel] ?? [FCCountryCodeModel]()
        jumps = aDecoder.decodeObject(forKey: "jumps") as? [String:FCAppJumpModel] ?? [String:FCAppJumpModel]()
    }
}
