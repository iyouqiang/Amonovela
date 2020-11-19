
//
//  FCKLineController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
//import Toast_Swift
import RxSwift
import RxCocoa
import SideMenu
import KLineXP

class FCKLineController: UIViewController {
    
    let disposeBag = DisposeBag()
    let klineCharView = KLineChartView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 450))
    let klinePeriodView = KLinePeriodView.linePeriodView()
    
    var marketModel: FCMarketModel?
    var optionalRefreshBlock: kFCBlock?
    var optionalBtn: UIButton?
    var scrollView: UIScrollView?
    var klineHeaderView: FCKLineHeaderView?
    var currentSubscription: Disposable?
    var restSubscription: Disposable?
    var dealSubscription: Disposable?
    var accountType: TradingAccountType = .tradingAccountType_spot
    //var accountType: TradingAccountType = .tradingAccountType_swap
    ///"tradingType":" Spot是现货，Perpetual是永续
    var leftVC: FCSymbolsDrawerController = FCSymbolsDrawerController()
    var congractListVC: FCContractListController = FCContractListController()
    var leftSideMenuManager: SideMenuManager = SideMenuManager()
    
    // 这个是marketType，不要用这个来判断跳转到币币交易还是永续交易，因为这个是某种归类而已，有可能永续合约和精选合约都是永续，自选里面的品种可以则可能包含现货和永续，所有需要这么一个tradingType
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_BGColor
        
        // ⚠️ k线历史 最新一根k线 深度 成交 自选 均有 合约swap 和 现货 spot 两个接口数据
        
        //Spot是现货，Perpetual是永续
        self.accountType = self.marketModel?.tradingType == "Perpetual" ? .tradingAccountType_swap : .tradingAccountType_spot
        
        if self.accountType == .tradingAccountType_swap {
            self.buyBtn.setTitle("开多", for: .normal)
            self.sellBtn.setTitle("开空", for: .normal)
        }
        
        // Do any additional setup after loading the view.
        self.loadDrawer()
        //self.adjuestInsets()

        /// 界面初始化布局
        self.loadSubviews()
        
        /// 合约类型 现货 合约
        KLineHTTPTool.tool.accountType = self.accountType
        KLineRequestTool.tool.delegate = KLineHTTPTool.tool
        
        //指定管理者并获取默认K线
        KLineStateManger.manager.klineChart = klineCharView
        
        /// 加载初始化k线数据
        self.loadKLineData()

        //委托和成交
        self.fetchRestDatas()
        self.fetchDealDatas()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.cancelPolling()
    }
    
    func reloadSubViewsWhenChangeSymbol () {
    
        //先重置导航按钮
        self.loadCustomNavigatonBar()
        
        //取消轮询
        self.cancelPolling()
        
        //更新Header和K线视图的数据
        self.klineHeaderView?.loadLastMarketData(model: self.marketModel)
        self.loadKLineData()
        
        //委托和成交
        self.fetchRestDatas()
        self.fetchDealDatas()
        
        //简介
    }
    
    func cancelPolling () {
        KLineStateManger.manager.cancelPolling()
        self.currentSubscription?.dispose()
        self.restSubscription?.dispose()
        self.dealSubscription?.dispose()
    }
    
    func loadDrawer () {
        
        if self.accountType == .tradingAccountType_spot {
            
            SideMenuManager.default.menuLeftNavigationController = UISideMenuNavigationController.init(rootViewController: self.leftVC)
            
            let leftSideMenuManager = SideMenuManager.default
            leftSideMenuManager.menuPresentMode = .menuSlideIn
            leftSideMenuManager.menuAnimationFadeStrength = 0.5
            leftSideMenuManager.menuAnimationBackgroundColor = COLOR_BGColor
            
            leftVC.didSelectItem { [weak self] (model) in
                self?.marketModel = model
                self?.leftVC.dismiss(animated: true, completion: nil)
                self?.reloadSubViewsWhenChangeSymbol()
            }
            
            return
        }
        
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
        let leftMenu = UISideMenuNavigationController.init(rootViewController: self.congractListVC)
        leftMenu.isNavigationBarHidden = false
        leftSideMenuManager.menuLeftNavigationController = leftMenu
        leftMenu.view.backgroundColor = COLOR_BGColor
        congractListVC.didSelectItem { [weak self] (model) in
            
            /// 此处 model 类型切换 contractModel --> marketModel
            //let contractModel = model
            self?.marketModel = FCMarketModel()
            self?.marketModel?.symbol = model.symbol
            self?.marketModel?.tradingType = model.tradingType ?? ""
            self?.marketModel?.isOptional = model.isOptional
            self?.congractListVC.dismiss(animated: true, completion: nil)
            self?.reloadSubViewsWhenChangeSymbol()
            //self?.updateSymbol(model: self?.marketModel)
            //self?.didSelectItem?(self?.marketModel ?? FCMarketModel())
            //FCTradeSettingconfig.sharedInstance.symbol = model.symbol
        }
    }
    
    func loadSubviews () {
        
        loadCustomNavigatonBar()
        loadScrollView()
        loadHeaderView()
        loadKLineChart()
        loadBottomView()
        laodTradeButtons()
    }
    
    func loadCustomNavigatonBar () {
        
        //切换交易对时先重置
        self.removeLeftItems()
        self.removeRightItems()
        
        weak var weakSelf = self
        self.addmutableleftNavigationItemImgNameStr("navbar_back", title: nil, textColor: nil, textFont: nil) {
            weakSelf?.navigationController?.popViewController(animated: true)
        }
        
        var drawerTitle = ("  "   + (self.marketModel?.symbol ?? "")).replacingOccurrences(of: "-", with: "/")
        
        if self.marketModel?.name.count != 0 {
            drawerTitle = "  " + (self.marketModel?.name ?? "")
        }
        
        self.addmutableleftNavigationItemImgNameStr("kline_drawer", title: drawerTitle, textColor:.white, textFont: UIFont.systemFont(ofSize: 17)) {[weak self] in
            
            if self?.accountType == .tradingAccountType_spot {
               
                self?.leftVC.fetchQuoteTypes()
                if let menu = SideMenuManager.default.menuLeftNavigationController {
                    self?.present(menu , animated: true, completion: nil)
                }
                return
            }
            
            if let menu = self?.leftSideMenuManager.menuLeftNavigationController {
                
                self?.congractListVC.fetchQuoteTypes()
                self?.present(menu , animated: true, completion: nil)
            }
        }
        
        //var imgBtn = UIImage(named: "fav_normal")
        //imgBtn = imgBtn?.imageWithTintColor(color: COLOR_HexColor(0x58595C))
        self.optionalBtn = UIButton(type: .custom)
        self.optionalBtn?.setImage(UIImage(named: "fav_normal"), for: .normal)
        self.optionalBtn?.setImage(UIImage(named: "fav_selected"), for: .selected)
        self.optionalBtn?.isSelected = self.marketModel?.isOptional ?? false
        self.optionalBtn?.rx.tap.subscribe({[weak self]  (event) in
            if self?.optionalBtn?.isSelected ?? false {
                self?.removeSymbolFromFavorite()
            } else {
                self?.addSymbolToFavorite()
            }
        }).disposed(by: self.disposeBag)
        
        let rightBarItem = UIBarButtonItem.init(customView: self.optionalBtn!)
        self.navigationItem.rightBarButtonItem = rightBarItem
    }
    
    func loadScrollView () {
        self.scrollView = UIScrollView.init(frame: .zero)
        self.scrollView?.showsHorizontalScrollIndicator = false
        self.scrollView?.showsVerticalScrollIndicator = true
        self.scrollView?.bounces = true
        self.scrollView?.isScrollEnabled = true
        self.view.addSubview(self.scrollView!)
        
        self.klineCharView.panGesture.delegate = self
        
        self.scrollView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
    }
    
    func loadHeaderView () {
        self.klineHeaderView = FCKLineHeaderView.init(frame: .zero)
        self.scrollView?.addSubview(self.klineHeaderView!)
        self.klineHeaderView?.loadLastMarketData(model:self.marketModel)
        
        self.klineHeaderView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.width.equalTo(kSCREENWIDTH)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
    }
    
    func loadKLineChart () {
        self.scrollView?.addSubview(self.klinePeriodView)
        self.scrollView?.addSubview(self.klineCharView)
        
        self.klinePeriodView.snp.makeConstraints { (make) in
            make.top.equalTo(self.klineHeaderView!.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        self.klineCharView.snp.makeConstraints { (make) in
            make.top.equalTo(self.klinePeriodView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(450)
        }
    }
    
    func loadBottomView () {
        
        self.scrollView?.addSubview(self.tradeSegment)
        self.tradeSegment.snp.makeConstraints { (make) in
            make.top.equalTo(self.klineCharView.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.height.equalTo(50)
        }
        
        self.scrollView?.addSubview(self.bottomScrollView)
        self.bottomScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tradeSegment.snp.bottom)
            make.left.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(500)
            make.bottom.equalToSuperview().offset(-80)
        }
        
        self.bottomScrollView.addSubview(self.restingTableView)
        self.bottomScrollView.addSubview(self.dealTableView)
    }
    
    func laodTradeButtons () {
        self.view.addSubview(self.buyBtn)
        self.view.addSubview(self.sellBtn)
        
        self.buyBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-kMarginScreenLR)
            make.right.equalTo(self.sellBtn.snp.left)
            make.width.equalTo(self.sellBtn)
        }
        
        self.sellBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().offset(-kMarginScreenLR)
        }
        
        let myDelegate = UIApplication.shared.delegate as? AppDelegate
        self.buyBtn.rx.tap.subscribe { [weak self](event) in
            self?.checkLoginStatus(callback: {
                FCTradeUtil.shareInstance.tradeModel = self?.marketModel ?? FCMarketModel()
                FCTradeUtil.shareInstance.makerSide = "Bid"
                if self?.accountType == .tradingAccountType_spot {
                    
                    myDelegate?.tabBarViewController.showSpotAccount()
                }else {
                    myDelegate?.tabBarViewController.showContractAccount()
                }
                self?.navigationController?.popToRootViewController(animated: false)
            })
        }.disposed(by: self.disposeBag)
        
        self.sellBtn.rx.tap.subscribe { [weak self](event) in
            self?.checkLoginStatus(callback: {
                FCTradeUtil.shareInstance.tradeModel = self?.marketModel ?? FCMarketModel()
                FCTradeUtil.shareInstance.makerSide = "Ask"
                //myDelegate?.tabBarViewController.selectedIndex = 2
                if self?.accountType == .tradingAccountType_spot {
                    
                    myDelegate?.tabBarViewController.showSpotAccount()
                }else {
                    
                    myDelegate?.tabBarViewController.showContractAccount()
                }
                self?.navigationController?.popToRootViewController(animated: false)
            })
        }.disposed(by: self.disposeBag)
    }
    
    func loadKLineData () {
        KLineStateManger.manager.setKLine(symbol: self.marketModel?.symbol ?? "", period: "")
        // 定时轮询最新价
        self.currentSubscription?.dispose()
        self.currentSubscription = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
            .subscribe {[weak self] (num) in
                self?.fetchPriceData()
        }
        
        self.currentSubscription?.disposed(by: self.disposeBag)
    }
    
    func fetchPriceData () {
        
        if self.accountType == .tradingAccountType_spot {
            
            /// 现货
            let priceApi = FCApi_tickers_latest.init(symbol: self.marketModel?.symbol ?? "")
            priceApi.startWithCompletionBlock(success: { (response) in
                let responseData = response.responseObject as?  [String : AnyObject]
                if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                    
                    let data = responseData?["data"] as? [String: AnyObject]
                    self.marketModel =  FCMarketModel.stringToObject(jsonData: data?["ticker"] as? [String : Any])
                    self.klineHeaderView?.loadLastMarketData(model:self.marketModel)
                    self.optionalBtn?.isSelected = self.marketModel?.isOptional ?? false
                } else{
                    let errMsg = responseData?["err"]?["msg"] as? String
                    self.view.makeToast(errMsg ?? "", position: .center)
                }
            }) { (response) in
                self.view.makeToast(response.error?.localizedDescription, position: .center)
            }
            
            return
        }
        
        /// 合约
        let priceApi = FCApi_swap_latest_ticker(symbol: self.marketModel?.symbol ?? "")
        priceApi.startWithCompletionBlock(success: { (response) in
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                let data = responseData?["data"] as? [String: AnyObject]
                self.marketModel =  FCMarketModel.stringToObject(jsonData: data?["ticker"] as? [String : Any])
                self.klineHeaderView?.loadLastMarketData(model:self.marketModel)
                self.optionalBtn?.isSelected = self.marketModel?.isOptional ?? false
            } else{
                let errMsg = responseData?["err"]?["msg"] as? String
                self.view.makeToast(errMsg ?? "", position: .center)
            }
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
        
    }
    
    
    //添加自选
    func addSymbolToFavorite () {
        
        FCUserInfoManager.sharedInstance.loginState { (model) in
            
            if self.accountType == .tradingAccountType_spot {
                
                let addApi = FCApi_add_optional.init(symbol: self.marketModel?.symbol ?? "", marketType: self.marketModel?.marketType ?? "")
                addApi.startWithCompletionBlock(success: { (response) in
                    let responseData = response.responseObject as?  [String : AnyObject]
                    
                    if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                        self.optionalBtn?.isSelected = true
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavorite), object: nil)
                    } else{
                        let errMsg = responseData?["err"]?["msg"] as? String
                        self.view.makeToast(errMsg ?? "", position: .center)
                    }
                    
                }) { (response) in
                    self.view.makeToast(response.error?.localizedDescription, position: .center)
                }
                return
            }
            
            let addApi = FCApi_swap_add_optional.init(symbol: self.marketModel?.symbol ?? "")
             addApi.startWithCompletionBlock(success: { (response) in
                 let responseData = response.responseObject as?  [String : AnyObject]
                
                 if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                     self.optionalBtn?.isSelected = true
                     NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavorite), object: nil)
                 } else{
                     let errMsg = responseData?["err"]?["msg"] as? String
                     self.view.makeToast(errMsg ?? "", position: .center)
                 }
                 
             }) { (response) in
                 self.view.makeToast(response.error?.localizedDescription, position: .center)
             }
        }
    }
    
    //删除自选
    func removeSymbolFromFavorite () {
        
        FCUserInfoManager.sharedInstance.loginState { (model) in
            
            if self.accountType == .tradingAccountType_spot {
                
                /// 登录后操作自选
                let deleteApi = FCApi_delete_optional.init(symbol: self.marketModel?.symbol ?? "", marketType: self.marketModel?.marketType ?? "")
                deleteApi.startWithCompletionBlock(success: { (response) in
                    let responseData = response.responseObject as?  [String : AnyObject]
                    if response.responseCode == 0 {
                        self.optionalBtn?.isSelected = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavorite), object: nil)
                    } else{
                        let errMsg = responseData?["err"]?["msg"] as? String
                        self.view.makeToast(errMsg ?? "", position: .center)
                    }
                    
                }) { (response) in
                    self.view.makeToast(response.error?.localizedDescription, position: .center)
                }
                
                return
            }
            
            /// 登录后操作自选
            let deleteApi = FCApi_swap_detele_optional(symbol: self.marketModel?.symbol ?? "")
            deleteApi.startWithCompletionBlock(success: { (response) in
                let responseData = response.responseObject as?  [String : AnyObject]
            
                if response.responseCode == 0 {
                    self.optionalBtn?.isSelected = false
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUpdateFavorite), object: nil)
                } else{
                    let errMsg = responseData?["err"]?["msg"] as? String
                    self.view.makeToast(errMsg ?? "", position: .center)
                }
                
            }) { (response) in
                self.view.makeToast(response.error?.localizedDescription, position: .center)
            }
        }
    }
    
    
    func fetchRestDatas () {
        
        // 定时轮询为委托挂单
        self.restSubscription?.dispose()
        self.restSubscription = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
            .subscribe {[weak self] (num) in
                self?.requestRestDatas()
        }
        self.restSubscription?.disposed(by: self.disposeBag)
    }
    
    func requestRestDatas () {
        
        if self.accountType == .tradingAccountType_spot {
            
            /// 现货
            //let restApi = FCApi_ticker_depth.init(symbol: self.marketModel?.symbol ?? "", step: "step0")
            let restApi = FCApi_spot_market_depth(symbol: self.marketModel?.symbol ?? "", step: "step0")
            restApi.startWithCompletionBlock(success: { (response) in
                
                let responseData = response.responseObject as?  [String : AnyObject]
                
                if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                    let depthModel = FCKLineRestingModel.stringToObject(jsonData: responseData?["data"] as? [String : Any])
                    self.restingTableView.reloadWithDatas(symbol: self.marketModel?.symbol ?? "", model: depthModel)
                } else{
                    let errMsg = responseData?["err"]?["msg"] as? String
                    self.view.makeToast(errMsg ?? "", position: .center)
                }
                
                
            }) { (response) in
                self.view.makeToast(response.error?.localizedDescription, position: .center)
            }
            
            return
        }
        
        /// 合约深度
        var tradingUnit = "CONT"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit != .TradeTradingUnitType_CONT {
                tradingUnit = "COIN"
        }
       
        let precision = "0.01"
        
        let depthApi = FCApi_quote_market_feed(tradingUnit: tradingUnit, symbol: self.marketModel?.symbol ?? "", precision: precision)
        depthApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                let depthModel = FCKLineRestingModel.stringToObject(jsonData: responseData?["data"] as? [String : Any])
                self?.restingTableView.reloadWithDatas(symbol: self?.marketModel?.symbol ?? "", model: depthModel)
            } else{
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (reponse) in
            
        }
    }
    
    func fetchDealDatas () {
        // 定时轮询最新成交
        self.dealSubscription?.dispose()
        self.dealSubscription = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance)
            .subscribe {[weak self] (num) in
                self?.requestDealDatas()
        }
        self.dealSubscription?.disposed(by: self.disposeBag)
    }
    
    func requestDealDatas () {
        
        if self.accountType == .tradingAccountType_spot {
            
            let dealApi = FCApi_ticker_trade.init(symbol: self.marketModel?.symbol ?? "", step: "step0")
            dealApi.startWithCompletionBlock(success: { (response) in
                
                let responseData = response.responseObject as?  [String : AnyObject]
                if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                    let dealModel = FCKLineDealModel.stringToObject(jsonData: responseData?["data"] as? [String : Any])
                    self.dealTableView.reloadWithDatas(symbol: self.marketModel?.symbol ?? "", model: dealModel)
                } else{
                    let errMsg = responseData?["err"]?["msg"] as? String
                    self.view.makeToast(errMsg ?? "", position: .center)
                }
                
            }) { (response) in
                self.view.makeToast(response.error?.localizedDescription, position: .center)
            }
            
            return
        }
        
        /// 合约最新成交
//        let dealApi = FCApi_swap_ticker_trade(symbol: self.marketModel?.symbol ?? "", precision: "step0")
//        dealApi.startWithCompletionBlock(success: { (response) in
        
        /// 合约深度
        var tradingUnit = "CONT"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit != .TradeTradingUnitType_CONT {
                tradingUnit = "COIN"
        }
        
        let precision = "0.01"
        
        let depthApi = FCApi_quote_market_feed(tradingUnit: tradingUnit, symbol: self.marketModel?.symbol ?? "", precision: precision)
        depthApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                let dealModel = FCKLineDealModel.stringToObject(jsonData: responseData?["data"] as? [String : Any])
                self?.dealTableView.reloadWithDatas(symbol: self?.marketModel?.symbol ?? "", model: dealModel)
            } else{
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
        
    }
    
        private func checkLoginStatus (callback: kFCBlock?) {
            if FCUserInfoManager.sharedInstance.isLogin {
                callback?()
            } else {
                FCLoginViewController.showLogView { (userInfo) in
                    callback?()
                }
            }
        }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    // 懒加载
    lazy var bottomScrollView: UIScrollView = {
        let bottomview = UIScrollView.init(frame: .zero)
        bottomview.backgroundColor = COLOR_BGColor
        bottomview.contentSize = CGSize(width: kSCREENWIDTH * 3, height: 500)
        bottomview.bounces = false
        bottomview.delegate = self
        bottomview.isPagingEnabled = true
        return bottomview
    }()
    
    
    lazy var restingTableView: FCKLineRestingView = {
        let restView = FCKLineRestingView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 500), style: .plain)
        restView.reloadWithDatas(symbol: self.marketModel?.symbol ?? "", model: nil)
        return restView
    }()
    
    lazy var dealTableView: FCKLineDealingView = {
        let dealView = FCKLineDealingView.init(frame: CGRect(x: kSCREENWIDTH, y: 0, width: kSCREENWIDTH, height: 500), style: .plain)
        dealView.reloadWithDatas(symbol: self.marketModel?.symbol ?? "", model: nil)
        return dealView
    }()
    
    
    lazy var tradeSegment: FCSegmentControl = {
        let segmentControl = FCSegmentControl.init(frame: CGRect.zero)
        segmentControl.setFixedWidth(titles: ["委托挂单", "最新成交"], fontSize: 16, normalColor: COLOR_MinorTextColor, tintColor: COLOR_ThemeBtnEndColor, showUnderLine: true)
        segmentControl.backgroundColor = COLOR_BGColor
        segmentControl.didSelectedItem { [weak self] (index: Int) in
            self?.bottomScrollView.setContentOffset(CGPoint(x: kSCREENWIDTH * CGFloat(index), y: 0) , animated: false)
        }
        return segmentControl
    }()
    
    lazy var buyBtn: UIButton = {
        let button = fc_buttonInit(imgName: nil, title: "买入", fontSize: 17, titleColor: .white, bgColor: COLOR_Clear)
        let tintImage = UIImage(named: "kline_buyBtnBg")
        let selectImg = tintImage?.imageWithTintColor(color: COLOR_RiseColor)
        
        button.setBackgroundImage(selectImg, for: .normal)
        
        return button
    }()
    
    lazy var sellBtn: UIButton = {
        let button = fc_buttonInit(imgName: nil, title: "卖出", fontSize: 17, titleColor: .white, bgColor: COLOR_Clear)
        let tintImage = UIImage(named: "kline_sellBtnBg")
        let selectImg = tintImage?.imageWithTintColor(color: COLOR_FailColor)
        button.setBackgroundImage(selectImg, for: .normal)
        return button
    }()
}

extension FCKLineController: UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        if scrollView == self.bottomScrollView {
            self.tradeSegment.setSelected(Int(offset/kSCREENWIDTH))
        }
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
        self.klineCharView.panGesture.state = .began
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.klineCharView.panGesture.state = .began
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        let translation = (gestureRecognizer as! UIPanGestureRecognizer).translation(in: self.view)
        
        if gestureRecognizer == self.klineCharView.panGesture {
            
            if (abs(translation.x) > abs(translation.y)) || abs(translation.x) == 0.0 {
             
                self.klineCharView.panGesture.state = .began
                
            }else {
                
                self.klineCharView.panGesture.state = .failed
            }
            
            return true
        }
        
        return false
    }
}
