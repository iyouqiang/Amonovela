
//
//  FCTreatyOrderController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/31.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu
import JXSegmentedView

class FCTreatyOrderController: UIViewController {
    
    let disposeBag = DisposeBag()
    var priceSubscription: Disposable?
    var depthSubscription: Disposable?
    var orderApi: FCApi_trigger_order_place?
    var marketModel: FCMarketModel?
    var contractModel: FCContractsModel?
    var orderView: FCContractOrderView?
    var leftVC: FCContractListController = FCContractListController()
    var leftSideMenuManager: SideMenuManager = SideMenuManager()
    
    var tradeAsset: FCAssetModel?  //交易币资产
    var baseAsset: FCAssetModel? //基础币资产

    var precision: String?
    var leftMenuItemBlock:((_ leftSideMenuManager: SideMenuManager) -> Void)?
    var klineViewItemBlock:(() -> Void)?
    var contractSetItemBlock: (() -> Void)?
    var didSelectItem: ((FCMarketModel) -> Void)?
    
    var accountInfoModel: FCPositionAccountInfoModel? {
        
        didSet {
            guard  let accountInfoModel = accountInfoModel else {
                return
            }
            
            self.orderView?.loadAssetsData(accountInfoModel: accountInfoModel)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        //adjuestInsets()
        
        view.backgroundColor = COLOR_BGColor
        self.view.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: kSCREENHEIGHT-kNAVIGATIONHEIGHT-kTABBARHEIGHT - 50)
        self.loadSubviews()
        
        //弹出抽屉
        self.loadDrawer()
        
        FCTradeSettingconfig.sharedInstance.symbol = self.marketModel?.symbol
        
        //Action
        self.handleKlineButtonAction()
        self.handleLeverageAction()
        self.handleOrderButtonAction()
    }
    
    func updateSymbol (model: FCMarketModel?) {
        
        /// 初始化数据
        self.marketModel = model
        self.orderView?.marketModel = model
        self.orderView?.amountTxd.text = ""
        
        if self.marketModel?.isOptional == true {
            self.orderView?.dropMoreSettingDown.dataSource = ["  合约设置  ", "  删除自选  "]
        }else {
            
            self.orderView?.dropMoreSettingDown.dataSource = ["  合约设置  ", "  添加自选  "]
        }
        
        // 获取资产
        self.fetchAsset()
        // 获取价格数据
        //self.fetchPriceData()
        /// 获取单个合约书籍
        self.fetchContractInfo()
        /// 获取合约策略
        self.fetchContractSettingConfig()
        
        //轮询
        //self.pollingPrice()
        self.pollingDepth()
    }
    
    /**
    func pollingPrice () {
        // 定时轮询最新价
        self.priceSubscription?.dispose()
        self.priceSubscription = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
            .subscribe {[weak self] (num) in
                self?.fetchPriceData()
        }
        self.priceSubscription?.disposed(by: self.disposeBag)
    }
     */
    
    func pollingDepth () {
        self.depthSubscription?.dispose()
        self.depthSubscription = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
            .subscribe {[weak self] (num) in
                self?.fetchContractDatas()
        }
        self.depthSubscription?.disposed(by: self.disposeBag)
    }
    
    /**
    func fetchPriceData () {
        let priceApi = FCApi_tickers_latest.init(symbol: self.marketModel?.symbol ?? "")
        priceApi.startWithCompletionBlock(success: { (response) in
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                let data = responseData?["data"] as? [String: AnyObject]
                self.marketModel =  FCMarketModel.stringToObject(jsonData: data?["ticker"] as? [String : Any])
                //刷新UI
                self.orderView?.loadMarketModel(model: self.marketModel)
            } else{
                let errMsg = responseData?["err"]?["msg"] as? String
                self.view.makeToast(errMsg ?? "", position: .center)
            }
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
     */
    
    // 深度
    func fetchContractDatas () {
        
        var tradingUnit = "CONT"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit != .TradeTradingUnitType_CONT {
                tradingUnit = "COIN"
        }
        
        if precision == nil {
            guard let defaultPrecision = self.contractModel?.defaultPrecision else {
                return
            }
            precision = defaultPrecision
        }
        
        let depthApi = FCApi_quote_market_feed(tradingUnit: tradingUnit, symbol: self.marketModel?.symbol ?? "", precision: precision ?? "")
            depthApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                let depthModel = FCKLineRestingModel.stringToObject(jsonData: responseData?["data"] as? [String : Any])
                self?.orderView?.loadDepthDatas(depthModel: depthModel)
                
            } else{
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (reponse) in
            
        }
    }
    
    func fetchContractSettingConfig() {
        
        FCTradeSettingconfig.sharedInstance.loadSettingCofig(symbol: self.marketModel?.symbol ?? "") { (model, errmsg) in
            
            /// 仓位模式 杠杆倍数
            if errmsg.count > 0 {
                self.view.makeToast(errmsg)
                return
            }
            self.orderView?.strateSetModel = model
        }
    }
    
    /// 获取单个合约数据
    func fetchContractInfo() {
        
        // Perpetual
        
        let contractInoApi = FCApi_quote_one_contract(tradingUnit: FCTradeSettingconfig.sharedInstance.tradingUnitStr, symbol: self.marketModel?.symbol ?? "")
        contractInoApi.startWithCompletionBlock(success: { [weak self] (response) in
        
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] as? [String : Any] {
                    
                    if let accounts = data["contract"] as? [String : AnyObject] {
                        
                        let contractModel = FCContractsModel(dict: accounts)
                        self?.contractModel = contractModel
                        self?.marketModel?.tradingType = contractModel.tradingType ?? "Perpetual"
                        self?.marketModel?.isOptional = contractModel.isOptional
                        self?.orderView?.contractModel = contractModel
                        self?.fetchContractDatas()
                    }
                }
            }
        }) { (response) in
            
        }
    }
    
    // 当前币种资产
    func fetchAsset () {
        
        //FCApi_Contract_asset
        
        let userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
        
        if userId.count == 0 {
            return
        }
        
        var tradingUnit = "COIN"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            
            tradingUnit = "CONT"
        }
        
        let accountApi = FCApi_Contract_asset(symbol: self.marketModel?.symbol ?? "", tradingUnit: tradingUnit)
        
        accountApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] as? [String : AnyObject] {
                    
                    let accountModel = FCPositionAccountInfoModel(dict: data)
                    self?.accountInfoModel = accountModel
                    //self?.orderView?.loadAssetsData(accountInfoModel: self?.accountInfoModel)
                }
            }
            
        }) { (response) in
            
            print(response.error ?? "")
        }
    }
    
    /// 计划委托下单
    func triggerOrderPlace(tradingUnit: String, entrustVolume: Float, entrustPrice: Float, side: String, action: String, tradeType: String, volumeType: String, triggerSource: String, triggerPrice: String, stopLossPrice: String,takeProfitPrice: String, positionId: String)
    {
        if ((orderApi?.isExecuting) != nil) {
            return
        }
        orderApi = FCApi_trigger_order_place(symbol: self.marketModel?.symbol ?? "", action: action, side: side, triggerSource: triggerSource, triggerPrice: triggerPrice, stopLossPrice: stopLossPrice, takeProfitPrice: takeProfitPrice, entrustVolume: entrustVolume, entrustPrice: entrustPrice, tradeType: tradeType, volumeType: volumeType, tradingUnit: tradingUnit, positionId: positionId)
        
        orderApi?.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                self?.view.makeToast("下单成功", position: .center)
                
            }else {
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    /// 合约下单
    func placeOrder(tradingUnit: String, entrustVolume: String, entrustPrice: String, side: String, action: String, tradeType: String, volumeType: String, triggerClose:[String:Any]) {
        
        let api = FCApi_trade_order_place(symbol: self.marketModel?.symbol ?? "", tradingUnit: tradingUnit, entrustVolume: entrustVolume, entrustPrice: entrustPrice, side: side, action: action, tradeType: tradeType, volumeType: volumeType,triggerClose: triggerClose)
        
        api.startWithCompletionBlock(success: { (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                self.view.makeToast("下单成功", position: .center)
                
            }else {
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    // 跳转到k线页面
    func handleKlineButtonAction() {
        self.orderView?.klineBtn.rx.tap.subscribe({[weak self](event) in
            
            if let klineViewItemBlock = self?.klineViewItemBlock {
                
                klineViewItemBlock()
            }
            /**
             let klineVC = FCKLineController()
             let marketModel = self?.marketModel
             klineVC.marketModel = marketModel
             klineVC.hidesBottomBarWhenPushed = true
             
             
             //            let myDelegate = UIApplication.shared.delegate as? AppDelegate
             //            myDelegate?.tabBarViewController.selectedIndex = 1
             //            let navVC = myDelegate?.tabBarViewController.selectedViewController as? PCNavigationController
             //            navVC?.pushViewController(klineVC, animated: true)
             
             self?.navigationController?.pushViewController(klineVC, animated: true)
             */
            
        }).disposed(by: self.disposeBag)
        
        self.orderView?.ktradeSettingBtn.rx.tap.subscribe({[weak self](event) in
            
            self?.orderView?.dropMoreSettingDown.show()
            
            /**
             let settingVC = FCPerpetualContractSetController()
             settingVC.marketModel = self?.marketModel
             settingVC.hidesBottomBarWhenPushed = true
             self?.navigationController?.pushViewController(settingVC, animated: true)
             */
            
        }).disposed(by: self.disposeBag)
        
        /// 设置精度
        self.orderView?.accuracyViewDropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.orderView?.accuracyBtn.setTitle(item, for: .normal)
            self?.precision = item
        }
        
        /// 合约设置
        self.orderView?.dropMoreSettingDown.selectionAction = { [weak self] (index: Int, item: String) in
            
            if index == 0 {
                
                /// 合约设置
                if let contractSetItemBlock = self?.contractSetItemBlock {
                    
                    contractSetItemBlock()
                }
            }else {
                
                /// 添加自选 
                
                //PCCustomAlert.showAppInConstructionAlert()
                
                if self?.marketModel?.isOptional == true {
                    
                    self?.deleteOptonal()
                }else {
                    
                    self?.addOptional()
                }
            }
        }
    }
    
    func addOptional() {
        
        let addApi = FCApi_swap_add_optional.init(symbol: self.marketModel?.symbol ?? "")
         addApi.startWithCompletionBlock(success: { (response) in
             let responseData = response.responseObject as?  [String : AnyObject]
            
             if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                 
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavorite), object: nil)
                self.marketModel?.isOptional = true
                self.view.makeToast("添加自选成功", position: .center)
                
                self.orderView?.dropMoreSettingDown.dataSource = ["  合约设置  ", "  删除自选  "]
             } else{
                 let errMsg = responseData?["err"]?["msg"] as? String
                self.view.makeToast(errMsg ?? "", position: .center)
             }
             
         }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
         }
    }
    
    func deleteOptonal() {
        
        /// 登录后操作自选
        let deleteApi = FCApi_swap_detele_optional(symbol: self.marketModel?.symbol ?? "")
        deleteApi.startWithCompletionBlock(success: { (response) in
            let responseData = response.responseObject as?  [String : AnyObject]
        
            if response.responseCode == 0 {
                
                self.marketModel?.isOptional = false
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavorite), object: nil)
                self.orderView?.dropMoreSettingDown.dataSource = ["  合约设置  ", "  添加自选  "]
                self.view.makeToast("删除自选成功", position: .center)
            } else{
                let errMsg = responseData?["err"]?["msg"] as? String
                self.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    // 杠杆按钮
    func handleLeverageAction () {
        self.orderView?.leverageBtn.rx.tap.subscribe({ (event) in
            let leverageVC = FCContractLeverageController()
            self.navigationController?.pushViewController(leverageVC, animated: true)
            
        }).disposed(by: self.disposeBag)
    }
    
    // 下单按钮
    func handleOrderButtonAction () {
        
        /// 计划委托
        self.orderView?.triggerOrderPlaceBlock = {
            [weak self] (tradingUnit, entrustVolume, entrustPrice, side, action, tradeType, volumeType , triggerSource,  triggerPrice, stopLossPrice, takeProfitPrice, positionId) -> Void in
            self?.triggerOrderPlace(tradingUnit: tradingUnit, entrustVolume: entrustVolume, entrustPrice: entrustPrice, side: side, action: action, tradeType: tradeType, volumeType: volumeType, triggerSource: triggerSource, triggerPrice: triggerPrice, stopLossPrice: stopLossPrice, takeProfitPrice: takeProfitPrice, positionId: positionId)
        }
        
        /// 合约下单
        self.orderView?.placeOrder = {[weak self] (tradingUnit: String, entrustVolume: String, entrustPrice: String, side: String, action: String, tradeType: String, volumeType: String, triggerClose:[String:Any]) -> Void in
            self?.placeOrder(tradingUnit: tradingUnit, entrustVolume: entrustVolume, entrustPrice: entrustPrice, side: side, action: action, tradeType: tradeType, volumeType: volumeType, triggerClose: triggerClose)
        }
    }
    
    func loadDrawer () {
        
        // 左侧菜单控制器
        let leftSideMenuManager = SideMenuManager()
        self.leftSideMenuManager = leftSideMenuManager
        leftSideMenuManager.menuPresentMode = .menuSlideIn
        leftSideMenuManager.menuBlurEffectStyle = .dark
        leftSideMenuManager.menuAnimationUsingSpringWithDamping = 0.8
        leftSideMenuManager.menuAnimationInitialSpringVelocity = 0.05
        leftSideMenuManager.menuAnimationFadeStrength = 0.5
        leftSideMenuManager.menuAnimationBackgroundColor = COLOR_BGColor
        leftSideMenuManager.menuShadowOpacity = 0.8
        leftSideMenuManager.menuFadeStatusBar = false
        //leftSideMenuManager.menuWidth = 280
        let leftMenu = UISideMenuNavigationController.init(rootViewController: self.leftVC)
        leftMenu.view.backgroundColor = COLOR_BGColor
        leftMenu.isNavigationBarHidden = false
        leftSideMenuManager.menuLeftNavigationController = leftMenu
        
        leftVC.didSelectItem { [weak self] (model) in
            
            /// 此处 model 类型切换 contractModel --> marketModel
            // 修复
            self?.contractModel = model
            self?.marketModel = FCMarketModel()
            self?.marketModel?.symbol = model.symbol
            self?.marketModel?.tradingType = model.tradingType ?? "Perpetual"
            self?.marketModel?.asset = model.asset ?? ""
            self?.marketModel?.size = model.size ?? ""
            self?.marketModel?.isOptional = model.isOptional
            self?.leftVC.dismiss(animated: true, completion: nil)
            self?.updateSymbol(model: self?.marketModel)
            self?.didSelectItem?(self?.marketModel ?? FCMarketModel())
            FCTradeSettingconfig.sharedInstance.symbol = model.symbol
        }
        
        /**
         SideMenuManager.default.menuLeftNavigationController = UISideMenuNavigationController.init(rootViewController: self.leftVC)
         SideMenuManager.default.menuWidth = 280
         leftVC.didSelectItem { [weak self] (model) in
         self?.marketModel = model
         self?.leftVC.dismiss(animated: true, completion: nil)
         self?.updateSymbol(model: model)
         self?.didSelectItem?(model)
         FCTradeSettingconfig.sharedInstance.symbol = model.symbol
         }
         */
        
        self.orderView?.symbolBtn.rx.tap.subscribe({[weak self] (event) in
            
            if let leftMenuItemBlock = self?.leftMenuItemBlock {
                
                leftMenuItemBlock(leftSideMenuManager)
            }
            
            /**
             if let menu = SideMenuManager.default.menuLeftNavigationController {
             self?.present(menu , animated: true, completion: nil)
             }
             */
        }).disposed(by: self.disposeBag)
    }
    
    
    func loadSubviews () {
        self.loadSectionHeader()
        self.loadPlaceOerderView()
    }
    
    func loadSectionHeader () {
        let header = self.getSectionHeader()
        self.view.addSubview(header)
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
    }
    
    func loadPlaceOerderView () {
        self.orderView = FCContractOrderView.init(frame: CGRect.zero)
        self.view.addSubview(self.orderView!)
        self.orderView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    func getSectionHeader () -> UIView{
        let header = UIView.init(frame: CGRect.zero)
        header.backgroundColor = COLOR_SectionFooterBgColor
        return header
    }
}

extension FCTreatyOrderController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
