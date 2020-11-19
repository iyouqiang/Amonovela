//
//  FCAssetModel.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON


/**
 assets =         (
 );
 summary =         {
     estimatedAsset = BTC;
     estimatedFiatAsset = CNY;
     estimatedFiatValue = "\Uffe50.00";
     estimatedValue = "0.00000000";
     withdrawalQuota = 100;
     withdrawalUsedQuota = 0;
 };
 */

class FCAssetSummaryModel: NSObject {

    var assets:[FCAssetModel]?
    var summary:FCSummaryModel?
    
    init(dict: [String: AnyObject]){
        super.init()
        
        let jsonData = JSON(dict)
        assets = [FCAssetModel]()
        summary = FCSummaryModel.init(dict: jsonData["summary"].dictionaryValue as [String : AnyObject])
        
        for (_, subJSON) : (String, JSON) in jsonData["assets"] {
            let assetModel = FCAssetModel.init(dict: subJSON.dictionaryValue as [String : AnyObject])
            assetModel.cellIsFold = true
            assets?.append(assetModel)
        }
    }
}

class FCAssetModel: NSObject, HandyJSON,Codable {
    required override init() {
        
    }
    
    var cellIsFold: Bool?
    var assetIcon: String?
    var estimatedFiatAsset: String?
    var estimatedFiatValue: String?
    // 资产币种
    var asset: String?
    // 资产名字
    var name: String?
    // 冻结资产
    var freezed: String?
    // 可用资产
    var available: String?
    // 总额
    var total: String?
    // 估值资产币种，BTC，ETH等
    var estimatedAsset: String?
    // 按estimatedAsset估算的价值
    var estimatedValue: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        asset = json["asset"].stringValue
        estimatedFiatAsset = json["estimatedFiatAsset"].stringValue
        name = json["name"].stringValue
        assetIcon = json["assetIcon"].stringValue
        freezed = json["freezed"].stringValue
        estimatedValue = json["estimatedValue"].stringValue
        available = json["available"].stringValue
        total = json["total"].stringValue
        estimatedAsset = json["estimatedAsset"].stringValue
        estimatedValue = json["estimatedValue"].stringValue
        estimatedFiatValue = json["estimatedFiatValue"].stringValue
       }
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCAssetModel{
        return FCAssetModel.deserialize(from: jsonData) ?? FCAssetModel()
    }
}

class FCSummaryModel: NSObject {

    var estimatedAsset: String?
    var estimatedFiatAsset: String?
    var estimatedFiatValue: String?
    var estimatedValue: String?
    var withdrawalQuota: String?
    var withdrawalUsedQuota: String?
    
    init(dict: [String: AnyObject]){
        super.init()
        let json = JSON(dict)
        estimatedAsset = json["estimatedAsset"].stringValue
        estimatedFiatAsset = json["estimatedFiatAsset"].stringValue
        estimatedFiatValue = json["estimatedFiatValue"].stringValue
        estimatedValue = json["estimatedValue"].stringValue
        withdrawalQuota = json["withdrawalQuota"].stringValue
        withdrawalUsedQuota = json["withdrawalUsedQuota"].stringValue
       }
}

class FCContractSetModel:NSObject {
    
    var title: String?
    var descriStr: String?
    var type:Int? // 杠杆倍数，或者普通单位
    
    init(title: String? = "", descriStr: String? = "", type: Int? = 0) {
        super.init()
        self.title = title
        self.descriStr = descriStr
        self.type = type
    }
}


