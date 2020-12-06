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
    let itemWidth = kSCREENWIDTH/5.0
    var lastTabItem: UITabBarItem?
    
    lazy var itemCapView: UIView = {
        //UIFont.systemFont(ofSize: <#T##CGFloat#>)
        //UIFont(_customTypeSize: <#T##CGFloat#>)
        let view = UIView(frame: CGRect(x: (itemWidth - 60)/2.0, y: -15, width: 60, height: 60))
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.backgroundColor = COLOR_TabBarBgColor
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.addSubview(self.itemCapView)
        
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
        
        if itemTitle == "首页" {
            self.lastTabItem = tabItem
            tabItem.imageInsets = UIEdgeInsets(top: -5, left: 0, bottom: 5, right: 0)
        }
        
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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        
            UIView.animate(withDuration: 0.2) {

            }
        
        self.lastTabItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        let offsetX = CGFloat(self.selectedIndex) * self.itemWidth + (self.itemWidth - 60)/2.0
        self.itemCapView.frame = CGRect(x: offsetX, y: -15, width: 60, height: 60)
        
        self.tabBar.selectedItem?.imageInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: 0)
        self.lastTabItem = self.tabBar.selectedItem
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool
    {
        let firstController = viewController.children.first
        if (firstController?.isKind(of:FCCXPAssetController.self))! {
            
            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                //触发
                self.lastTabItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.selectedIndex = 3
                let offsetX = CGFloat(self.selectedIndex) * self.itemWidth + (self.itemWidth - 60)/2.0
                self.itemCapView.frame = CGRect(x: offsetX, y: -15, width: 60, height: 60)
                self.lastTabItem = self.tabBar.items?[3]
                self.lastTabItem?.imageInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: 0)
            }
            
            return false
        }
        
        if (self.selectedIndex != 2 && viewController.children.first?.isKind(of: FCTradeController.self) ?? false) {

            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                //触发
                self.lastTabItem?.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
                self.selectedIndex = 2
                let offsetX = CGFloat(self.selectedIndex) * self.itemWidth + (self.itemWidth - 60)/2.0
                self.itemCapView.frame = CGRect(x: offsetX, y: -15, width: 60, height: 60)
                self.lastTabItem = self.tabBar.items?[2]
                self.lastTabItem?.imageInsets = UIEdgeInsets(top: -8, left: 0, bottom: 8, right: 0)
                
            }
            return false
        }
        
        return true
    }
    
}
