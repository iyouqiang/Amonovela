
//
//  FCPerpetualEntrustController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/4.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import JXSegmentedView

class FCPerpetualEntrustController: UIViewController {
    
    let disposeBag = DisposeBag()
    let tableView: UITableView = UITableView.init(frame: .zero, style: .plain)
    let FCPerpetualEntrustListCellIdentifier = "FCPerpetualEntrustListCellIdentifier"
    var marketModel: FCMarketModel?
    var entrustModels: [FCPerpetualEntrustModel] = []
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
        //先默认拉取一次
        self.fetchEntrustOrders()
        
        //开启轮询
        Observable<Int>.interval(2.0, scheduler: MainScheduler.instance).subscribe {[weak self] (num) in
            self?.fetchEntrustOrders()
        }.disposed(by: self.disposeBag)
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
        
        tableView.isScrollEnabled = isVeiwScrollEnabled
        tableView.separatorColor = COLOR_LineColor
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = COLOR_BGColor
        self.tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FCPerpetualEntrustListCell", bundle: Bundle.main), forCellReuseIdentifier: FCPerpetualEntrustListCellIdentifier)
    }
    
    func showCancelAlert(index: Int) {
        PCAlertManager.showCustomAlertView("确定撤销订单?", message: "立即撤销当前委托", btnFirstTitle: "撤单", btnFirstBlock: {
            self.cancelOrder(index: index)
        }, btnSecondTitle: "取消") {
            
        }
    }
    
    
    func fetchEntrustOrders () {
        
        var tradingUnit = "COIN"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            
            tradingUnit = "CONT"
        }
        let symbolStr = "All" //self.marketModel?.symbol ?? ""
        
        let api = FCApi_entrust_perpetual.init(symbol: symbolStr, tradingUnit: tradingUnit)
        api.startWithCompletionBlock(success: { (response) in
            FCNetworkUtils.handleResponse(response: response, success: { [weak self] (resData) in
                self?.entrustModels = []
                for item in (resData?["orders"] as? Array<[String : Any]>) ?? [] {
                    let model = FCPerpetualEntrustModel.stringToObject(jsonData: item)
                    self?.entrustModels.append(model)
                }
                
                if let currentViewHeightBolcok = self?.currentViewHeightBolcok {
                    let viewHeight = (155 * (self?.entrustModels.count)!)
                    currentViewHeightBolcok(CGFloat(viewHeight), self?.entrustModels.count ?? 0)
                }
                
                if self?.entrustModels.count == 0 {
                     self?.tableView.tableFooterView = self?.footerHint
                 }else {
                     self?.tableView.tableFooterView = nil
                 }
                
                self?.tableView.reloadData()
                
            }) { (errMsg) in
                self.view.makeToast(errMsg, position: .center)
            }
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
        
    }
    
    func cancelOrder(index: Int) {

        let api = FCApi_Contract_cancel.init(symbol: self.entrustModels[index].symbol ?? "", orderId: self.entrustModels[index].orderId ?? "")
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

extension FCPerpetualEntrustController: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

extension FCPerpetualEntrustController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entrustModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FCPerpetualEntrustListCellIdentifier) as! FCPerpetualEntrustListCell
        cell.loadData(model: self.entrustModels[indexPath.row])
        cell.modifyAction = { () in
            // self.showCancelAlert(index: indexPath.row)
        }
        cell.cancelAction = { () in
            self.showCancelAlert(index: indexPath.row)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
