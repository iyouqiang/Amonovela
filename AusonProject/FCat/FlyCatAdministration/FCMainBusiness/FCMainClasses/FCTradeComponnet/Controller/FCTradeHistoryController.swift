//
//  FCTradeHistoryController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/9.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import JXSegmentedView
import RxSwift
import RxCocoa

class FCTradeHistoryListController: UIViewController {
    
    var marketModel: FCMarketModel?
    var historyModels: [FCTradeHistroyListModel] = []
    var startTime = 0
    var endTime = 0
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()
    
    let tableView: UITableView = UITableView.init(frame: .zero, style: .plain)
     let FCTradeHistoryListCellIdentifier = "FCTradeHistoryListCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = COLOR_BGColor
        self.loadSubViews()
        self.title = "历史记录"
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.resetStartTimeAndEndTime()
        self.fetchHistoryOrders(isLoadMore: true)
    }
    
    func loadSubViews () {
        
        let headerView = UIView.init(frame: .zero)
          headerView.backgroundColor = COLOR_SectionFooterBgColor
          self.view.addSubview(headerView)

        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
             make.left.equalToSuperview()
             make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = COLOR_BGColor
        tableView.snp.makeConstraints { (make) in
               make.top.equalToSuperview().offset(10)
               make.left.equalToSuperview()
               make.right.equalToSuperview()
               make.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FCTradeHistoryListCell", bundle: Bundle.main), forCellReuseIdentifier: FCTradeHistoryListCellIdentifier)
        
        //下拉刷新与加载更多
        self.tableView.refreshNormalModelRefresh(false, refreshDataBlock: {
            // 下拉加载
            self.resetStartTimeAndEndTime()
            self.fetchHistoryOrders(isLoadMore: false)
        }) {
        self.setupLoadMoreStartTimeAndEndTime()
            self.fetchHistoryOrders(isLoadMore: true)
        }
        
    }
    
    func fetchHistoryOrders (isLoadMore: Bool) {
        let api = FCApi_history_order.init(symbol: self.marketModel?.symbol ?? "", startTime: startTime, endTime: endTime)
        api.startWithCompletionBlock(success: { (response) in
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                
                if (isLoadMore) == false {
                    self.historyModels = []
                }
                self.tableView.endRefresh()
                
                for item in (resData?["orders"] as? Array<[String : Any]>) ?? [] {
                    let model = FCTradeHistroyListModel.stringToObject(jsonData: item)
                    self.historyModels.append(model)
                }
                
                if self.historyModels.count > 0 {
                    
                    self.tableView.tableFooterView = UIView()
                }else {
                    
                    self.tableView.tableFooterView = self.footerHint
                    
                }
                
                self.tableView.reloadData()
                
            }) { (errMsg) in
                self.tableView.endRefresh()
                self.view.makeToast(errMsg, position: .center)
            }
        }) { (response) in
            self.tableView.endRefresh()
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    func resetStartTimeAndEndTime () {
        startTime = Int(Date().milliStamp) ?? 0
        endTime = startTime + Int(7 * 24 * 60 * 60 * 1000)
    }
    
    func setupLoadMoreStartTimeAndEndTime () {
        startTime = endTime
        endTime = startTime + Int(7 * 24 * 60 * 60 * 1000)
    }
    
}

extension FCTradeHistoryListController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension FCTradeHistoryListController : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.historyModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FCTradeHistoryListCellIdentifier) as! FCTradeHistoryListCell
        cell.loadData(model: self.historyModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170
    }
}


