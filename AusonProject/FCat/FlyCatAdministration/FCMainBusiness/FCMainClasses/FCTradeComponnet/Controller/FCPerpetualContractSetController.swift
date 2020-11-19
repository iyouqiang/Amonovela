//
//  FCPerpetualContractSetController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/26.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCPerpetualContractSetController: UIViewController {
    
    var marketModel: FCMarketModel?
    var settingTableView: UITableView!
    var dataSource: [AnyObject]? = []
    let cellReuseIdentifier = "FCContractSettingCell"
    var settingModel: FCTradeSettingModel?
    var tradingUnitStr: String = FCTradeSettingconfig.sharedInstance.tradingUnitStr
    var contractAsset = ""
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()
    
    
    private lazy var switchableDesView: UIView? = {
        
        let sctionView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 50))
        let titleL = fc_labelInit(text: "", textColor: COLOR_RichBtnTitleColor, textFont: UIFont.systemFont(ofSize: 13), bgColor: .clear)
        //titleL.text = "每一张合约代表0.01 BTC≈115.96个USDT"
        titleL.frame = CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 10/**50*/)
        sctionView.addSubview(titleL)
        return sctionView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configSettingTradStrategy()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "永续合约设置"
        self.view.backgroundColor = COLOR_BGColor
        
        settingTableView = UITableView(frame: self.view.bounds, style: .plain)
        settingTableView.backgroundColor = COLOR_TabBarBgColor
        view.addSubview(settingTableView)
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.register(FCContractSettingCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        ///
        settingTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        /// 尾部 保证金说明
        let footerView = Bundle.main.loadNibNamed("FCDepositStatementView", owner: nil, options: nil)?.first as? UIView
        footerView?.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 190)
        settingTableView.tableFooterView = footerView

        loadSettingCofig()
    }
    
    func loadSettingCofig() {
        
        FCTradeSettingconfig.sharedInstance .loadSettingCofig(symbol: FCTradeSettingconfig.sharedInstance.symbol ?? "") { [weak self] (model, errMsg) in
            
            if errMsg.count > 0 {
                self?.view.makeToast(errMsg, position: .center)
                return
            }
            
            self?.dataSource?.removeAll()
            self?.settingModel = model
            self?.configSettingTradStrategy()
        }
    }
    
    func configSettingTradStrategy() {
        
        dataSource?.removeAll()
        let marginModeStr: String = FCTradeSettingconfig.sharedInstance.marginMode == .marginMode_Cross ? "全仓" : "逐仓"
        
        let asset = self.marketModel?.asset ?? ""
        let symbol = FCTradeSettingconfig.sharedInstance.symbol ?? ""
        let symbolArray = symbol.split(separator: "-")
        let unitStr = "\(symbolArray.first ?? "")"
        contractAsset = asset.count == 0 ? unitStr : asset
        
        /// 单位传递
        if (FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN) {
            
            tradingUnitStr = contractAsset
        }else {
            
            tradingUnitStr = "张"
        }

        /// 初始化书籍模型
        let sheetModel = FCContractSetModel(title: "交易单位", descriStr: tradingUnitStr, type: 0)
        let accountModel = FCContractSetModel(title: "永续合约账户模式", descriStr: marginModeStr, type: 0)
        let leverModel = FCContractSetModel(title: "杠杆倍数", descriStr: "", type: 1)
        
        var oneSection = [AnyObject]()
        oneSection.append(sheetModel)
        var twoSeciont = [AnyObject]()
        twoSeciont.append(accountModel)
        twoSeciont.append(leverModel)
        
        dataSource?.append(oneSection as AnyObject)
        dataSource?.append(twoSeciont as AnyObject)
        
        self.settingTableView.reloadData()
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

extension FCPerpetualContractSetController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /// 交易单位切换
        if indexPath.section == 0 {
            
            if indexPath.row == 0 {
                
                #if BS_TARGETCPE

                let tradingUnitVC = FCTradingUnitSwitchController()
                tradingUnitVC.contractAsset = contractAsset
                tradingUnitVC.unitSWitchBlock = {
                    (str) in
                    
                }
                self.navigationController?.pushViewController(tradingUnitVC, animated: true)
                
                #endif
            }
            
        }else if (indexPath.section == 1) {
            
            if indexPath.row == 0 {
            
                if onlyCross {return}
                
                let contractTypeVC =  FCContractAccountTypeController()
                    contractTypeVC.contractTypeSWitchBlock = {
                    (str, marginModeType) in
                    
                        print("永续合约账户模式 ：", str)
                }
                self.navigationController?.pushViewController(contractTypeVC, animated: true)
                
            }else if (indexPath.row == 1) {
                
                /**
                let leverageVC = FCContractLeverageController()
                self.navigationController?.pushViewController(leverageVC, animated: true)
                 */
                
            }else if (indexPath.row == 2) {
                
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let subArray = dataSource?[section]
        return subArray?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
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
            return 10//50
        }else {
            
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? FCContractSettingCell
        
        if let cell = cell {
            
            let subArray = dataSource?[indexPath.section] as? [FCContractSetModel]
            let model = subArray?[indexPath.row]
            cell.model = model
            cell.selectionStyle = .none
            
            if indexPath.section == 1 && indexPath.row == 0 {
                
                cell.arrowImgView.isHidden = onlyCross
            }else {
                cell.arrowImgView.isHidden = !onlyCross
            }
            
            #if BS_TARGETCXP

            if indexPath.section == 0 && indexPath.row == 0 {
                    
                cell.arrowImgView.isHidden = true
            }
                
            #endif
            
            if model?.type == 1 {
                
                cell.shortLeverageBlock = {
                    (type) in
                    let leverageVC = FCContractLeverageController()
                    leverageVC.leverType = type
                    self.navigationController?.pushViewController(leverageVC, animated: true)
                }
                
                cell.longLeverageBlock = {
                    (type) in
                    let leverageVC = FCContractLeverageController()
                    leverageVC.leverType = type
                    self.navigationController?.pushViewController(leverageVC, animated: true)
                }
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
}
