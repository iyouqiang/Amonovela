//
//  FCContractAccountTypeController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/26.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

//public enum MarginModeType: Int {
//    case marginMode_Cross
//    case marginMode_Isolated 
//}

class FCContractAccountTypeController: UIViewController {

     var contractTableView: UITableView!
     var dataSource: [String]? = []
     let cellReuseIdentifier = "cellReuseIdentifier"
     var indexPath: IndexPath?
     var isOrderTicket = false
    var contractTypeSWitchBlock: ((_ unitStr: String, _ marginModeType: MarginModeType) -> Void)?
        
        override func viewDidLoad() {
            super.viewDidLoad()

            // Do any additional setup after loading the view.
            self.view.backgroundColor = COLOR_BGColor
            self.title = "永续合约账户模式"
            
            contractTableView = UITableView(frame: self.view.bounds, style: .plain)
            contractTableView.backgroundColor = COLOR_TabBarBgColor
            view.addSubview(contractTableView)
            contractTableView.delegate = self
            contractTableView.dataSource = self
            contractTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
            
            /// 尾部 保证金说明
            let footerView = Bundle.main.loadNibNamed("FCDepositStatementView", owner: nil, options: nil)?.first as? UIView
            footerView?.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 190)
            contractTableView.tableFooterView = footerView
            
            ///
            contractTableView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
            }
            
            dataSource?.append("全仓保证金")
            dataSource?.append("逐仓保证金")
        }
    
    func changeMarginModel(marginMode: MarginModeType, indexPath: IndexPath) {
        
       let strategyApi = FCApi_trading_strategy_set(accountModeType: marginMode)
        
        strategyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if indexPath.row == 0 {
                 
                    FCTradeSettingconfig.sharedInstance.marginMode = .marginMode_Cross
                }else {
                    FCTradeSettingconfig.sharedInstance.marginMode = .marginMode_Isolated
                }
                
                if let contractTypeSWitchBlock = self?.contractTypeSWitchBlock {
                
                    contractTypeSWitchBlock(self?.dataSource?[indexPath.row] ?? "", FCTradeSettingconfig.sharedInstance.marginMode ?? .marginMode_Cross)
                }
                
                let newCell = self?.contractTableView.cellForRow(at: indexPath)
                  newCell?.accessoryType = .checkmark
                  
                  if ((self?.indexPath != nil) && self?.indexPath != indexPath) {
                      let oldCell = self?.contractTableView.cellForRow(at: self?.indexPath ?? indexPath)
                      oldCell?.accessoryType = .none
                  }
                
                self?.indexPath = indexPath
                 
            } else{
                
                let errMsg = responseData?["err"]?["msg"] as? String
                PCAlertManager.showAlertMessage(errMsg)
            }
            
        }) { (response) in
            
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

extension FCContractAccountTypeController:UITableViewDelegate, UITableViewDataSource {
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            if self.isOrderTicket {
                
                PCAlertManager.showPanAlertMessage("当前存在挂单持仓单，不能修改 杠杆。")
                
                return
            }
            
  
            
            if indexPath.row == 0 {
             
                //FCTradeSettingconfig.sharedInstance.marginMode = .marginMode_Cross
                self.changeMarginModel(marginMode: .marginMode_Cross, indexPath: indexPath)
            }else {
                //FCTradeSettingconfig.sharedInstance.marginMode = .marginMode_Isolated
                self.changeMarginModel(marginMode: .marginMode_Isolated, indexPath: indexPath)
            }

        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return dataSource?.count ?? 0
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
            
            if let cell = cell {
                
                cell.textLabel?.textColor = COLOR_InputText
                cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
                cell.selectionStyle = .none
                let str = dataSource?[indexPath.row]
                cell.textLabel?.text = str
                cell.tintColor = COLOR_TabBarTintColor
                cell.backgroundColor = COLOR_BGColor
                
                if FCTradeSettingconfig.sharedInstance.marginMode == .marginMode_Cross {
                    
                    if (indexPath.row == 0 && self.indexPath == nil) {
                        cell.accessoryType = .checkmark;
                        self.indexPath = indexPath;
                    }else {
                        
                        cell.accessoryType = .none;
                    }
                    
                }else {
                    
                    if (indexPath.row == 0 && self.indexPath == nil) {

                        cell.accessoryType = .none;
                        
                      }else {
                          
                        cell.accessoryType = .checkmark;
                        self.indexPath = indexPath;
                      }
                }
                
                return cell
            }
            
            return UITableViewCell()
        
        }
}
