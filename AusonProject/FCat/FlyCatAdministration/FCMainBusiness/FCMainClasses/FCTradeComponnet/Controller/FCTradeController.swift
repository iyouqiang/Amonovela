

//
//  FCTradeController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/6.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JXSegmentedView
import SideMenu

public enum AccountType: Int {
    
    case AccountType_spot
    case AccountType_contract
}

class FCTradeController: UIViewController {

    var segmentedDataSource = JXSegmentedTitleDataSource()
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()

    var marketModel: FCMarketModel?
    var tradeType: AccountType = .AccountType_spot
    
    //现货下单
    lazy var orderController: FCOrderController = {
        let orderVC = FCOrderController()
        orderVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return orderVC
    }()
    
    lazy var treatyOrderController: FCTreatyOrderController = {
        let orderVC = FCTreatyOrderController()
        orderVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return orderVC
    }()
    
    //合约持仓
    lazy var positionController: FCContractPositionController = {
        let positionController = FCContractPositionController()
        return positionController
    }()
    
    // 现货持仓
    lazy var accountAssetController: FCAccountAssetController = {
        let accountAssetController = FCAccountAssetController()
        return accountAssetController
    }()
    
    //委托
    lazy var entrustController: FCEntrustListController = {
        let entrustVC = FCEntrustListController()
        entrustVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return entrustVC
    }()
    
    //合约委托
    lazy var perpetualEntrustController: FCPerpetualEntrustController = {
        let perpetualVC = FCPerpetualEntrustController()
        perpetualVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return perpetualVC
    }()
    
    //历史记录 
    lazy var historyController: FCTradeHistoryListController = {
        let historyVC = FCTradeHistoryListController()
        historyVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return historyVC
    }()
    
    /// 币币综合界面
    lazy var treatySpotSynController: FCSpotSyntheController = {
        let orderVC = FCSpotSyntheController()
        orderVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return orderVC
    }()
    
    /// 合约综合界面
    lazy var contractSyntheController: FCContractSyntheController = {
        let controactVC = FCContractSyntheController()
        controactVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return controactVC
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addrightNavigationItemImgNameStr("", title: "账单", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14)) { [weak self] in
             
            let billContractVC = FCBillContractController()
            billContractVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(billContractVC, animated: true)
        }
        
        self.addrightNavigationItemImgNameStr("", title: "持币", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14)) { [weak self] in
        
            let assetContractVC = FCAccountAssetController()
            assetContractVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(assetContractVC, animated: true)
        }
        
        loadSegmentControl()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
     
        super.viewWillDisappear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func showSpotAccount() {
        
        self.segmentedView.selectItemAt(index: 1)
    }
    
    func showContractAccount() {
        
        self.segmentedView.selectItemAt(index: 0)
    }
    
    func loadSegmentControl () {
        
        let totalItemWidth = 200
        let titles = ["永续合约", "币币交易"]
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.itemWidth = 100
        titleDataSource.titles = titles
        titleDataSource.isTitleMaskEnabled = true
        titleDataSource.titleNormalColor = .white
        titleDataSource.titleSelectedColor = COLOR_TabBarTintColor
        titleDataSource.itemSpacing = 0
        segmentedDataSource = titleDataSource
        segmentedView.dataSource = titleDataSource
        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 36)
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 18
        segmentedView.layer.borderColor = COLOR_HexColor(0x3E4046).cgColor
        segmentedView.layer.borderWidth = 1/UIScreen.main.scale
        navigationItem.titleView = segmentedView

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 36
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = COLOR_HexColor(0x3E4046)
        segmentedView.indicators = [indicator]
        
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = view.bounds
    }
        
    func loadDefaultData () {
        self.marketModel = FCMarketModel()
        self.marketModel?.symbol = "BTC-USDT"
    }
    
    func loadListeners () {
        //登入 
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogin))
            .takeUntil(self.rx.deallocated)
            .subscribe(onDisposed:  { //[weak self] _ in
                
            })
        
        // 登出
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogout))
            .takeUntil(self.rx.deallocated)
            .subscribe(onDisposed:  { //[weak self]  _ in
                
            })
        
        // 买卖
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationTransferToTrade))
            .takeUntil(self.rx.deallocated)
            .subscribe(onDisposed:  { //[weak self]  _ in
            })
    }
}

extension FCTradeController: JXSegmentedListContainerViewDataSource{
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
    
        if index == 0 {
            
            // 永续合约
            return self.contractSyntheController
        }else {
            
            return self.treatySpotSynController
        }
    }
}

extension FCTradeController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        // self.fetchQuoteTickers(index: index)
    }
}
