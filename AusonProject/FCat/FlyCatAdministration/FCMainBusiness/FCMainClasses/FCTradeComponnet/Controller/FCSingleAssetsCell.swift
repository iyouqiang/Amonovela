//
//  FCSingleAssetsCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

protocol FCSingleAssetsCellDelegate : class {
    func singleAssetFold(cell: FCSingleAssetsCell)
    func gotoTradeHistory(assetModel: FCAssetModel)
    func gotoTradeTransfer(assetModel: FCAssetModel)
    func gotoTradeTransaction(assetModel: FCAssetModel)
}

class FCSingleAssetsCell: UITableViewCell {

    @IBOutlet weak var estimateAssetL: UILabel!
    @IBOutlet weak var symbolTitleL: UILabel!
    @IBOutlet weak var symbolIconImgView: UIImageView!
    @IBOutlet weak var assetAvailableL: UILabel!
    
    @IBOutlet weak var assetFreezeL: UILabel!
    @IBOutlet weak var assetEquivalentL: UILabel!
    //@IBOutlet weak var assetFreezeWidth: NSLayoutConstraint!
    @IBOutlet weak var assetAvailWidth: NSLayoutConstraint!
    @IBOutlet weak var assetEquivalentWidth: NSLayoutConstraint!
    @IBOutlet weak var symbolTitleLeading: NSLayoutConstraint!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var tradeTransferBtn: UIButton!
    @IBOutlet weak var tradeHistoryBtn: UIButton!
    @IBOutlet weak var tradeTransactionBtn: UIButton!
    
    weak var cellDelegate: FCSingleAssetsCellDelegate?
    
    var assetModel: FCAssetModel? {
        
        didSet {
            guard let assetModel = assetModel else {
                return
            }
            
            self.symbolTitleL.text = assetModel.asset
            self.assetAvailableL.text = assetModel.available ?? "0.00"
            self.assetFreezeL.text = assetModel.freezed ?? "0.00"
            
            //self.estimateAssetL.text = "折合(\(assetModel.estimatedAsset ?? "CNY"))"
            self.estimateAssetL.text = "折合(CNY)"
            
            self.assetEquivalentL.text = assetModel.estimatedFiatValue ?? "0.00"
            
            self.symbolIconImgView.isHidden = false
            self.symbolTitleLeading.constant = 50
            
            if assetModel.name?.uppercased() == "USDT" {
                
                self.symbolIconImgView.image = UIImage(named: "trade_USDT")
            }else if (assetModel.name?.uppercased() == "HUSD") {
                
                self.symbolIconImgView.image = UIImage(named: "trade_HUSD")
            }else if (assetModel.name?.uppercased() == "BTC") {
                
                self.symbolIconImgView.image = UIImage(named: "trade_BTC")
            }else if (assetModel.name?.uppercased() == "ETH") {
                
                self.symbolIconImgView.image = UIImage(named: "trade_ETH")
            }else {
                
                self.symbolIconImgView.sd_setImage(with: URL(string: (self.assetModel?.assetIcon ?? "")), placeholderImage: UIImage(named: "trade_BTC"), options: .retryFailed, completed: nil)
            }
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        /// 手动适配布局
        let accountWidth = (kSCREENWIDTH - 60)/3.0
        self.assetAvailableL.adjustsFontSizeToFitWidth = true
        self.assetAvailWidth.constant = accountWidth
        self.assetFreezeL.adjustsFontSizeToFitWidth = true
        //self.assetFreezeWidth.constant = accountWidth
        self.assetEquivalentL.adjustsFontSizeToFitWidth = true
        self.assetEquivalentWidth.constant = accountWidth
        
        self.tradeTransferBtn.layer.cornerRadius = 3
        self.tradeTransferBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        self.tradeTransferBtn.layer.borderWidth = 0.7
        self.tradeTransferBtn.setTitleColor(COLOR_TabBarTintColor, for: .normal)
        
        self.tradeHistoryBtn.layer.cornerRadius = 3
        self.tradeHistoryBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        self.tradeHistoryBtn.layer.borderWidth = 0.7
        self.tradeHistoryBtn.setTitleColor(COLOR_TabBarTintColor, for: .normal)
        
        self.tradeTransactionBtn.layer.cornerRadius = 3
        self.tradeTransactionBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        self.tradeTransactionBtn.layer.borderWidth = 0.7
        self.tradeTransactionBtn.setTitleColor(COLOR_TabBarTintColor, for: .normal)
        
        self.menuView.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func tradeHistoryAction(_ sender: Any) {
        self.cellDelegate?.gotoTradeHistory(assetModel: self.assetModel!)
    }
    
    @IBAction func tradeTransferAction(_ sender: Any) {
        self.cellDelegate?.gotoTradeTransfer(assetModel: self.assetModel!)
    }
    
    @IBAction func tradeTransactionAction(_ sender: Any) {
        self.cellDelegate?.gotoTradeTransaction(assetModel: self.assetModel!)
    }
}
