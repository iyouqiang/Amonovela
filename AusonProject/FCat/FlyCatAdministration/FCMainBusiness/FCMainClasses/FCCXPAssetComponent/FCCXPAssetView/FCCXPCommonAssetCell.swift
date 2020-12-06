//
//  FCCXPCommonAssetCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/11.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCCXPCommonAssetCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.assetBgImageView.backgroundColor = COLOR_navBgColor
        self.contentView.backgroundColor = COLOR_BGColor
        self.fiatEquityL.font = UIFont(_customTypeSize: 14)
        self.assetAccountTitleL.font = UIFont(_customTypeSize: 16)
        self.assetBgImageView.layer.cornerRadius = 8
        self.assetBgImageView.clipsToBounds = true
        self.digitEquityL.font = UIFont(_customTypeSize: 24)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBOutlet weak var digitEquityWidth: NSLayoutConstraint!
    @IBOutlet weak var assetBgImageView: UIImageView!
    @IBOutlet weak var fiatEquityL: UILabel!
    @IBOutlet weak var digitEquityL: UILabel!
    @IBOutlet weak var digitAssetTitleL: UILabel!
    
    @IBOutlet weak var assetAccountTitleL: UILabel!
    
    var assetModel:FCCXPAssetModel? {
        
        didSet {
            
            guard let assetModel = assetModel else {
                return
            }
            
            self.digitAssetTitleL.text = "账户净值折合(\(assetModel.digitAsset ?? "USDT"))"
            self.digitEquityL.text = assetModel.digitEquity ?? "0.00"
             let width:CGFloat = self.digitEquityL.labelWidthMaxHeight(20)
             self.digitEquityWidth.constant = width
             self.fiatEquityL.text = "≈ \(assetModel.fiatEquity ?? "") \(assetModel.fiatAsset ?? "")"
            
            if assetModel.accountType == "spot" {
                
                self.assetAccountTitleL?.text = "币币账户"
                //self.assetBgImageView.image = UIImage(named: "assetcoincoins")
                
            }else if (assetModel.accountType == "Otc") {
                
                self.assetAccountTitleL?.text = "法币账户"
                //self.assetBgImageView.image = UIImage(named: "asset_fiatBg")
            }else {
                
                 //self.assetBgImageView.image = UIImage(named: "assetcoincoins")
            }
        }
    }
    
}
