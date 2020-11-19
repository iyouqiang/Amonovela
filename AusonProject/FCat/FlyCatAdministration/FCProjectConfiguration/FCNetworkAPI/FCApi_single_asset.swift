//
//  FCApi_single_asset.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCApi_single_asset: YTKRequest {

    ////symbol是资产符号，用资产和区块链网络组成，特别注意USDT资产
    ///包括: BTC, ETH, USDT_OMNI, USDT_ERC20等
    
    var asset = ""
    init(asset:String) {
        super.init()
        self.asset = asset
            
        //self.add(YTKAnimatingRequestAccessory.accessoryWithAnimatingView() as! YTKRequestAccessory)
    }
        
    override func baseUrl() -> String {
        return HOSTURL_API
    }
        
    override func requestUrl() -> String {
        return "/api/v1/wallet/spot/account/single/asset/get"
    }
        
    override func requestMethod() -> YTKRequestMethod {
        return .GET
    }
        
    override func requestArgument() -> Any? {
            
        return ["asset":asset]
    }
        
    override func requestHeaderFieldValueDictionary() -> [String : String]? {
        return requestHeaderFieldValue()
    }
    
    override func requestSerializerType() -> YTKRequestSerializerType {
        return .JSON
    }
}
