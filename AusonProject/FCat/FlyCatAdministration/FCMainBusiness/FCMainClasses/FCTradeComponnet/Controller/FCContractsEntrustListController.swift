//
//  FCContractsEntrustListController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import JXSegmentedView

class FCContractsEntrustListController: UIViewController {

    var titles = [String]()
    let segmentedDataSource = JXSegmentedTitleDataSource()
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    var isHistoryEntrust = false
    var isVeiwScrollEnabled = false
    ///
    var marketModel: FCMarketModel?
    
    /// 合约委托
    lazy var perpetualEntrustController: FCPerpetualEntrustController = {
        let perpetualVC = FCPerpetualEntrustController()
        perpetualVC.marketModel = self.marketModel
        return perpetualVC
    }()
    
    /// 计划委托
    lazy var planEntrustController: FCTriggerEntrustViewController = {
        let planEntrustVC = FCTriggerEntrustViewController()
        planEntrustVC.marketModel = self.marketModel
        return planEntrustVC
    }()
    
    // 止盈止损
    lazy var profitLossEntrustController: FCContractProfitLossController = {
        let profitLossVC = FCContractProfitLossController()
        profitLossVC.marketModel = self.marketModel
        return profitLossVC
    }()
    
    /// 历史委托
    lazy var contractHistoryVC: FCContractHistoryController = {
        let contractHistoryVC = FCContractHistoryController()
        contractHistoryVC.marketModel = self.marketModel
        return contractHistoryVC
    }()

    override func viewDidLoad() {
        
        super.viewDidLoad()

        view.backgroundColor = COLOR_BGColor
        
        adjuestInsets()
        
        //配置数据源
        segmentedDataSource.isTitleColorGradientEnabled = true
        segmentedDataSource.titleNormalColor = .white
        segmentedDataSource.titleSelectedColor = COLOR_TabBarTintColor
        segmentedDataSource.titles = titles
        segmentedDataSource.itemWidth = 50

        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedView.backgroundColor = COLOR_CellBgColor
        segmentedView.dataSource = segmentedDataSource
        //segmentedView.indicators = [indicator]
        segmentedView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: 50)
        view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.width.equalTo(kSCREENWIDTH)
            make.top.equalToSuperview()
            make.height.equalTo(50)
        }
        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
        
        listContainerView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segmentedView.snp_bottom)
        }
    }
}

extension FCContractsEntrustListController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension FCContractsEntrustListController: JXSegmentedListContainerViewDataSource {
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        if isHistoryEntrust {
            
            /// 当前委托
            if (index == 0) {
                
                /// 限价委托
                return self.contractHistoryVC
               
            } else if (index == 1) {
                
                /// 计划委托
                planEntrustController.isHistoryEntrust = true
                return self.planEntrustController
                
            } else  {
                
                profitLossEntrustController.isHistoryEntrust = true
               return profitLossEntrustController
            }
        }
        
        /// 当前委托
        if (index == 0) {
            
            /// 限价委托
            self.perpetualEntrustController.isVeiwScrollEnabled = true
            return self.perpetualEntrustController
           
        } else if (index == 1) {
            
            /// 计划委托
            planEntrustController.isHistoryEntrust = false
            planEntrustController.isVeiwScrollEnabled = true
            return self.planEntrustController
            
        } else  {
            
            profitLossEntrustController.isVeiwScrollEnabled = true
            profitLossEntrustController.isHistoryEntrust = false
           return profitLossEntrustController
        }
    }
}
