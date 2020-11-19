//
//  FCBillContractController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/31.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCBillContractController: UIViewController {

    var dataSource:[FCBillContractModel]? = []
    var contractTableView: UITableView!
    let cellidentify = "FCBillContractCell"
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无账单数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "合约账单"
        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        
        self.requesntBillContractData()
        
        contractTableView = UITableView(frame: CGRect.zero, style: .grouped)
        contractTableView.showsVerticalScrollIndicator = false
        contractTableView.delegate = self
        contractTableView.dataSource = self
        contractTableView.separatorStyle = .none
        contractTableView.backgroundColor = COLOR_TabBarBgColor
        self.view.addSubview(contractTableView)
               
        contractTableView.register(UINib(nibName: "FCBillContractCell", bundle: Bundle.main), forCellReuseIdentifier: cellidentify)
        contractTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        contractTableView.refreshNormalModelRefresh(false, refreshDataBlock: {
            [weak self] in
            self?.requesntBillContractData()
        }, loadMoreDataBlock: nil)
    }
    
    func requesntBillContractData() {
        
        let tradingUnit = FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT ? "CONT" : "COIN"
        
        let timestampStr = NSString.timestampTo()
        let startDate = currentDateToWantDate(year: 0, month: -6, day: 0)
        
        let startTimestamp = NSString.dateTotimestamp(startDate)
        
        let startTime: String = (startTimestamp! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        let endTime: String = (timestampStr! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        
        let billApi = FCApi_records_search(startTime: startTime, endTime: endTime, tradingUnit: tradingUnit)
        billApi.startWithCompletionBlock(success: { [weak self] (response) in
            self?.contractTableView.endRefresh()
            self?.dataSource?.removeAll()
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] {
                 
                    let records:[AnyObject] = data["records"] as! [AnyObject]
                    
                    for (_, dic) in records.enumerated() {
                        
                        let model = FCBillContractModel(dict: dic as! [String : AnyObject])
                            self?.dataSource?.append(model)
                    }
                }
                
            }else {
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
            DispatchQueue.main.async {
                
                if (self?.dataSource?.count == 0) {
                    
                    self?.contractTableView.tableFooterView = self?.footerHint
                }else {
                    
                    self?.contractTableView.tableFooterView = nil
                }
               self?.contractTableView.reloadData()
            }
            
        }) { [weak self] (response) in
            
            self?.contractTableView.endRefresh()
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

extension FCBillContractController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentify) as? FCBillContractCell
        
        if let cell = cell {
          
            cell.backgroundColor = COLOR_BGColor
            let model = dataSource?[indexPath.row]
            cell.model = model
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 8.0
    }
}
 
