//
//  FCCXPAssetController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCCXPAssetController: UIViewController {
    private let cellReuseCommonAssetIdentifier = "FCCXPCommonAssetCell"
    private let cellReuseSustainableIdentifier = "FCCXPSustainableContractCell"
    private let cellReuseGlobalContractIdentifier = "FCCXPGlobalContractCell"
    var dataSource:[FCCXPAssetModel]? = [FCCXPAssetModel]()
    
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
        assetTableView.separatorColor = COLOR_BGColor
        assetTableView.layer.masksToBounds = true
        assetTableView.backgroundColor = .clear
        assetTableView.register(UINib(nibName: "FCCXPCommonAssetCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseCommonAssetIdentifier)
        assetTableView.register(UINib(nibName: "FCCXPSustainableContractCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseSustainableIdentifier)
        assetTableView.register(UINib(nibName: "FCCXPGlobalContractCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseGlobalContractIdentifier)
        
        self.view.addSubview(assetTableView)
        assetTableView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalTo(0)
        }
        
        return assetTableView
    }()
    
    private lazy var menuView:FCQuickNavView = {
        
        var items: [FCAlertItemModel] = []
        let  titles = ["划转", "提币", "充币"]
        let imageNames = ["asset_ transfer", "asset_mentionCoin", "asset_chargeCoin"]
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
        
        menuView.frame = CGRect(x: 15, y: 0, width: kSCREENWIDTH-30, height: 110)
        
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
                }
            }
            self?.assetTableView.reloadData()
            self?.assetTableView.endRefresh()
        }) { [weak self] (response) in
            self?.assetTableView.endRefresh()
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
            return self.menuView
        }
        
        func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 110
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            
            if indexPath.row < 2 {
                return 145
            }else if (indexPath.row == 2) {
                return 220
            }else if (indexPath.row == 3) {
                return 220
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
                
                //let webVC = PCWKWebHybridController.init(url: URL(string: String(format: "http://c2c.chainxp.io/assets?token=%@", FCUserInfoManager.sharedInstance.userInfo?.token ?? "")))!
                FCUserInfoManager.sharedInstance.loginState { (model) in
                    let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_MASSETS))!
                    webVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
            }
    }
}
