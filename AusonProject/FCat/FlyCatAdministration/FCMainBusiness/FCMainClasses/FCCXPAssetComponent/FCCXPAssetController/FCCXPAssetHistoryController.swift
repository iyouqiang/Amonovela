//
//  FCCXPAssetHistoryController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCCXPAssetHistoryController: UIViewController {

    let cellidentify = "FCCCXPAssetHistoryCell"
    var dataSource:[FCWalletOrderInfoModel]?
    var optionType:AssetOptionType?
    var totalNum: Int?
    var asset = ""
    var sectionTitleL: UILabel?
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无历史记录", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()
    
    private lazy var sectionHeaderView: UIView =  {
    
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44))
        sectionHeaderView.backgroundColor = COLOR_BGColor
        
        let titleL = fc_labelInit(text: "", textColor: COLOR_HexColor(0xDADADE), textFont: UIFont.systemFont(ofSize: 21), bgColor: COLOR_BGColor)
        titleL.frame = CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 36)
        sectionHeaderView.addSubview(titleL)
        sectionTitleL = titleL
        
        let lineView = UIView(frame: CGRect(x: 0, y: 36, width: kSCREENWIDTH, height: 8))
        lineView.backgroundColor = COLOR_TabBarBgColor
        sectionHeaderView.addSubview(lineView)
        
        return sectionHeaderView
    }()
    
    lazy var historyTableView = { () -> UITableView in
        let historyTableView = UITableView.init(frame: .zero, style: .plain)
        
        historyTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.rowHeight = 120.0
        
        historyTableView.showsVerticalScrollIndicator = false
        //homeTableView.separatorStyle = .none
        historyTableView.separatorColor = COLOR_TabBarBgColor
        historyTableView.layer.masksToBounds = true
        historyTableView.backgroundColor = .clear
        self.view.addSubview(historyTableView)
        historyTableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNAVIGATIONHEIGHT)
            make.left.right.bottom.equalToSuperview()
        }

        historyTableView.register(UINib(nibName: "FCCCXPAssetHistoryCell", bundle: Bundle.main), forCellReuseIdentifier: cellidentify)
        return historyTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .all
        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        self.title = "历史记录"
        dataSource = [] 
        self.historyTableView.refreshNormalModelRefresh(true, refreshDataBlock: {
            
            [weak self] in
            self?.loadHistoryData(isPullRefresh: true)
            
        }) {
                      
            [weak self] in
            
            if ((self?.dataSource?.count) ?? 0)%10 > 0  {
                 self?.historyTableView.endRefresh()
                return
            }
            self?.loadHistoryData(isPullRefresh: false)
        }
    }
    
    func loadHistoryData(isPullRefresh: Bool){

        guard let userId = FCUserInfoManager.sharedInstance.userInfo?.userId else { return
        }

        var action = "All"

        if optionType == .AssetOptionType_deposit {
            action = "Deposit"
        }else if (optionType == .AssetOptionType_withdraw) {
            action = "Withdrawal"
        }
        
        var page = ((dataSource?.count ?? 0) / 10) + 1
        if isPullRefresh {
            page = 1
        }
        let recordsApi = FCApi_wallet_records.init(userId: userId, action: action, asset: asset, page: page, pageSize: 10, startTime: "", endTime: "")
        recordsApi.startWithCompletionBlock(success: { [weak self] (response) in
            if isPullRefresh {
                self?.dataSource?.removeAll()
            }
            self?.historyTableView.endRefresh()
            
            /// 数据解析
            let responseData = response.responseObject as?  [String : AnyObject]
            if let data = responseData?["data"] as? [String : AnyObject] {
                
                self?.totalNum = data["totalNum"] as? Int
                
                if self?.totalNum == 0 {
                    
                    self?.historyTableView.tableFooterView = self?.footerHint
                    
                }else {
                    
                }
                
                if let walletOrders =  data["walletOrders"] as? [AnyObject] {
                    
                    for walletInfo in walletOrders {
                        
                        let walletModel = FCWalletOrderInfoModel.init(dict: walletInfo as! [String : AnyObject])
                        self?.dataSource?.append(walletModel)
                    }
                }
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

extension FCCXPAssetHistoryController: UITableViewDelegate, UITableViewDataSource
{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellidentify) as? FCCCXPAssetHistoryCell
        if let cell = cell {
            //let selectedBackgroundView = UIView()
            //selectedBackgroundView.backgroundColor = .clear
            //cell.selectedBackgroundView = selectedBackgroundView
            
            if let dataSource = dataSource {
            
                let model = dataSource[indexPath.row]
                cell.walletInfoModel = model
                cell.backgroundColor = COLOR_BGColor
                //cell.contentView.backgroundColor = COLOR_BGColor
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = self.sectionHeaderView
        self.sectionTitleL?.text = self.asset
        return self.dataSource?.count ?? 0 > 0 ? sectionView : UIView()
    }
    
    
}
