//
//  FCMainTabBarController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/4.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCMainTabBarController: UITabBarController {
    
    let tradeVC = FCTradeController()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.isTranslucent = false;
        self.delegate = self
        // Do any additional setup after loading the view.
        self.delegate = self
        
        // 首页
        let homeVC = FCCXPHomeViewController()
        //homeVC.view.backgroundColor = COLOR_BGColor
        addTabItemViewController(itemViewController: homeVC, itemTitle:"首页", normalImg: "homeTabNormal", selectedImg: "homeTabSelect")
        // 行情
        let marketVC = FCMarketViewController()
        addTabItemViewController(itemViewController: marketVC, itemTitle:"行情", normalImg: "marketTabNormal", selectedImg: "marketTabSelect")
        
        // 交易
        addTabItemViewController(itemViewController: tradeVC, itemTitle:"交易", normalImg: "tradeTabNormal", selectedImg: "tradeTabSelect")
        
        // 资产
        //let assetVC = FCUserAssetVC()
        let assetVC = FCCXPAssetController()
        addTabItemViewController(itemViewController: assetVC , itemTitle:"资产", normalImg: "assetTabNormal", selectedImg: "assetTabSelect")
        
        // 我的 tarbar_mineselected
        let mineController = FCMineViewController()
        addTabItemViewController(itemViewController: mineController, itemTitle: "我的", normalImg: "mineTabNormal", selectedImg: "mineTabSelect")
        
        let shadowImg = UIImage.at_image(with: COLOR_tabbarNormalColor, with: CGSize(width:kSCREENWIDTH, height:0.1))
        self.tabBar.shadowImage = shadowImg
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.barTintColor = COLOR_TabBarBgColor
        self.tabBar.tintColor = COLOR_TabBarTintColor
    }
    
    func addTabItemViewController(itemViewController:UIViewController,itemTitle:NSString,normalImg:NSString, selectedImg:NSString) -> () {
        
        let tabNavigationcontroller = PCNavigationController.init(rootViewController: itemViewController)
        let normalImage = UIImage.init(named: normalImg as String)?.withRenderingMode(.alwaysOriginal)
        let selectImage = UIImage.init(named: selectedImg as String)?.withRenderingMode(.alwaysOriginal)
        let tabItem = UITabBarItem.init(title: itemTitle as String, image: normalImage, selectedImage: selectImage)
        itemViewController.tabBarItem = tabItem
        itemViewController.title = itemTitle as String
        self.addChild(tabNavigationcontroller)
    }
    
    func showContractAccount() {
        
        FCUserInfoManager.sharedInstance.loginState { (model) in
            
            self.selectedIndex = 2
            DispatchQueue.main.async {
                
                self.tradeVC.showContractAccount()
            }
        }
    }
    
    func showSpotAccount() {
        
        FCUserInfoManager.sharedInstance.loginState { (model) in
            
            self.selectedIndex = 2
            DispatchQueue.main.async {
                
                self.tradeVC.showSpotAccount()
            }
        }
    }

    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    
}

extension FCMainTabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
    {
        print(viewController)
        let firstController = viewController.children.first
        if (firstController?.isKind(of:FCCXPAssetController.self))! {
            
            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                //触发
                self.selectedIndex = 3
            }
            
            return false
        }
        
        if (self.selectedIndex != 2 && viewController.children.first?.isKind(of: FCTradeController.self) ?? false) {

            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                //触发
                self.selectedIndex = 2
            }
            return false
        }
        
        return true
    }
    
}
