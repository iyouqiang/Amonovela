//
//  FCCXPAssetTransferController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/1.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class FCCXPAssetTransferController: UIViewController {
    
    @IBOutlet weak var symbolL: UILabel!
    @IBOutlet weak var fromtransferL: UILabel!
    @IBOutlet weak var totransferL: UILabel!
    @IBOutlet weak var exchangeBtn: UIButton!
    @IBOutlet weak var bgView1: UIView!
    @IBOutlet weak var bgView2: UIView!
    @IBOutlet weak var bgView3: UIView!
    @IBOutlet weak var allTransferBtn: UIButton!
    @IBOutlet weak var transferMaxNumL: UILabel!
    @IBOutlet weak var transferbaseView: UIView!
    @IBOutlet weak var transferTextField: UITextField!
    
    @IBOutlet weak var symbolArrowIcon: UIImageView!
    
    @IBOutlet weak var firstArrowIcon: UIButton!
    
    @IBOutlet weak var secondArrowIcon: UIButton!
    
    let disposebag = DisposeBag()
    var configBtn:FCThemeButton!
    
    /// 判断第一个账户是 币币账号 还是 可以划转账号
    var actionStr: String = "accounts"
    /// 默认币币账号--> 永续合约账户
    var firstAccount: String = "Spot"
    var secondAccount: String = "Swap" // 发布账号 OTC
    var maxBalance: Double?
    var assetsArray = [FCAllAssetsConfigModel]()
    var currentAssetModel: FCSupportSubAsset?
    var accountConfigModel: FCTransferConfigModel?
    var currentOptionalModel: FCTransferConfigSubModel?
    var currentAccountsModel: FCTransferConfigSubModel?
    var supportAssetsModel: FCSupportAssetsModel?
    
    /// 币币
    var spotAssetModel:FCCXPAssetModel?
    // 发布
    var otcAssetModel:FCCXPAssetModel?
    // 永续合约
    var swapAssetModel:FCCXPAssetModel?
    
    /// 币的下拉菜单
    lazy var assetsdropDown: DropDown = {
        
        let dropMoreAssetsDown = DropDown()
        dropMoreAssetsDown.anchorView = symbolL
        dropMoreAssetsDown.textFont = UIFont.init(_customTypeSize: 14)
        dropMoreAssetsDown.textColor = COLOR_PrimeTextColor
        dropMoreAssetsDown.cellHeight = 36
        dropMoreAssetsDown.selectionBackgroundColor = .clear
        dropMoreAssetsDown.selectedTextColor = COLOR_PrimeTextColor
        dropMoreAssetsDown.bottomOffset = CGPoint(x: 0, y: 30)
        dropMoreAssetsDown.backgroundColor = COLOR_HexColor(0x232529)
        dropMoreAssetsDown.separatorColor = .clear
        dropMoreAssetsDown.shadowOpacity = 0
        
        return dropMoreAssetsDown
    }()
    
    /// 账号的下拉菜单
    lazy var accountDropDown: DropDown = {
        
        let dropMoreAcountDown = DropDown()
        dropMoreAcountDown.anchorView = symbolL
        dropMoreAcountDown.textFont = UIFont.init(_customTypeSize: 14)
        dropMoreAcountDown.textColor = COLOR_PrimeTextColor
        dropMoreAcountDown.cellHeight = 36
        dropMoreAcountDown.selectionBackgroundColor = .clear
        dropMoreAcountDown.selectedTextColor = COLOR_PrimeTextColor
        dropMoreAcountDown.bottomOffset = CGPoint(x: 0, y: 44)
        dropMoreAcountDown.backgroundColor = COLOR_HexColor(0x232529)
        dropMoreAcountDown.separatorColor = .clear
        dropMoreAcountDown.shadowOpacity = 0
        
        return dropMoreAcountDown
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "划转"
        self.edgesForExtendedLayout = .all
        bgView1.backgroundColor = COLOR_BGColor
        bgView2.backgroundColor = COLOR_BGColor
        bgView3.backgroundColor = COLOR_BGColor
        transferbaseView.backgroundColor = COLOR_TabBarBgColor
        self.view.backgroundColor = COLOR_TabBarBgColor
        
        configBtn = FCThemeButton.init(title: "确定划转", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        self.view.addSubview(configBtn)
        configBtn.snp.makeConstraints { (make) in
                 
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(50)
            make.top.equalTo(self.transferbaseView.snp_bottom).offset(20)
        }
        
        self.configBtn?.rx.tap.subscribe({ [weak self] (event) in
            
            self?.configureTrasnferData()
        }).disposed(by: disposebag)
        
        /// 选择币种
        self.assetsdropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.configListView(index: index)
        }
        
        /// 选择合约账户
        self.accountDropDown.selectionAction = {
            [weak self] (index: Int, item: String) in
            
            if let opponentAccounts = self?.accountConfigModel?.opponentAccounts {
                let model = opponentAccounts[index]
                self?.currentOptionalModel = model
                
                if self?.actionStr == "accounts" {
                           
                    self?.totransferL.text = model.name
                    self?.secondAccount = model.type ?? ""
                }else {
                           
                    self?.firstAccount = model.type ?? ""
                    self?.fromtransferL.text = model.name
                }
            }
            
            /// 切换划转合约后，支持的币种
            self?.requestTransferSupportAssets()
        }
        
        /// 获取账户配置信息
        requestTransferconfigData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.transferTextField.becomeFirstResponder()
    }
    
    @IBAction func showSymbolListView(_ sender: UIButton) {
        
        if self.assetsdropDown.dataSource.count > 0 {
            
            self.assetsdropDown.show()
        }else {
            
            self.requestTransferSupportAssets()
        }
    }
    
    @IBAction func exchangeAction(_ sender: Any) {
        
        self.transferTextField.text = ""
        
        // 币币
        let accounts = self.accountConfigModel?.accounts
        let acountConfigModel = accounts?.first
        
        if self.actionStr == "accounts" {
            
            /// 合约或者法币账户
            self.actionStr = "opponentAccounts"
            self.firstArrowIcon.isHidden = false
            self.secondArrowIcon.isHidden = true
            self.accountDropDown.anchorView = self.firstArrowIcon
            self.fromtransferL.text = currentOptionalModel?.name
            self.totransferL.text = acountConfigModel?.name
            self.firstAccount = currentOptionalModel?.type ?? ""
            self.secondAccount = acountConfigModel?.type ?? ""
            
        }else {
            
            /// 币币账户
            self.actionStr = "accounts"
            self.firstArrowIcon.isHidden = true
            self.secondArrowIcon.isHidden = false
            self.accountDropDown.anchorView = self.secondArrowIcon
            self.fromtransferL.text = acountConfigModel?.name
            self.totransferL.text = currentOptionalModel?.name
            self.firstAccount = acountConfigModel?.type ?? ""
            self.secondAccount = currentOptionalModel?.type ?? ""
        }
        
        /// 切换后，支持的币种
        
        /// 资产配置
        refreshAssetData(asset: symbolL.text ?? "")
    }
    
    
    @IBAction func secondAccountAciton(_ sender: UIButton) {
        
        if self.actionStr == "accounts" {
             self.accountDropDown.show()
        }
    }
    
    @IBAction func firstAcountAction(_ sender: UIButton) {
        
        if self.actionStr == "opponentAccounts" {
            
             self.accountDropDown.show()
        }
    }
    
    @IBAction func allTransferAction(_ sender: Any) {
        
        self.transferTextField.text = String(format: "%.4f", self.maxBalance ?? 0)
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

extension FCCXPAssetTransferController {
    
    
    /// 获取支持的币种
    func requestTransferSupportAssets() {
        
        /// 合约 法币 --> 币币
        var tmepFirstAccount = currentOptionalModel?.type ?? ""
        var tmepsecondAccount = currentAccountsModel?.type ?? ""
        
        if  self.actionStr == "accounts" {
            /// 币币 --> 合约 法币
            tmepFirstAccount = currentAccountsModel?.type ?? ""
            tmepsecondAccount = currentOptionalModel?.type ?? ""
        }
        
        /// 获取支持的币种
        let supportAssets = FCApi_support_transfer_assets(firstAccount: tmepFirstAccount, secondAccount: tmepsecondAccount)
        supportAssets.startWithCompletionBlock(success: { [weak self] (response) in
            
            /// 刷新币种下拉菜单，默认选择第一个
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                
                /// 当前账户支持的币种信息
                let supportModel = FCSupportAssetsModel.stringToObject(jsonData: resData)
                self?.supportAssetsModel = supportModel
                self?.symbolL.text = supportModel.defaultAsset ?? ""
                /// 获取资产配置信息
                self?.refreshAssetData(asset: supportModel.defaultAsset ?? "")
                /// 有多个币种，可以下拉菜单
                var titleArray = [String]()
                
                if let supportAssets = supportModel.supportAssets {
                    
                    for model in supportAssets {
                        titleArray.append(model.asset ?? "")
                    }
                    
                    if titleArray.count > 1 {
                        self?.symbolArrowIcon.isHidden = false
                        self?.assetsdropDown.dataSource = titleArray
                    }else {
                        self?.symbolArrowIcon.isHidden = true
                        self?.assetsdropDown.dataSource = []
                    }
                }
                
             }) { (errMsg) in
                
                 self?.view.makeToast(errMsg ?? "", position: .center)
             }
            
        }) { (response) in
            
        }
    }
    
    /// 获取划转账号配置
    func requestTransferconfigData() {
        
        let transferApi = FCApi_transfer_config()
        transferApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            /// 账户配置model
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                
                let configModel = FCTransferConfigModel.stringToObject(jsonData: resData)
                
                self?.accountConfigModel = configModel
                
                /// 配置初始化数据
                self?.congfigTransferAccount()
                
                /// 获取支持的币种
                self?.requestTransferSupportAssets()
                
             }) { (errMsg) in
                
                 self?.view.makeToast(errMsg ?? "", position: .center)
             }
            
        }) { (response) in
            
        }
    }
    
    /// 获取自己划转数据
    func refreshAssetData(asset: String) {
        
        /**
         data =     {
             firstAccount =         {
                 asset = USDT;
                 balance = "30616.34";
                 name = USDT;
             };
             secondAccount =         {
                 asset = USDT;
                 balance = "66104.5076";
                 name = USDT;
             };
         };
         */
        let transferApi = FCApi_transfer_accounts(firstAccount: self.firstAccount, secondAccount: self.secondAccount, asset: asset)
        transferApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
             if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                 
                 if let data = responseData?["data"] {
                  
                    let account = JSON(data)
                    let dic = account["firstAccount"].dictionaryValue
                    let balance = dic["balance"]?.doubleValue
                    self?.maxBalance = balance
                    self?.transferMaxNumL.text = String(format: "%.4f", balance ?? 0) + " \(self?.symbolL?.text ?? "")"
                 }
                 
             }else {
                 
                 let errMsg = responseData?["err"]?["msg"] as? String
                 self?.view.makeToast(errMsg ?? "", position: .center)
             }

        }) { (response) in
            
        }
    }
    
    /**
     
     data =     {
         accounts =         (
                         {
                 isOptional = 0;
                 name = "\U5e01\U5e01\U8d26\U6237";
                 type = Spot;
             }
         );
         opponentAccounts =         (
                         {
                 isOptional = 1;
                 name = "\U5408\U7ea6\U8d26\U6237";
                 type = Swap;
             },
                         {
                 isOptional = 1;
                 name = "\U6cd5\U5e01\U8d26\U6237";
                 type = Otc;
             }
         );
     };
     
     */
    
    /// 界面配置，获取划转资产数据
    func configListView(index: Int) {
    
        if supportAssetsModel?.supportAssets?.count ?? 0 <= index{
            return
        }
        
        if let supportAssets = supportAssetsModel?.supportAssets {
            
            let configModel = supportAssets[index]
            currentAssetModel = configModel
            symbolL.text = configModel.asset
            refreshAssetData(asset: configModel.asset ?? "")
        }
    }
    
    func configureTrasnferData() {
        
        // Action操作类型有 Deposit: 入金，Withdrawal: 出金
        let transferValue = Double(self.transferTextField.text ?? "0.00") ?? 0.0
        if (transferValue > (self.maxBalance ?? 0.0) || transferValue == 0.0) {
            
            PCAlertManager.showAlertMessage("划转数据不正确")
            
            return
        }
        
        let volumeStr = self.transferTextField.text ?? "0.00";
        let volume = (volumeStr as NSString).floatValue
        var asset = self.currentAssetModel?.asset ?? ""
        if asset.count == 0 {
            asset = self.supportAssetsModel?.defaultAsset ?? ""
        }
        
        let transferApi = FCApi_fund_transfer(fromAccount: self.firstAccount, toAccount: self.secondAccount, asset: asset, amount: volume)
        
        transferApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                PCAlertManager.showAlertMessage("划转成功")
                //self?.navigationController?.popViewController(animated: true)
                
            }else {
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
            self?.refreshAssetData(asset: self?.symbolL.text ?? "")
            
        }) { (resposne) in
            
        }
         
    }
    
    /// 配置划转账户
    func congfigTransferAccount() {
        
        // 币币
        let accounts = self.accountConfigModel?.accounts
        let acountConfigModel = accounts?.first
        currentAccountsModel = acountConfigModel
        
        // 合约 法币
        let opponentAccounts = self.accountConfigModel?.opponentAccounts
        currentOptionalModel = opponentAccounts?.first
        
        /// 上面为币币账户
        self.fromtransferL.text = acountConfigModel?.name
        self.totransferL.text = currentOptionalModel?.name
        self.firstAccount = acountConfigModel?.type ?? ""
        self.secondAccount = currentOptionalModel?.type ?? ""
        
        var titleArray = [String]()
        if let opponentAccounts = self.accountConfigModel?.opponentAccounts {
            
            for model in opponentAccounts {
                
                titleArray.append(model.name ?? "")
            }
            
            if titleArray.count > 1 {
                self.accountDropDown.dataSource = titleArray
            }else {
                self.accountDropDown.dataSource = []
            }
            
            self.firstArrowIcon.isHidden = true
            self.secondArrowIcon.isHidden = false
            self.accountDropDown.anchorView = self.secondArrowIcon
        }
        
        /**
        if self.actionStr == "accounts" {
            
            self.actionStr = "opponentAccounts"
            /// 上面为币币账户
            self.fromtransferL.text = acountConfigModel?.name
            self.totransferL.text = currentOptionalModel?.name
            self.firstAccount = acountConfigModel?.type ?? ""
            self.secondAccount = currentOptionalModel?.type ?? ""
            
        }else {
            
            self.actionStr = "accounts"
            /// 合约、法币账号
            self.fromtransferL.text = currentOptionalModel?.name
            self.totransferL.text =  acountConfigModel?.name
            
            self.firstAccount = currentOptionalModel?.type ?? ""
            self.secondAccount = acountConfigModel?.type ?? ""
            
        }
         */
    }
}
