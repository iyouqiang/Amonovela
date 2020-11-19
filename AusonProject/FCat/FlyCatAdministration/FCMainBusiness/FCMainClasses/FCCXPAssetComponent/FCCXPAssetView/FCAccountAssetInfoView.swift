//
//  FCAccountAssetInfoView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import SnapKit

class FCAccountAssetInfoView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */ 
    let cellReuseIdentifier = "FCSingleAssetsCell"
    var totalAssetView: FCTotalAssetsView?
    var assetModel: FCAssetSummaryModel?
    var hideMicro: Bool?
    weak var parentVC: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = COLOR_BGColor
        
        totalAssetView = Bundle.main.loadNibNamed("FCTotalAssetsView", owner: nil, options: nil)?.first as? FCTotalAssetsView
        totalAssetView?.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 155)
        
        totalAssetView?.hideMicroBlock = {
            [weak self] (hideMicro) in
            
            self?.loadAccountAllAsset(hideMicro: hideMicro)
            self?.hideMicro = hideMicro
        }
        
        self.assetTableView.refreshNormalModelRefresh(false, refreshDataBlock: {
            [weak self] in
            self?.loadAccountAllAsset(hideMicro: self?.hideMicro ?? false)
        }, loadMoreDataBlock: nil)
        
        self.loadAccountAllAsset(hideMicro: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var assetTableView = { () -> UITableView in
        let assetTableView = UITableView.init(frame: .zero, style: .grouped)

        assetTableView.delegate = self
        assetTableView.dataSource = self
        assetTableView.rowHeight = 190.0
        assetTableView.showsVerticalScrollIndicator = false
        //assetTableView.separatorColor = COLOR_TabBarBgColor
        assetTableView.separatorStyle = .none
        assetTableView.layer.masksToBounds = true
        assetTableView.backgroundColor = .clear
        addSubview(assetTableView)
        assetTableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        assetTableView.register(UINib(nibName: "FCSingleAssetsCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentifier)
        return assetTableView
    }()
    
    func loadAccountAllAsset(hideMicro: Bool) {
        
        let assetApi = FCApi_account_all_assets(hideMicro: hideMicro)
        assetApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                let assetsInfo = responseData?["data"] as? [String : AnyObject]
                
                let assetModel = FCAssetSummaryModel.init(dict: assetsInfo ?? [String : AnyObject]())
                self?.assetModel = assetModel
                self?.totalAssetView?.assetSummaryModel = assetModel.summary
                /**
                for _ in 1...5 {
                    
                    let model = FCAssetModel(dict: [String : AnyObject]())
                    model.cellIsFold = true
                    model.name = "USDT"
                    model.asset = "yochi"
                    self?.assetModel?.assets?.append(model)
                }
                 */
            }
            
            self?.assetTableView.reloadData()
            self?.assetTableView.endRefresh()
        }) { [weak self] (response) in
            
            self?.assetTableView.endRefresh()
        }
    }
}

extension FCAccountAssetInfoView:UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? FCSingleAssetsCell
        cell?.cellDelegate?.singleAssetFold(cell: cell!)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.assetModel?.assets?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? FCSingleAssetsCell
        if let cell = cell {
       
            cell.cellDelegate = self
            let singleAssetInfo = self.assetModel?.assets?[indexPath.row]
            cell.assetModel = singleAssetInfo
            
            if singleAssetInfo?.cellIsFold == true {
               
                cell.menuView.isHidden = true
            }else {
                
                cell.menuView.isHidden = false
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.totalAssetView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 155
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let singleAssetInfo = self.assetModel?.assets?[indexPath.row]
        
        if singleAssetInfo?.cellIsFold == false {
        
            return 180
        }else {
            
            return 140
        }
    }
}

extension FCAccountAssetInfoView:FCSingleAssetsCellDelegate
{
    func gotoTradeHistory(assetModel: FCAssetModel) {
        
        let historyVC = FCCXPAssetHistoryController()
        historyVC.hidesBottomBarWhenPushed = true
        historyVC.optionType = .AssetOptionType_all
        historyVC.asset = assetModel.asset!
        self.parentVC?.navigationController?.pushViewController(historyVC, animated: true)
    }
    
    func gotoTradeTransfer(assetModel: FCAssetModel) {
        
        let transferVC =  FCCXPAssetTransferController()
        transferVC.hidesBottomBarWhenPushed = true
        self.parentVC?.navigationController?.pushViewController(transferVC, animated: true)
    }
    
    func gotoTradeTransaction(assetModel: FCAssetModel) {
        
        self.parentVC?.navigationController?.popToRootViewController(animated: true)
    }
    
    func singleAssetFold(cell: FCSingleAssetsCell) {
        
        let indexPath = self.assetTableView.indexPath(for: cell)!
        let singleAssetInfo = self.assetModel?.assets?[indexPath.row]
        singleAssetInfo?.cellIsFold = !(singleAssetInfo?.cellIsFold ?? true)
         self.assetModel?.assets?[indexPath.row] = singleAssetInfo!
        
        if singleAssetInfo?.cellIsFold == true {
            
            cell.menuView.isHidden = false
        }else {
            
            cell.menuView.isHidden = true
        }
        self.assetTableView.beginUpdates()
        self.assetTableView.reloadRows(at: [indexPath], with: .fade)
        self.assetTableView.endUpdates()
    }
}
