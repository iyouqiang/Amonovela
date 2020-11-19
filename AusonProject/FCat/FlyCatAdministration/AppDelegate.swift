//
//  AppDelegate.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/4.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    @objc var tabBarViewController:FCMainTabBarController!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        // 设置状态栏
        self.setupStatusBar()
        
        // 网络数据配置
        self.networkConfigure()
        
        //初始化数据字典服务
        self.initDictionayService()
        
        // 根视图入口
        self.launchImagesConfigure()
        
        // 键盘配置
        self.appIQKeyboardManagerConfigure()
        
        // 上传设备信息
        self.reportDeviceInfo()
        
        //bugly配置
        self.configureBugly()
        
        // 第一次启动 小额资产赋值为yes
        if !FCUserDefaults.boolForKey(kAPPFIRSTLAUNCH) {
         
            FCUserDefaults.setBool(true, ForKey: kAPPFIRSTLAUNCH, synchronize: true)
            FCUserDefaults.setBool(true, ForKey: kSMALLASSETS, synchronize: true)
        }
        
        return true
    }
    
    public func text(){
        
    }
    
 @objc var topViewController:UIViewController? {
        
        get {

            var topVC = self.tabBarViewController.selectedViewController
            
            if ((self.tabBarViewController.presentedViewController) != nil) {
                topVC = self.tabBarViewController.presentedViewController
            }
            
            if (topVC!.isKind(of: UINavigationController.self)) {
                
                topVC = (topVC as! UINavigationController).topViewController
            }
            

            return topVC
        }
        
        set {
            
            self.topViewController = newValue
        }
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
       return true
    }

    private func application(_ app: UIApplication, open url: URL, options: [String : Any] = [:]) -> Bool {
     
            return true
    }
        
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

