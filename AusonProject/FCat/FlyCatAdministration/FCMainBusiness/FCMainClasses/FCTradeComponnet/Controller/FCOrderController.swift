
//
//  FCOrderController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/9.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu
import JXSegmentedView

class FCOrderController: UIViewController {
    
    let disposeBag = DisposeBag()
    var priceSubscription: Disposable?
    var depthSubscription: Disposable?
    
    var marketModel: FCMarketModel?
    var orderView: FCSpotOrderView?
    var leftVC: FCSymbolsDrawerController = FCSymbolsDrawerController()
    var leftSideMenuManager: SideMenuManager = SideMenuManager()
    
    var tradeAsset: FCAssetModel?  //交易币资产
    var baseAsset: FCAssetModel? //基础币资产
    var didSelectItem: ((FCMarketModel) -> Void)?
    var leftMenuItemBlock:((_ leftSideMenuManager: SideMenuManager) -> Void)?
    //var leftMenuItemBlock:(() -> Void)?
    var klineViewItemBlock:(() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //pollingPrice()
        //pollingDepth()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //priceSubscription?.dispose()
        //depthSubscription?.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        view.backgroundColor = COLOR_BGColor
        self.view.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: kSCREENHEIGHT-kNAVIGATIONHEIGHT-kTABBARHEIGHT - 50)
        self.loadSubviews()
        
        //弹出抽屉
        self.loadDrawer()
        
        FCTradeSettingconfig.sharedInstance.symbol = self.marketModel?.symbol
        
        // 默认线先加载一次数据
        self.fetchPriceData()
        self.fetchRestDatas()
        
        /// 轮询
        pollingPrice()
        pollingDepth()
        
        //Action
        self.handleKlineButtonAction()
        self.handleOrderButtonAction()
    }
    
    func updateSymbol (model: FCMarketModel?) {
        
        self.marketModel = model
        
        // 切换交易对，先获取一次资产
        self.fetchAsset()
        self.fetchPriceData()
        
        //轮询
        self.pollingPrice()
        self.pollingDepth()
    }
    
    func pollingPrice () {
        // 定时轮询最新价
        self.priceSubscription?.dispose()
        
        self.priceSubscription = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
            .subscribe {[weak self] (num) in
                self?.fetchPriceData()
                
                /// 资产轮询
                self?.fetchAsset()
        }
        
        self.priceSubscription?.disposed(by: self.disposeBag)
    }
    
    func pollingDepth () {
        self.depthSubscription?.dispose()
        self.depthSubscription = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
            .subscribe {[weak self] (num) in
                self?.fetchRestDatas()
        }
        self.depthSubscription?.disposed(by: self.disposeBag)
    }
    
    // 价格
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
    
    // 深度
    func fetchRestDatas () {
        //let restApi = FCApi_ticker_depth.init(symbol: self.marketModel?.symbol ?? "", step: "step0")
        let restApi = FCApi_spot_market_depth(symbol: self.marketModel?.symbol ?? "", step: "step0")
        restApi.startWithCompletionBlock(success: { (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                let depthModel = FCKLineRestingModel.stringToObject(jsonData: responseData?["data"] as? [String : Any])
                self.orderView?.loadDethDatas(depthModel: depthModel)
            } else{
                let errMsg = responseData?["err"]?["msg"] as? String
                self.view.makeToast(errMsg ?? "", position: .center)
            }
            
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    func setSelectedAction()
    {
        leftVC.didSelectItem = nil
        leftVC.didSelectItem { [weak self] (model) in
        self?.marketModel = model
        self?.leftVC.dismiss(animated: true, completion: nil)
        self?.updateSymbol(model: model)
        self?.didSelectItem?(model)
        //FCTradeSettingconfig.sharedInstance.symbol = model.symbol
        }
    }
    
    // 当前币种资产
    func fetchAsset () {
        if FCUserInfoManager.sharedInstance.isLogin == false {
            return
        }
        
        if self.marketModel?.symbol?.count == 0 {
            return
        }
        
        let assetApi = FCApi_symbol_asset.init(symbol: self.marketModel?.symbol ?? "")
        assetApi.startWithCompletionBlock(success: { (response) in
            
            FCNetworkUtils.handleResponse(response: response, success: { [weak self] (resData) in

                let assets = resData?["assets"] as? Array<Any>
                self?.tradeAsset = FCAssetModel.stringToObject(jsonData: assets?.first as? [String : Any] )
                self?.baseAsset = FCAssetModel.stringToObject(jsonData: assets?.last as? [String : Any] )
                self?.orderView?.loadAssetsData(tradeAsset: self?.tradeAsset, baseAsset: self?.baseAsset)
            }) { (errMsg) in
                self.view.makeToast(errMsg, position: .center)
            }
            
        }) { (response) in
            
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    func placeOrder(price: String, amount: String, orderType: String, markerSide: String, volumeType: String) {
        let api = FCApi_place_order.init(symbol: self.marketModel?.symbol ?? "", price: price, volume: amount, orderType: orderType, markerSide: markerSide, volumeType: volumeType)
        api.startWithCompletionBlock(success: { [weak self] (response) in
            
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                 self?.view.makeToast("下单成功", position: .center)
            }) { (errMsg) in
                self?.view.makeToast(errMsg, position: .center)
            }
            
            self?.fetchAsset()

        }) { (response) in
             //self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    // 跳转到k线页面
    func handleKlineButtonAction() {
        self.orderView?.klineBtn.rx.tap.subscribe({[weak self](event) in
            
            if let klineViewItemBlock = self?.klineViewItemBlock {
                           
                klineViewItemBlock()
            }
            
        }).disposed(by: self.disposeBag)
    }
    
    // 下单按钮
    func handleOrderButtonAction () {
        
        self.orderView?.placeOrder = {[weak self] (price: String, amount: String, orderType: String, markerSide: String, volumeType: String) -> Void in
            self?.placeOrder(price: price, amount: amount, orderType: orderType, markerSide: markerSide, volumeType: volumeType)
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
        
        let leftMenu = UISideMenuNavigationController.init(rootViewController: self.leftVC)
        leftMenu.view.backgroundColor = COLOR_BGColor
        leftMenu.isNavigationBarHidden = false
        leftSideMenuManager.menuLeftNavigationController = leftMenu
        
        leftVC.didSelectItem { [weak self] (model) in
            self?.marketModel = model
            self?.leftVC.dismiss(animated: true, completion: nil)
            self?.updateSymbol(model: model)
            self?.didSelectItem?(model)
        }
        
        self.orderView?.symbolBtn.rx.tap.subscribe({[weak self] (event) in
            
            if let leftMenuItemBlock = self?.leftMenuItemBlock {
                
                leftMenuItemBlock(leftSideMenuManager)
            }
            
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
        self.orderView = FCSpotOrderView.init(frame: CGRect.zero)
        self.view.addSubview(self.orderView!)
        self.orderView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
    }
    
    func getSectionHeader () -> UIView{
        let header = UIView.init(frame: CGRect.zero)
        header.backgroundColor = COLOR_SectionFooterBgColor
        return header
    }
    
}

extension FCOrderController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
