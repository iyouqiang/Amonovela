//
//  FCContractPositionController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import JXSegmentedView
import RxCocoa
import RxSwift

class FCContractPositionController: UIViewController {

    let cellidentify = "FCContractPositionCell"
    
    var positionHeaderView: FCPositionHeaderView!
    var marketModel: FCMarketModel?
    var positionTableView: UITableView!
    var dataSource: [FCPositionInfoModel]?
    var tradingUnit: String?
    let disposeBag = DisposeBag()
    var positionSubscription: Disposable?
    var currentViewHeightBolcok: ((_ viewHeight: CGFloat, _ acount: FCPositionAccountInfoModel) -> Void)?
    
    //var accountApi: FCApi_Account_info?
    //var positionApi: FCApi_Account_positions?
    var accountInfoModel: FCPositionAccountInfoModel?
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 20)
        return footerHint
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        refreshSybolData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.positionSubscription?.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "合约账户"
        self.view.backgroundColor = COLOR_BGColor
        
        /// symbol tradingUnit 与交易页同步
        self.tradingUnit = "CONT"
        
        dataSource = [FCPositionInfoModel]()
        self.setupView()
        
        self.loadPositionData()
        
        self.loadAccountInfoData()
        
        self.refreshSybolData()
        
        self.positionHeaderView.marginModeBlock = {
            [weak self] in
            let accountTypeVC = FCContractAccountTypeController()
            accountTypeVC.contractTypeSWitchBlock = {
                [weak self] (str, marginModeType) in
                
                if onlyCross == true {return}
                
                if (marginModeType == .marginMode_Cross) {
                    
                    self?.positionHeaderView.marginModeBtn.setTitle("全仓模式 >", for: .normal)
                }else {
                    
                    self?.positionHeaderView.marginModeBtn.setTitle("逐仓模式 >", for: .normal)
                }
            }
            accountTypeVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(accountTypeVC, animated: true)
        }
    }
    
    func shareAccountInfo(positionInfoModel: FCPositionInfoModel) {
        
        let profitShareView = Bundle.main.loadNibNamed("FCProfitLossShareView", owner: nil, options:     nil)?.first as? FCProfitLossShareView
        
        profitShareView?.frame = CGRect(x: 20, y: 0, width: kSCREENWIDTH - 40, height: 520)
        
        profitShareView?.shareModel = positionInfoModel.pnlShare
        
       _ = PCCustomAlert(shareCustomView: profitShareView)
        
    }
        
    // 定时轮询行情列表
    func refreshSybolData() {
        
        self.positionSubscription?.dispose()
        let observable = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance).subscribe {[weak self] (num) in
        
            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                self?.loadAccountInfoData()
                self?.loadPositionData()
            }
        }
        
        observable.disposed(by: self.disposeBag)
        self.positionSubscription = observable
    }
    
    func loadAccountInfoData() {
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            
            self.tradingUnit = "CONT"
        }else {
            
            self.tradingUnit = "COIN"
        }
        
        let userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
        
        if userId.count == 0 {
            return
        }
                 
        //FCApi_Contract_asset
        let accountApi = FCApi_Contract_asset(symbol: self.marketModel?.symbol ?? "BTC-USDT", tradingUnit: self.tradingUnit ?? "")

        accountApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] as? [String : AnyObject] {
                    
                    let accountModel = FCPositionAccountInfoModel(dict: data)
                    self?.accountInfoModel = accountModel
                    
                    self?.positionHeaderView.accountInfoModel = accountModel
                    
                    //let positionNum = ((accountModel.account?.positionNum ?? "0") as NSString).floatValue
                    
                    let positionNum = self?.dataSource?.count
                    
                    if let currentViewHeightBolcok = self?.currentViewHeightBolcok {
                        let viewHeight = (270 * (positionNum ?? 0))
                        currentViewHeightBolcok(CGFloat(viewHeight) + 280, accountModel)
                    }
                }
            }

        }) { (response) in
            
            print(response.error ?? "")
        }
    }
    
    func loadPositionData() {
        
        /// cell 信息
        let positionApi = FCApi_Account_positions(symbol: self.marketModel?.symbol ?? "BTC-USDT", tradingUnit: self.tradingUnit ?? "")
        positionApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] as? [String : AnyObject] {
                    
                    self?.dataSource?.removeAll()
                    let adlRiskLevel: String = data["adlRiskLevel"] as? String ?? ""
                    
                    let positions = data["positions"] as? [AnyObject]
                    
                    if let positions = positions {
                        
                        for dic in positions {
                            
                            let positionModel = FCPositionInfoModel(dict: dic as! [String : AnyObject])
                            positionModel.adlRiskLevel = adlRiskLevel
                            self?.dataSource?.append(positionModel)
                        }
                        
                        self?.positionTableView.reloadData()
                    }
                    
                    if self?.dataSource!.count ?? 0 > 0 {
                        self?.positionTableView.tableFooterView = nil;
                        
                        let positionNum = self?.dataSource?.count
                        
                        if let currentViewHeightBolcok = self?.currentViewHeightBolcok {
                            
                            if let accountModel = self?.accountInfoModel {
                                
                                let viewHeight = (270 * (positionNum ?? 0))
                                currentViewHeightBolcok(CGFloat(viewHeight) + 280, accountModel)
                            }
                        }
                        
                    }else {
                        
                        self?.positionTableView.tableFooterView = self?.footerHint;
                    }
                }
            }else {
                
                self?.dataSource?.removeAll()
                self?.positionTableView.reloadData()
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

extension FCContractPositionController {
    
    func setupView() {
        
        positionTableView = UITableView(frame: CGRect.zero, style: .grouped)
        positionTableView.showsVerticalScrollIndicator = false
        positionTableView.delegate = self
        positionTableView.dataSource = self
        positionTableView.separatorStyle = .none
        positionTableView.backgroundColor = COLOR_BGColor
        self.view.addSubview(positionTableView)
        
        positionTableView.register(UINib(nibName: "FCContractPositionCell", bundle: Bundle.main), forCellReuseIdentifier: cellidentify)
        positionTableView.isScrollEnabled = false
        positionTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        positionHeaderView = Bundle.main.loadNibNamed("FCPositionHeaderView", owner: nil, options: nil)?.first as? FCPositionHeaderView
        positionHeaderView.backgroundColor = COLOR_BGColor
        positionHeaderView.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 250)
        positionTableView.tableHeaderView = positionHeaderView
    }
}

extension FCContractPositionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentify) as? FCContractPositionCell
        
        cell?.sharePosionInfoBlock = {
            positionInfoModel in
            
            self.shareAccountInfo(positionInfoModel: positionInfoModel)
        }
        
        if let cell = cell {
          
            cell.backgroundColor = COLOR_BGColor
            let model = dataSource?[indexPath.row]
            cell.positionModel = model
            cell.accountInfoModel = self.accountInfoModel
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270
    }
}

extension FCContractPositionController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}
