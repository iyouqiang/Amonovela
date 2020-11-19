//
//  FCDictionaryService.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

public class FCDictionaryService: NSObject {
    
    //单例
    static public let sharedInstance = FCDictionaryService()
    
    //加入缓存的数据
    static public let FC_DICTIONARY_DATA = "FC_DICTIONARY_DATA"
    static public let FC_COUNTRYCODE_LIST = "FC_COUNTRYCODE_LIST"
    
    //不加入缓存的数据，第一次请求加入缓存
    static public let FC_QUOTE_TYPES = "FC_QUOTE_TYPES"
    
    var count = 0
    
    //全局保存的登录用户信息,
    var dictData: [String: Any] = [FC_COUNTRYCODE_LIST: []]
    
    //仅存在内存的数据
    var tempData: [String: Any] = [:]
    
    override init() {
        super.init()
        self.restoreDataFromCache()
    }
    
    func restoreDataFromCache () {
        if let jsonStr = UserDefaults.standard.string(forKey: FCDictionaryService.FC_DICTIONARY_DATA) {
            self.dictData = self.stringToJson(jsonStr: jsonStr) ?? [FCDictionaryService.FC_COUNTRYCODE_LIST: []]
        }
    }
    
    func queryCacheByKey (key: String) -> Any?{
        
        return self.dictData[key]
    }
    
    func addCacheWithKey (key: String, value: Any = "") -> Bool {
        if (key.isEmpty) {
            return false
        }
        self.dictData[key] = value
        let jsonStr = self.JSONStringify(value: self.dictData)
        if let validResult = jsonStr {
            UserDefaults.standard.set(validResult, forKey: FCDictionaryService.FC_DICTIONARY_DATA)
            return true
        }
        return false
    }
    
    func fetchCountryCodeList () {
        let api = FCApi_CountryCode.init()
        api.startWithCompletionBlock(success: { (response) in
            if (response.responseCode == 0) {
                
                let resultDict = response.responseObject as? [String : Any]
                if let validResult = resultDict?["data"] {
                 
                    let _ =  self.addCacheWithKey(key: FCDictionaryService.FC_COUNTRYCODE_LIST, value: validResult)
                }
                
            } else {

            }
        }) { (result) in

            self.count += 1
            
            if self.count < 5 {
                self.fetchCountryCodeList()
            }
        }
    }
    
    func saveTempData(key: String, data: Any) {
        self.tempData[key] = data
    }
    
    func queryTempData(key: String) -> Any?{
        return self.tempData[key]
    }
    
    //对象转成JsonString
    public func JSONStringify(value: [String : Any],prettyPrinted:Bool = false) -> String? {
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        if JSONSerialization.isValidJSONObject(value) {
            do {
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            } catch {
                //          XCGLogger.default.debug("error")
            }
        }
        return ""
    }
    
    
    //string转Json
    public func stringToJson (jsonStr: String) -> [String : Any]? {
        
        if (jsonStr.isEmpty) {
            return [:]
        } else {
            let jsonData = jsonStr.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
            guard let json = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers) else {
                return [:]
            }
            return json as? [String : Any]
        }
    }
}
