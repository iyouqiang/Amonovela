
//
//  FCEXAccountManager.swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/21.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCEXAccountManager: NSObject {

    static let fileName = "FCExchangeAccount.plist"
    
     class func getDBPath() -> String?{
        
       let fileManager = FileManager.default
        
        //取沙盒里plist文件
       let documentDirectory: NSArray = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
       let writableDBPath = (documentDirectory[0] as AnyObject).appendingPathComponent(fileName) as String
        
       //判断是否存在
        var dbexits = fileManager.fileExists(atPath: writableDBPath)
        
        if (dbexits != true) {
            
           dbexits = fileManager.createFile(atPath: writableDBPath, contents: nil, attributes: nil)
        }
        
        return dbexits == true ? writableDBPath : nil
    }
    
    //插入 account = 用户sid + exchangeAccount
    class func inserAnAccount(exchangeAccount: String, apiKey: String, secret: String) -> Bool {
        var accountKey = exchangeAccount
        
        if let userPhone = FCUserInfoManager.sharedInstance.getUserInfo()?.phone {
            
            accountKey = userPhone + exchangeAccount
        }
        let DBPath = FCEXAccountManager.getDBPath()
        let accountDict = NSDictionary(contentsOfFile: DBPath!)
        
        var root = NSMutableDictionary()
        if ((accountDict?.allKeys.count) != nil) {
            
            root = NSMutableDictionary.init(dictionary: accountDict!)
        }
        
        root.setValue(["apiKey" : FCCrypto.Encoding(raw_in: apiKey), "secret" : FCCrypto.Encoding(raw_in: secret)], forKey: accountKey)
        
        return root.write(toFile: DBPath!, atomically: true)
    }
    
    //查找 account = 用户sid + exchangeAccount
  @objc public class func specialAccount(_ exchangeAccount: String) -> [String : String]? {
    
    var accountKey = exchangeAccount
    
    if let userPhone = FCUserInfoManager.sharedInstance.getUserInfo()?.phone {
        
        accountKey = userPhone + exchangeAccount
    }
    
    let DBPath = FCEXAccountManager.getDBPath()
    let accountDict = NSDictionary(contentsOfFile: DBPath!)
    print("本地存储的key", accountDict as Any)
    var result: [String : String]? = nil
    if accountDict != nil {
        
            let dict = accountDict![accountKey] as? NSDictionary
            if  dict != nil {
                
                let apiKey = FCCrypto.Decoding(raw_out: (dict?.value(forKey: "apiKey"))! as! String)
                let secret = FCCrypto.Decoding(raw_out: (dict?.value(forKey: "secret"))! as! String)
                result = ["apikey" : apiKey,
                          "secret" : secret]
            }
        }
        
        return result
    }
    
    //删除
   class func removeAnAccount(_ exchangeAccount: String) {
        
        var accountKey = exchangeAccount
    
    if let userPhone = FCUserInfoManager.sharedInstance.getUserInfo()?.phone {
        
        accountKey = userPhone + exchangeAccount
    }
    
        let DBPath = FCEXAccountManager.getDBPath()
        let accountDict = NSDictionary(contentsOfFile: DBPath!)
        
        var root = NSMutableDictionary()
        if ((accountDict?.allKeys.count) != nil) {
            
            root = NSMutableDictionary.init(dictionary: accountDict!)
        }

        root.removeObject(forKey: accountKey)
        root.write(toFile: DBPath!, atomically: true)
    }
    
    //更新请求头token中的apiKey和secret,
   @objc public class func updateTokenParameter(exchangeAccount: String){
        
        let parameter = specialAccount(exchangeAccount)
        
        if  parameter != nil {
            let apiKey = FCCrypto.Decoding(raw_out: parameter!["apikey"]!)
            let secret = FCCrypto.Decoding(raw_out: parameter!["secret"]!)
            PCCookieManager.share().updateApiKey(apiKey, secret:secret)
           
        }else{
            
            PCCookieManager.share().updateApiKey(nil, secret: nil)
        }
    }
    
    public class func updateToken(apiKey: String, secret: String) {
        
        PCCookieManager.share().updateApiKey(apiKey, secret:secret)
    }
    
}
