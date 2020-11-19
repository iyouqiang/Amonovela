//
//  FCTradeSettingManager.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/30.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCTradeSettingconfig: NSObject {

    @objc static let sharedInstance = FCTradeSettingconfig()
    
      @objc var tradeSettingInfo: FCTradeSettingModel?
      
      override public init() {
          super.init()
          
          self.tradeSettingInfo = self.getUserInfo()
      }
      
      func saveUserInfo (_ userInfo: [String : Any]) {
          
          self.tradeSettingInfo = FCUserInfoModel.stringToObject(jsonData: userInfo)
          
          FCUserDefaults.setObject(userInfo as AnyObject, ForKey: kFCCurrentUserInfo, synchronize: true)
      }
      
      @objc func getUserInfo() -> FCUserInfoModel? {
          
          let loginInfo = FCUserDefaults.objectForKey(kFCCurrentUserInfo) as? [String : AnyObject]
          if loginInfo != nil {
              let userInfoModel = FCUserInfoModel.stringToObject(jsonData: loginInfo)
              
              return userInfoModel
          }
          return nil
      }
      
      @objc public func remveUserInfo() {
          
          FCGesturePasswordController.removeGesturePassword()
          FCUserDefaults.removeObjectForKey(kFCCurrentUserInfo)
      }
}
