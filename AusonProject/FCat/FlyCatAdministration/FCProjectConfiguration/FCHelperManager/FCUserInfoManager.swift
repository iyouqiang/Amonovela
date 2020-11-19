//
//  FCUserInfoManager.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

open class FCUserInfoManager: NSObject {
    
    @objc static let sharedInstance = FCUserInfoManager()
    
    @objc var userSID: String?
    
    /// 登录态判断 使用 loginState
    @objc var isLogin = false
    @objc var isGestureVerify = false
    @objc var userId: String?
    @objc var userInfo: FCUserInfoModel?
    
    override public init() {
        super.init()
        self.isLogin = false
        self.userInfo = self.getUserInfo()
        
        /// 保持登录状态
        if self.userInfo != nil {
            self.isLogin = true
        }
    }
    
    /// 登录状态判断
    func loginState(_ loginStateBlock: @escaping (_ userInfoModel: FCUserInfoModel) -> Void) {
        
        /// 是否有登录手势
        let hasGpassword = FCGesturePasswordController.verifiedGesturePassword()
        
        if (hasGpassword) {
            /// 存在手势密码
            if self.isLogin {
                
                if (self.isGestureVerify) {
                    /// 手势已经验证
                    loginStateBlock(self.userInfo!)
                }else {
                    /// 手势未验证
                    FCGesturePasswordController.showGesturePasswordView { (isDone) in
                        if isDone {
                                           
                            self.isGestureVerify = true
                            loginStateBlock(self.userInfo!)
                        }
                    }
                }
                
            }else {
                
                // 弹出登录界面
                FCLoginViewController.showLogView { (model) in
                               
                    loginStateBlock(model)
                }
            }
            
        }else {
            /// 不存在手势密码
            if self.isLogin {
                
                loginStateBlock(self.userInfo!)
            }else {
               
                // 弹出登录界面
                FCLoginViewController.showLogView { (model) in
                               
                    loginStateBlock(model)
                }
            }
        }
    }
    
    func saveUserInfo (_ userInfo: [String : Any]) {
        
        self.isLogin = true
        self.userInfo = FCUserInfoModel.stringToObject(jsonData: userInfo)
        
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
        
        self.isLogin = false
        self.userInfo = nil
        FCGesturePasswordController.removeGesturePassword()
        FCUserDefaults.removeObjectForKey(kFCCurrentUserId)
        FCUserDefaults.removeObjectForKey(kFCCurrentUserInfo)
    }
}
