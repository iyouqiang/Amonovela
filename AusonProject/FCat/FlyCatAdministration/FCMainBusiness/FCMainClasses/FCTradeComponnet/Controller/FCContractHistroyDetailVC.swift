//
//  FCContractHistroyDetailVC.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractHistroyDetailVC: UIViewController {

    let cellidentify = "FCTradingHistoryDetailCell"
    var historyModel: FCContractHistoryModel?
    var historyTableView: UITableView!
    var dataSource:[FCHistoryDelModel]?
    var tradeEventBlock: (() -> Void)?
    var sectionHeaderView: UIView {
        
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 40))
        sectionHeaderView.backgroundColor = COLOR_BGColor
        /// 成交明细
        let titleL = fc_labelInit(text: "成交明细", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        sectionHeaderView.addSubview(titleL)
        titleL.frame = CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 40)
        
        // 成交时间 成交价 成交量
        let tradingTm = fc_labelInit(text: "成交时间", textColor: COLOR_RichBtnTitleColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        sectionHeaderView.addSubview(tradingTm)
        tradingTm.frame = CGRect(x: 15, y: 50, width: 100, height: 40)
        
        let tradeingPrice = fc_labelInit(text: "成交价", textColor: COLOR_RichBtnTitleColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        tradeingPrice.textAlignment = .center
        sectionHeaderView.addSubview(tradeingPrice)
        tradeingPrice.frame = CGRect(x: 15, y: 50, width: 100, height: 40)
        tradeingPrice.center = CGPoint(x: sectionHeaderView.center.x, y: tradeingPrice.center.y)
        
        let tradeingVolum = fc_labelInit(text: "成交量", textColor: COLOR_RichBtnTitleColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        tradeingVolum.textAlignment = .right
        sectionHeaderView.addSubview(tradeingVolum)
        tradeingVolum.frame = CGRect(x: kSCREENWIDTH - 115, y: 40, width: 100, height: 50)
        
        return sectionHeaderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "详情"
        self.view.backgroundColor = COLOR_TabBarBgColor
        self.dataSource = []
        self.setup()
        
        self.loadTradingDetailData()
    }
    
    func setup() {
        
        let headerView = Bundle.main.loadNibNamed("FCHistoryDetialHeaderView", owner: nil, options: nil)?.first as? FCHistoryDetialHeaderView
        view.addSubview(headerView!)
        headerView?.historyModel = self.historyModel
        headerView?.backgroundColor = COLOR_BGColor
        headerView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalTo(0)
            make.height.equalTo(290)
        })
        
        headerView?.tradeEventBlock = {
            [weak self] in
            
            if let tradeEventBlock = self?.tradeEventBlock {
                tradeEventBlock()
            }
            
            self?.navigationController?.popToRootViewController(animated: false)
        }
        
        /// 成交明细tableview
        historyTableView = UITableView(frame: CGRect.zero, style: .plain)
        historyTableView.showsVerticalScrollIndicator = false
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.separatorStyle = .none
        historyTableView.backgroundColor = COLOR_TabBarBgColor
        self.view.addSubview(historyTableView)
        
        historyTableView.register(UINib(nibName: "FCTradingHistoryDetailCell", bundle: Bundle.main), forCellReuseIdentifier: cellidentify)
        historyTableView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(headerView!.snp_bottom).offset(8)
            make.bottom.equalToSuperview()
        }
    }
    
    func loadTradingDetailData() {
     
        let historyApi = FCApi_trade_order_fills(orderId: self.historyModel?.orderId ?? "", tradingUnit: FCTradeSettingconfig.sharedInstance.tradingUnitStr, symbol: self.historyModel?.symbol ?? "")
       historyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            self?.historyTableView.endRefresh()
            self?.dataSource?.removeAll()
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] {
                 
                    let records:[AnyObject] = data["fills"] as! [AnyObject]
                    
                    for dic in records {

                        let model = FCHistoryDelModel(dict: dic as! [String : AnyObject])
                        self?.dataSource?.append(model)
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FCContractHistroyDetailVC: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let model = self.dataSource?[indexPath.row]
//        let historyVC = FCContractHistroyDetailVC()
//        historyVC.hidesBottomBarWhenPushed = true
//        historyVC.historyModel = model
//        self.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.sectionHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentify) as? FCTradingHistoryDetailCell
        
        if let cell = cell {
          
            cell.backgroundColor = COLOR_TabBarBgColor
            let model = dataSource?[indexPath.row]
            cell.historyModel = model
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}

