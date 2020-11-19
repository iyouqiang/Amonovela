//
//  FCContractsEntrustMultiListController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

import JXSegmentedView

class FCContractsEntrustMultiListController: UIViewController {

    let segmentedDataSource = JXSegmentedTitleDataSource()
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()

    var marketModel: FCMarketModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let totalItemWidth: CGFloat = 150
        let titles = ["当前委托", "历史委托"]
        //segmentedViewDataSource一定要通过属性强持有！！！！！！！！！
        segmentedDataSource.itemWidth = totalItemWidth/CGFloat(titles.count)
        segmentedDataSource.titles = titles
        segmentedDataSource.titleNormalColor = .white
        segmentedDataSource.titleSelectedColor = COLOR_TabBarTintColor
        segmentedDataSource.itemSpacing = 0

        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorWidth = 30
        indicator.indicatorColor = COLOR_TabBarTintColor

        segmentedView.frame = CGRect(x: 0, y: 0, width: totalItemWidth, height: 44)
        segmentedView.dataSource = segmentedDataSource
        segmentedView.indicators = [indicator]
        navigationItem.titleView = segmentedView

        segmentedView.listContainer = listContainerView
        view.addSubview(listContainerView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = view.bounds
    }
}

extension FCContractsEntrustMultiListController:JXSegmentedListContainerViewDataSource {
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        
        let vc = FCContractsEntrustListController()
        vc.marketModel = self.marketModel
        vc.titles = ["限价委托", "计划委托", "止盈止损"]
        
        if index == 0 {
            vc.isHistoryEntrust = false
        }else if index == 1 {
            vc.isHistoryEntrust = true
        }
        
        return vc
    }
}
