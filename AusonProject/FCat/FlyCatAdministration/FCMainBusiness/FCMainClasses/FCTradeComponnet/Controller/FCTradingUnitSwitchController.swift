//
//  FCTradingUnitSwitchController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/26.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCTradingUnitSwitchController: UIViewController {

    var unitTableView: UITableView!
    var dataSource: [String]? = []
    let cellReuseIdentifier = "cellReuseIdentifier"
    var indexPath: IndexPath?
    var isOrderTicket = false
    var unitSWitchBlock: ((_ unitStr: String) -> Void)?
    var contractAsset = "币"
    
    private lazy var switchableDesView: UIView? = {
        
        let sctionView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 50))
        let titleL = fc_labelInit(text: "", textColor: COLOR_RichBtnTitleColor, textFont: UIFont.systemFont(ofSize: 13), bgColor: .clear)
        //titleL.text = "每一张合约代表0.01 BTC≈115.96个USDT"
        titleL.frame = CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 50)
        sctionView.addSubview(titleL)
        
        return sctionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        self.title = "交易单位切换"
        
        unitTableView = UITableView(frame: self.view.bounds, style: .plain)
        unitTableView.backgroundColor = COLOR_TabBarBgColor
        view.addSubview(unitTableView)
        unitTableView.delegate = self
        unitTableView.dataSource = self
        unitTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        ///
        unitTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        dataSource?.append("张")
        dataSource?.append(contractAsset)
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

extension FCTradingUnitSwitchController:UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.isOrderTicket {
            
            PCAlertManager.showPanAlertMessage("当前存在挂单持仓单，不能修改 杠杆。")
            
            return
        }
        
        let newCell = tableView.cellForRow(at: indexPath)
        newCell?.accessoryType = .checkmark
        
        if ((self.indexPath != nil) && self.indexPath != indexPath) {
            let oldCell = tableView.cellForRow(at: self.indexPath ?? indexPath)
            oldCell?.accessoryType = .none
        }
        
        if indexPath.row == 0 {
            
            FCTradeSettingconfig.sharedInstance.tradeTradingUnit = .TradeTradingUnitType_CONT
        }else {
            
            FCTradeSettingconfig.sharedInstance.tradeTradingUnit = .TradeTradingUnitType_COIN
        }
        
        if let unitSWitchBlock = self.unitSWitchBlock {
        
            unitSWitchBlock(self.dataSource?[indexPath.row] ?? "")
        }
        
        self.indexPath = indexPath
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
            
            /**
            if (indexPath.row == 0 && self.indexPath == nil) {
                cell.accessoryType = .checkmark;
                self.indexPath = indexPath;
            }else {
                
                cell.accessoryType = .none;
            }
             */
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
                
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
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == 0 {
            return self.switchableDesView
        }else {
            
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 50
        }else {
            
            return 0
        }
    }
    
    
}
