//
//  FCContractProfitLossController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/12.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa
import JXSegmentedView

class FCContractProfitLossController: UIViewController {
    
    let disposeBag = DisposeBag()
    let triggerTableView: UITableView = UITableView.init(frame: .zero, style: .plain)
    let FCPfofitLossIdentifier = "FCContractProfitLossCell"
    var marketModel: FCMarketModel?
    var entrustModels: [FCTriggerModel] = []
    
    /// 是否为历史委托
    var isHistoryEntrust = false
    var isVeiwScrollEnabled = false
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()
    
    var currentViewHeightBolcok: ((_ viewHeight: CGFloat, _ count: Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        self.loadSubViews()
        
        if isHistoryEntrust {
            
            triggerTableView.isScrollEnabled = true
        
            self.fetchHistoryEntrustOrders()
            
            triggerTableView.refreshNormalModelRefresh(false, refreshDataBlock: {
                
                self.fetchHistoryEntrustOrders()
                
            }, loadMoreDataBlock: nil)
            
        }else {
            
            triggerTableView.isScrollEnabled = isVeiwScrollEnabled
         
            //先默认拉取一次
            self.fetchEntrustOrders()
            
            //开启轮询
            Observable<Int>.interval(2.0, scheduler: MainScheduler.instance).subscribe {[weak self] (num) in
                self?.fetchEntrustOrders()
            }.disposed(by: self.disposeBag)
        }
    }
    
    func loadSubViews () {
        let headerView = UIView.init(frame: .zero)
        headerView.backgroundColor = COLOR_BGColor
        self.view.addSubview(headerView)
        
        headerView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        }
        
        self.view.addSubview(triggerTableView)
        self.triggerTableView.backgroundColor = COLOR_BGColor
        triggerTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        triggerTableView.delegate = self
        triggerTableView.dataSource = self
        triggerTableView.register(UINib(nibName: "FCContractProfitLossCell", bundle: Bundle.main), forCellReuseIdentifier: FCPfofitLossIdentifier)
        triggerTableView.separatorColor = COLOR_SeperateColor
        triggerTableView.tableFooterView = UIView()
    }
    
    func showCancelAlert(index: Int) {
        PCAlertManager.showCustomAlertView("确定撤销订单?", message: "立即撤销当前委托", btnFirstTitle: "撤单", btnFirstBlock: {
            self.cancelOrder(index: index)
        }, btnSecondTitle: "取消") {
            
        }
    }
    
    func showChangeEntrustAlert(index: Int) {
        
        let model = self.entrustModels[index];
        
        let profitView = FCProfitLossSettingView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 430))
        profitView.triggerModel = model
        
       let alertView = PCCustomAlert(customView: profitView)
        profitView.closeAlertBlock = {
            alertView?.disappear()
        }
    }
    
    func fetchEntrustOrders () {
        
        var tradingUnit = "COIN"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            
            tradingUnit = "CONT"
        }
        
        let symbolStr = "All" //self.marketModel?.symbol ?? ""
        
        /// /// Open表示计划委托，Close表示止盈止损，不填或者填All，则一起返回
        let api = FCApi_trigger_pending_orders.init(symbol: symbolStr, tradingUnit: tradingUnit, triggerType: "Close")
        api.startWithCompletionBlock(success: { (response) in
            FCNetworkUtils.handleResponse(response: response, success: { [weak self] (resData) in
                self?.entrustModels = []
                for item in (resData?["orders"] as? Array<[String : Any]>) ?? [] {
                    let model = FCTriggerModel.stringToObject(jsonData: item)
                    self?.entrustModels.append(model)
                }
                
                if let currentViewHeightBolcok = self?.currentViewHeightBolcok {
                    let viewHeight = (180 * (self?.entrustModels.count)!)
                    currentViewHeightBolcok(CGFloat(viewHeight), self?.entrustModels.count ?? 0)
                }
                
                if self?.entrustModels.count == 0 {
                    
                     self?.triggerTableView.tableFooterView = self?.footerHint
                 }else {
                    
                     self?.triggerTableView.tableFooterView = nil
                 }
                
                self?.triggerTableView.reloadData()
                
            }) { (errMsg) in
                self.view.makeToast(errMsg, position: .center)
            }
        }) { (response) in
            
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    func fetchHistoryEntrustOrders() {
        
        var tradingUnit = "CONT"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit != .TradeTradingUnitType_CONT {
                tradingUnit = "COIN"
        }
        
        let timestampStr = NSString.timestampTo()
        let startDate = currentDateToWantDate(year: 0, month: -6, day: 0)
        
        let startTimestamp = NSString.dateTotimestamp(startDate)
        
        let startTime: String = (startTimestamp! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        let endTime: String = (timestampStr! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        
        let symbolStr = "All"//self.marketModel?.symbol ?? ""
        
        let historyApi = FCApi_trigger_history(symbol: symbolStr, tradingUnit: tradingUnit, startTime: startTime, endTime: endTime, triggerType: "Close", state: "", tradingAction: "")
        historyApi.startWithCompletionBlock { [weak self] (response) in
            
            self?.triggerTableView.endRefresh()
            FCNetworkUtils.handleResponse(response: response, success: { [weak self] (resData) in
                self?.entrustModels = []
                for item in (resData?["orders"] as? Array<[String : Any]>) ?? [] {
                    let model = FCTriggerModel.stringToObject(jsonData: item)
                    self?.entrustModels.append(model)
                }
                
                
                if self?.entrustModels.count == 0 {
                    
                     self?.triggerTableView.tableFooterView = self?.footerHint
                 }else {
                    
                     self?.triggerTableView.tableFooterView = nil
                 }
                
                self?.triggerTableView.reloadData()
                
            }) { (errMsg) in
                self?.view.makeToast(errMsg, position: .center)
            }
            
        } failure: { (response) in
            
            self.triggerTableView.endRefresh()
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    func cancelOrder(index: Int) {

        let api = FCApi_trigger_order_cancel.init(symbol: self.entrustModels[index].symbol ?? "", orderId: self.entrustModels[index].orderId ?? "")
        api.startWithCompletionBlock(success: { (response) in
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                self.view.makeToast("撤单成功", position: .center)
                self.fetchEntrustOrders()
            }) { (errMsg) in
                self.view.makeToast(errMsg, position: .center)
            }
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
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

extension FCContractProfitLossController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension FCContractProfitLossController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entrustModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FCPfofitLossIdentifier) as! FCContractProfitLossCell
        cell.loadTriggerData(model: self.entrustModels[indexPath.row])
        cell.modifyAction = { () in
            self.showChangeEntrustAlert(index: indexPath.row)
        }
        cell.cancelAction = { () in
            self.showCancelAlert(index: indexPath.row)
        }
        
        //cell.changeBtn.isHidden = isHistoryEntrust
        cell.cancelBtn.isHidden = isHistoryEntrust
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 170
    }
}
