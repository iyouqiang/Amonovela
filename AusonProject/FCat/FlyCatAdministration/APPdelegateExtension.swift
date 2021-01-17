//
//  APPdelegateExtension.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/4.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import Foundation
import IQKeyboardManager
import UIKit

extension AppDelegate {
    
    /**
     接口已放到192.168.0.12
     192.168.0.12 www.fcat.com
     接口调试页面：https://www.fcat.com/index/test/index
     */
    
    public func setupStatusBar () {
        //设置状态栏 
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: false)
    }
    
    public func networkConfigure() {
        
        let config = YTKNetworkConfig.shared()
        config.debugLogEnabled = true
        config.baseUrl = HOSTURL_DOMAIN

        //var commonArguments:[String : String] = [:]
        //if let userId = FCUserInfoManager.sharedInstance.userInfo?.userId {
            //commonArguments = ["userId":userId]
        //}
        //let urlFilter = FCUrlArgumentsFilter.init(arguments: commonArguments)
        //config.addUrlFilter(urlFilter)
    }
    
    // 根视图
    public func launchImagesConfigure() {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.makeKeyAndVisible()
        
        /// 是否有密码
        let mainTabBar = FCMainTabBarController()
        self.tabBarViewController = mainTabBar
        self.window?.rootViewController = mainTabBar
    }
    
    public func appIQKeyboardManagerConfigure() {
        
        IQKeyboardManager.shared().isEnableAutoToolbar = true
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().shouldShowToolbarPlaceholder = false
    }
    
    public func appVersionUpdating()
    {
        /**
         data =     {
             downloadURL = "";
             isForceUpdate = 0;
             needUpdate = 1;
             packageSize = "";
             targetVersion = "";
             updateMsg = "";
         };
         err =     {
             code = 0;
             msg = Success;
             msgDebug = "";
         };
         */
        let updateApi = FCApi_check_update()
        updateApi.startWithCompletionBlock { (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
                       
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                      
                if let data = responseData?["data"] as? [String : Any] {
                    
                    let updateModel = FCAppUpdateModel.stringToObject(jsonData: data)
                    FCUserInfoManager.sharedInstance.updateModel = updateModel
                    
                    if updateModel.needUpdate == true {
                        
                        let updateView = Bundle.main.loadNibNamed("FCVersionUpdatingView", owner: nil, options:     nil)?.first as? FCVersionUpdatingView
                        if updateModel.isForceUpdate == true {
                            updateView?.cancelBtn.isHidden = true
                        }
                        updateView?.updateModel = updateModel
                        
                        let alertView = PCCustomAlert(customCenterPointView: updateView)
                         updateView?.cancelAction = {
                             alertView?.cloasAlertView()
                        
                         }
                        
                        updateView?.updateAction = {
                            
                            alertView?.cloasAlertView()
                            
                            // 调整testflight
                            var jumLink = updateModel.downloadURL ?? ""
                            if jumLink.count == 0 {
                                jumLink = "https://testflight.apple.com/join/v4BgzvMJ"
                            }
                            
                            if #available(iOS 10.0, *){

                                UIApplication.shared.open(URL(string: jumLink)!, options: [:], completionHandler: nil)
                                
                            }  else{

                                UIApplication.shared.openURL(URL(string: jumLink)!)
                            }
                        }
                    }
                }
            }
            
        } failure: { (response) in
            
        }
    }
    
    // 设备信息上报
    public func reportDeviceInfo() {
        
        let member_id = FCUserInfoManager.sharedInstance.userSID;
        let report_deviceInfo = APICommon_report_deviceinfo.init(member_id: member_id)
        report_deviceInfo?.startWithCompletionBlock(success: nil, failure: nil)
    }
    
    public func appConfigInfo() {
        
        let systemConfigApi = FCApi_system_config()
        systemConfigApi.startWithCompletionBlock { (response) in
            
            /// 数据解析
            let responseData = response.responseObject as?  [String : AnyObject]
            if let data = responseData?["data"] as? [String : AnyObject] {
                UserDefaults.standard.set(data, forKey: "SystemConfigKEY")
                UserDefaults.standard.synchronize()
                let configModel = FCSystemConfigModel.init(dict: data)
                FCUserInfoManager.sharedInstance.configModel = configModel
            }
            
        } failure: { (response) in
            
            let systemConfigData = UserDefaults.standard.object(forKey: "SystemConfigKEY")
            
            if let data = systemConfigData as? [String : AnyObject] {
                
                UserDefaults.standard.set(data, forKey: "SystemConfigKEY")
                UserDefaults.standard.synchronize()
                let configModel = FCSystemConfigModel.init(dict: data)
                FCUserInfoManager.sharedInstance.configModel = configModel
            }
        }
    }
    
    // Bugly
    public func configureBugly() {
        
        var appId = ""
        #if DEBUG //
        
        appId = ""
        #else
       
        appId = "6d68e221c7"
        
        #endif
        Bugly.start(withAppId: appId)
    }
    
    // 初始化数据字典服务
    public func initDictionayService () {
        FCDictionaryService.sharedInstance.fetchCountryCodeList()
    }
    
}
