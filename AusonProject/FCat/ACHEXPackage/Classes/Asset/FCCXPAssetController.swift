//
//  FCCXPAssetController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift

class FCCXPAssetController: UIViewController {
    private let cellReuseCommonAssetIdentifier = "FCCXPCommonAssetCell"
    private let cellReuseSustainableIdentifier = "FCCXPSustainableContractCell"
    private let cellReuseGlobalContractIdentifier = "FCCXPGlobalContractCell"
    var dataSource:[FCCXPAssetModel]? = [FCCXPAssetModel]()
    
    var assetSummaryModel: FCCXPAssetModel?
    
    var accountTitleL: UILabel?
    var accountAssetL: UILabel?
    
    /// 币币
    var spotAssetModel:FCCXPAssetModel?
    // 发布
    var otcAssetModel:FCCXPAssetModel?
    // 永续合约
    var swapAssetModel:FCCXPAssetModel?
    
    let disposeBag = DisposeBag()
    var assetSubscription: Disposable?
    
    private lazy var assetTableView:UITableView = {
        
        let assetTableView = UITableView.init(frame: self.view.bounds, style: .grouped)
        assetTableView.dataSource = self
        assetTableView.delegate = self
        //assetTableView.rowHeight = 100.0
        assetTableView.showsVerticalScrollIndicator = false
        assetTableView.separatorStyle = .none
        assetTableView.separatorColor = COLOR_LineColor
        assetTableView.layer.masksToBounds = true
        assetTableView.backgroundColor = COLOR_BGColor
        assetTableView.register(UINib(nibName: "FCCXPCommonAssetCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseCommonAssetIdentifier)
        assetTableView.register(UINib(nibName: "FCCXPSustainableContractCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseSustainableIdentifier)
        assetTableView.register(UINib(nibName: "FCCXPGlobalContractCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseGlobalContractIdentifier)
        
        self.view.addSubview(assetTableView)
        assetTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(0)
        }
        
        return assetTableView
    }()
    
    private lazy var accountInfoView: UIView = {
       
        let containerView = UIView(frame: CGRect(x: 0, y: 10, width: kSCREENWIDTH, height: 165))
        
        let contentView = UIView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: containerView.frame.height))
        contentView.backgroundColor = COLOR_HexColor(0x25262C)
        containerView.addSubview(contentView)
        let accountTitleL = fc_labelInit(text: "总账户资产折合（BTC）", textColor: COLOR_CellTitleColor, textFont: 14, bgColor: .clear)
        self.accountTitleL = accountTitleL
        contentView.layer.cornerRadius = 8
        contentView.addSubview(accountTitleL)
        accountTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(20)
            make.right.equalTo(-20)
            make.top.equalTo(20)
        }
        
        let accountAssetL = fc_labelInit(text: "0.00", textColor: COLOR_White, textFont: 14, bgColor: .clear)
        self.accountAssetL = accountAssetL
        contentView.addSubview(accountAssetL)
        accountAssetL.snp.makeConstraints { (make) in
            make.left.equalTo(accountTitleL.snp_left)
            make.right.equalTo(accountTitleL.snp_right)
            make.top.equalTo(accountTitleL.snp_bottom).offset(15)
        }
        
        let btnWidth = (contentView.frame.width - 20 * 4)/3.0
        let btnHeight = 33
        
        let  titles = ["划转", "提币", "充币"]
        let imageNames = ["asset_transfer", "asset_mentionCoin", "asset_chargeCoin"]
        
        for i in 0..<titles.count {
            
            let btn = fc_buttonInit(imgName: imageNames[i], title: titles[i], fontSize: 14, titleColor: COLOR_CellTitleColor, bgColor: COLOR_HexColor(0x292b33))
            btn.backgroundColor = COLOR_HexColor(0x26282C)
            btn.clipsToBounds = true
            btn.layer.cornerRadius = 5
            btn.layer.borderWidth = 2
            btn.layer.borderColor = COLOR_HexColor(0x323338).cgColor
            contentView.addSubview(btn)
            btn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            btn.tag = 100 + i
            btn.addTarget(self, action: #selector(accountInfoOptionalEvent(sender:)), for: .touchUpInside)
            
            btn.snp.makeConstraints { (make) in
                make.left.equalTo((20 + CGFloat(i)*(btnWidth + 20.0)))
                make.width.equalTo(btnWidth)
                make.height.equalTo(btnHeight)
                make.top.equalTo(accountAssetL.snp_bottom).offset(30)
            }
        }
        
        return containerView
    }()
    
    private lazy var menuView:FCQuickNavView = {
        
        var items: [FCAlertItemModel] = []
        let  titles = ["划转", "提币", "充币"]
        let imageNames = ["asset_transfer", "asset_mentionCoin", "asset_chargeCoin"]
        let itemEnables = [true, true, true]
        for i in 0..<titles.count {
            let model = FCAlertItemModel(title: titles[i], imageName: imageNames[i], isEnabled: itemEnables[i])
            items.append(model)
        }
        
        let menuView = FCQuickNavView.init(items: items, itemMaxShowCountForColumn: 3) { [weak self] (itemModel, index) in
            
            if itemModel.title == "提币" {
                
                let mentionCoinVC = FCCXPAssetOptionController()
                //mentionCoinVC.title = "提币"
                mentionCoinVC.assetOptionType = .AssetOptionType_withdraw
                mentionCoinVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(mentionCoinVC, animated: true)
            }else if (itemModel.title == "充币") {
                
                let mentionCoinVC = FCCXPAssetOptionController()
                //mentionCoinVC.title = "充币"
                mentionCoinVC.assetOptionType = .AssetOptionType_deposit
                mentionCoinVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(mentionCoinVC, animated: true)
            }else if (itemModel.title == "划转") {
                
                //PCCustomAlert.showAppInConstructionAlert()
                let transferVC =  FCCXPAssetTransferController()
                transferVC.otcAssetModel = self?.otcAssetModel
                transferVC.spotAssetModel = self?.spotAssetModel
                transferVC.swapAssetModel = self?.swapAssetModel
                transferVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(transferVC, animated: true)
            }
        }
        
        menuView.frame = CGRect(x: 15, y: 10, width: kSCREENWIDTH-30, height: 110)
        menuView.layer.cornerRadius = 10
        menuView.clipsToBounds = true
        return menuView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshAssetData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.assetSubscription?.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = COLOR_BGColor
        // Do any additional setup after loading the view.
        
        self.addleftNavigationItemImgNameStr("", title: "资产", textColor: .white, textFont: UIFont.systemFont(ofSize: 22)) {
        }
        
        //adjuestInsets()
        
        self.navigationItem.title = ""
        
        /// 刷新资产数据
        self.assetTableView.refreshNormalModelRefresh(true, refreshDataBlock: { [weak self] in
            self?.loadAssetData()
        }, loadMoreDataBlock: nil)
    }
    
    // 定时轮询行情列表
    func refreshAssetData() {
        
      self.assetSubscription?.dispose()
      let observable = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance).subscribe {[weak self] (num) in
            
            self?.loadAssetData()
        }
        observable.disposed(by: self.disposeBag)
        self.assetSubscription = observable
    }
    
    func loadAssetData() {
        let assetApi = FCApi_account_overview()
        assetApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            self?.dataSource?.removeAll()
            let responseData = response.responseObject as?  [String : AnyObject]
                       
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                      
                if let data = responseData?["data"] as? [String : Any] {
                    
                    if let accounts = data["accounts"] as? [Any] {
                        
                        for dic in accounts {
                            
                            let assetModel = FCCXPAssetModel.init(dict: dic as! [String : AnyObject])
                            self?.dataSource?.append(assetModel)
                            if assetModel.accountType == "Spot" {
                                self?.spotAssetModel = assetModel
                            }else if (assetModel.accountType == "Otc") {
                                self?.otcAssetModel = assetModel
                            }else if (assetModel.accountType == "Swap") {
                                self?.swapAssetModel = assetModel
                            }else {
                               
                            }
                        }
                    }
                    
                    if let assetSummary = data["assetSummary"] as? [String : AnyObject] {
                        
                        let assetSummaryModel = FCCXPAssetModel.init(dict: assetSummary )
                        self?.accountTitleL?.text = "总账号资产折合（\(assetSummaryModel.digitAsset ?? "")）"
                        self?.accountAssetL?.text = "\(assetSummaryModel.digitEquity ?? "")  ≈\(assetSummaryModel.fiatEquity ?? "") \(assetSummaryModel.fiatAsset ?? "")"
                        self?.assetSummaryModel = assetSummaryModel
                        
                        /// 资产上色
                        self?.accountAssetL?.setAttributeFont(UIFont.systemFont(ofSize: 26), attributeColor: COLOR_BtnTitleColor, range: NSRange(location: 0, length: assetSummaryModel.digitEquity?.count ?? 0), lineSpacing: 10)
                    }
                }
            }
            self?.assetTableView.reloadData()
            self?.assetTableView.endRefresh()
        }) { [weak self] (response) in
            self?.assetTableView.endRefresh()
        }
}
    
   @objc func accountInfoOptionalEvent(sender: UIButton) {
        
    if sender.tag == 100 {
        
        let transferVC =  FCCXPAssetTransferController()
        transferVC.otcAssetModel = self.otcAssetModel
        transferVC.spotAssetModel = self.spotAssetModel
        transferVC.swapAssetModel = self.swapAssetModel
        transferVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(transferVC, animated: true)

    }else if (sender.tag == 101){
        
        let mentionCoinVC = FCCXPAssetOptionController()
        //mentionCoinVC.title = "提币"
        mentionCoinVC.assetOptionType = .AssetOptionType_withdraw
        mentionCoinVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mentionCoinVC, animated: true)
    
    }else {
        
        let mentionCoinVC = FCCXPAssetOptionController()
        //mentionCoinVC.title = "充币"
        mentionCoinVC.assetOptionType = .AssetOptionType_deposit
        mentionCoinVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(mentionCoinVC, animated: true)
        
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

extension FCCXPAssetController: UITableViewDataSource, UITableViewDelegate
{
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          
        return  self.dataSource?.count ?? 0
        
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if indexPath.row < 2 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseCommonAssetIdentifier) as? FCCXPCommonAssetCell else {
                    
                    return UITableViewCell()
                }
                
                if (indexPath.row == 0) {
                    
                    cell.assetModel = self.spotAssetModel
                }else if (indexPath.row == 1) {
                   
                    cell.assetModel = self.otcAssetModel
                }
                
                return cell
                
            }else if indexPath.row == 2 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseSustainableIdentifier) as? FCCXPSustainableContractCell else {
                    
                    return UITableViewCell()
                }
                
                cell.assetModel = swapAssetModel
                return cell
                
            }else if indexPath.row == 3 {
                
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseGlobalContractIdentifier) as? FCCXPGlobalContractCell else {
                    
                    return UITableViewCell()
                }
            
                return cell
                
            }else {
                
                return UITableViewCell()
            }
        }
        
        func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 175))
            headerView.addSubview(self.accountInfoView)
            headerView.layer.cornerRadius = 10.0
            headerView.clipsToBounds = true
            return headerView
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 185
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if indexPath.row < 2 {
                return 145
            }else if (indexPath.row == 2) {
                return 185
            }else if (indexPath.row == 3) {
                return 185
            }
            return 120
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            
            //let symbolModel = dataSource?[indexPath.row]
            
            if indexPath.row == 0 {
                /// 币币界面
                let accountAssetController = FCAccountAssetController()
                accountAssetController.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(accountAssetController, animated: true)
            }else if (indexPath.row == 2) {
                
                /// 持仓界面
                //let positionController = FCContractPositionController()
                //self.navigationController?.pushViewController(positionController, animated: true)
                kAPPDELEGATE?.tabBarViewController.showContractAccount()
            }else {
                
                FCUserInfoManager.sharedInstance.loginState { (model) in
                    let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_ASSETS))!
                    webVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }
    }
}
