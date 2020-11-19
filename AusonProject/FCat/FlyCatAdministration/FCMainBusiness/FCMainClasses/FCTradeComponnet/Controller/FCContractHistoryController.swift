//
//  FCContractHistoryController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/6.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import JXSegmentedView
import RxCocoa
import RxSwift

class FCContractHistoryController: UIViewController {

    let cellidentify = "FCContractHistoryCell"
    var historyTableView: UITableView!
    var marketModel: FCMarketModel?
    var dataSource: [FCContractHistoryModel]?
    weak var segmentedView:JXSegmentedView?
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "历史合约"
        
        dataSource = []
        /// 界面布局
        self.setupView()
    }
    
    func setupView() {
           
           historyTableView = UITableView(frame: CGRect.zero, style: .grouped)
           historyTableView.showsVerticalScrollIndicator = false
           historyTableView.delegate = self
           historyTableView.dataSource = self
           historyTableView.separatorStyle = .none
           historyTableView.backgroundColor = COLOR_TabBarBgColor
           self.view.addSubview(historyTableView)
           
           historyTableView.register(UINib(nibName: "FCContractHistoryCell", bundle: Bundle.main), forCellReuseIdentifier: cellidentify)
           historyTableView.snp.makeConstraints { (make) in
               make.edges.equalToSuperview()
           }
        
        historyTableView.refreshNormalModelRefresh(true, refreshDataBlock: { [weak self] in
            
            self?.loadHistoryData()
        }) {
            
            [weak self] in
            self?.historyTableView.endRefresh()
        }
    }
    
    func loadHistoryData() {
        
        let tradingUnit = FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT ? "CONT" : "COIN"
        let timestampStr = NSString.timestampTo()
        let startDate = currentDateToWantDate(year: 0, month: -6, day: 0)
               
        let startTimestamp = NSString.dateTotimestamp(startDate)
            
        let startTime: String = (startTimestamp! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        let endTime: String = (timestampStr! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        
        let symbolStr = "All" //self.marketModel?.symbol ?? ""
        
        let historyApi = FCApi_trade_history_orders(startTime: startTime, endTime: endTime, tradingUnit: tradingUnit, symbol: symbolStr)
        historyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            self?.historyTableView.endRefresh()
            self?.dataSource?.removeAll()
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] {
                 
                    let records:[AnyObject] = data["orders"] as! [AnyObject]
                    
                    for dic in records {

                        let model = FCContractHistoryModel(dict: dic as! [String : AnyObject])
                        self?.dataSource?.append(model)
                    }
                    
                    if self?.dataSource?.count == 0 {
                        
                        self?.historyTableView.tableFooterView = self?.footerHint
                    }else {
                        
                        self?.historyTableView.tableFooterView = nil
                    }
                }
                
            }else {
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
            self?.historyTableView.reloadData()
        }) { [weak self] (response) in
            
            self?.historyTableView.endRefresh()
        }
    }
    
    
    func currentDateToWantDate(year:Int,month:Int,day:Int)->Date {
        let current = Date()
        let calendar = Calendar(identifier: .gregorian)
        var comps:DateComponents?
        
        comps = calendar.dateComponents([.year,.month,.day], from: current)
        comps?.year = year
        comps?.month = month
        comps?.day = day
        return calendar.date(byAdding: comps!, to: current) ?? Date()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FCContractHistoryController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = self.dataSource?[indexPath.row]
        let historyVC = FCContractHistroyDetailVC()
        historyVC.hidesBottomBarWhenPushed = true
        historyVC.historyModel = model
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentify) as? FCContractHistoryCell
        
        if let cell = cell {
          
            cell.backgroundColor = COLOR_CellBgColor
            let model = dataSource?[indexPath.row]
            cell.historyModel = model
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let historyModel = self.dataSource?[indexPath.row]
        
        let shareModel = historyModel?.pnlShare
        
        // 收益率字段被复用
        if shareModel?.symbolName?.count == 0 {
            return 190
        }
        
        if (historyModel?.triggerType == "LimitOrder") {
            return 190
        }else if (historyModel?.triggerType == "TriggerOpen") {
            return 220
        }else if (historyModel?.triggerType == "TriggerTakeProfit") {
            return 220
        }else if (historyModel?.triggerType == "TriggerStopLoss") {
            return 220
        }else {
            
            return 190
        }
    }
}

extension FCContractHistoryController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
