
//
//  FCEntrustListController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SideMenu
import JXSegmentedView

class FCSpotSyntheController: UIViewController {
   
var entrustL: UILabel?
let disposeBag = DisposeBag()
    let tableView: UITableView = UITableView.init(frame: .zero, style: .plain)
    let FCEntrustListCellIdentifier = "FCEntrustListCellIdentifier"
    var marketModel: FCMarketModel?
    var entrustModels: [FCTradeHistroyListModel] = []
    
   private lazy var orderController: FCOrderController = {
        let orderVC = FCOrderController()
        orderVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        return orderVC
    }()
    
    private lazy var sectionHeaderView: UIView = {
       
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44))
        headerView.backgroundColor = COLOR_BGColor
        
        /// 当前委托
        let entrustL = fc_labelInit(text: "当前委托(0)", textColor: COLOR_TabBarTintColor, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        headerView.addSubview(entrustL)
        entrustL.frame = CGRect(x: 15, y: 0, width: 150, height: 44)
        self.entrustL = entrustL
        
        /// 历史记录
        let historyBtn = fc_buttonInit(imgName: "historyIcon", title: "历史记录", fontSize: 16, titleColor: COLOR_CellTitleColor, bgColor: .clear)
        historyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        historyBtn.frame = CGRect(x: kSCREENWIDTH - 145, y: 0, width: 130, height: 44)
        historyBtn.contentHorizontalAlignment = .right
        headerView.addSubview(historyBtn)
        historyBtn.addTarget(self, action: #selector(gotoHistoryVC), for: .touchUpInside)
        
        let bottomLine = UIView(frame: CGRect(x: 0, y: 43.2, width: kSCREENWIDTH, height: 0.8))
        bottomLine.backgroundColor = COLOR_TabBarBgColor
        headerView.addSubview(bottomLine)
        
        return headerView
    }()
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
        // 刷新资产
        self.orderController.fetchAsset()
    
        // 切换交易对
        self.orderController.setSelectedAction()
    }

    override func viewWillDisappear(_ animated: Bool) {
        
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        self.loadSubViews()
        
        /// 交易信息
        self.orderController.updateSymbol(model: self.marketModel)
        
        //委托轮询
        self.fetchEntrustOrders()
        
        //开启轮询
        Observable<Int>.interval(2.0, scheduler: MainScheduler.instance).subscribe {[weak self] (num) in
            self?.fetchEntrustOrders()
        }.disposed(by: self.disposeBag)
    }

    func loadSubViews () {
        
        let orderView = self.orderController.view
        let containerView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 430));
        containerView.clipsToBounds = true
        containerView.addSubview(orderView!)
        tableView.tableHeaderView = containerView
        
        self.orderController.klineViewItemBlock = {
            [weak self] in
            let klineVC = FCKLineController()
            let marketModel = self?.marketModel
            marketModel?.tradingType = "Spot"
            klineVC.marketModel = marketModel
            klineVC.hidesBottomBarWhenPushed = true
                       
            self?.navigationController?.pushViewController(klineVC, animated: true)
        }
        
        self.orderController.leftMenuItemBlock = {
            [weak self] leftSideMenu in
             
             self?.orderController.leftVC.fetchQuoteTypes()
             if let menu = leftSideMenu.menuLeftNavigationController {
                 self?.present(menu , animated: true, completion: nil)
             }
        }
        
        // 切换交易对
         self.orderController.didSelectItem = { [weak self] (model) in
            self?.marketModel = model
         }
        
        self.view.addSubview(tableView)
        self.tableView.backgroundColor = COLOR_BGColor
        tableView.snp.makeConstraints { (make) in
            /**
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
             */
            make.edges.equalToSuperview()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "FCEntrustListCell", bundle: Bundle.main), forCellReuseIdentifier: FCEntrustListCellIdentifier)
    }
    
    func showCancelAlert(index: Int) {
        PCAlertManager.showCustomAlertView("确定撤销订单?", message: "立即撤销当前委托", btnFirstTitle: "撤单", btnFirstBlock: {
            self.cancelOrder(index: index)
        }, btnSecondTitle: "取消") {
            
        }
    }
    
    @objc func gotoHistoryVC() {
        let historyVC = FCTradeHistoryListController()
        historyVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        historyVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func fetchEntrustOrders () {
        if FCUserInfoManager.sharedInstance.userInfo?.userId?.count == 0 {
            return
        }
        let api = FCApi_trade_entrust.init(symbol: self.marketModel?.symbol ?? "")
        api.startWithCompletionBlock(success: { [weak self] (response) in
                            
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                self?.entrustModels = []
                self?.entrustL?.text = "当前委托(\(resData?["totalNum"] ?? ""))"
                for item in (resData?["orders"] as? Array<[String : Any]>) ?? [] {
                    let model = FCTradeHistroyListModel.stringToObject(jsonData: item)
                    self?.entrustModels.append(model)
                }
                
                if self?.entrustModels.count == 0 {
                    self?.tableView.tableFooterView = self?.footerHint
                }else {
                    self?.tableView.tableFooterView = nil
                }
                self?.tableView.reloadData()
                
            }) { (errMsg) in
                //self?.view.makeToast(errMsg, position: .center)
                self?.footerHint.text = errMsg
                self?.tableView.tableFooterView = self?.footerHint
            }
        }) { [weak self](response) in
            //self.view.makeToast(response.error?.localizedDescription, position: .center)
            self?.tableView.tableFooterView = self?.footerHint
        }
    }
    
    func cancelOrder(index: Int) {
        let api = FCApi_trade_cancel.init(symbol: self.marketModel?.symbol ?? "", orderId: self.entrustModels[index].orderId)
        api.startWithCompletionBlock(success: { [weak self] (response) in
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                self?.view.makeToast("撤单成功", position: .center)
            }) { (errMsg) in
                self?.view.makeToast(errMsg, position: .center)
            }
            self?.orderController.fetchAsset()
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

extension FCSpotSyntheController : UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return self.sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.entrustModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FCEntrustListCellIdentifier) as! FCEntrustListCell
        cell.loadData(model: self.entrustModels[indexPath.row])
        cell.backgroundColor = COLOR_BGColor
        cell.contentView.backgroundColor = COLOR_BGColor
        cell.cancelAction = { () in
            self.showCancelAlert(index: indexPath.row)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}


extension FCSpotSyntheController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
