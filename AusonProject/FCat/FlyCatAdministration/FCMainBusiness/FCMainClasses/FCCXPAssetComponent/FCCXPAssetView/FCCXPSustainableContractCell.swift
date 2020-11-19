//
//  FCCXPSustainableContractCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/11.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCCXPSustainableContractCell: UITableViewCell {

    
    @IBOutlet weak var usedMarginWidth: NSLayoutConstraint!
    @IBOutlet weak var digitAssetTitleL: UILabel!
    @IBOutlet weak var assetBgImgView: UIImageView!
    @IBOutlet weak var unrealisedPNLL: UILabel!
    @IBOutlet weak var marginRationL: UILabel!
    @IBOutlet weak var balanceL: UILabel!
    @IBOutlet weak var availableMarginL: UILabel!
    @IBOutlet weak var usedMarginL: UILabel!
    @IBOutlet weak var assetAccountTitleL: UILabel!
    
    @IBOutlet weak var digitAssetEquityL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var assetModel:FCCXPAssetModel? {
        
        didSet {
        guard let assetModel = assetModel else {
            return
        }
        
        self.digitAssetTitleL.text = "账户净值折合(\(assetModel.digitAsset ?? "USDT"))"
        self.digitAssetEquityL.text = assetModel.digitEquity ?? "0.00"
            self.usedMarginL.text = assetModel.marginAccount?.usedMargin
            
         let width:CGFloat = self.usedMarginL.labelWidthMaxHeight(20)
         self.usedMarginWidth.constant = width
            self.availableMarginL.text = self.assetModel?.marginAccount?.availableMargin
            self.balanceL.text = self.assetModel?.marginAccount?.balance
            self.marginRationL.text = self.assetModel?.marginAccount?.marginRatio
            self.unrealisedPNLL.text = self.assetModel?.marginAccount?.unrealisedPNL
            if ((self.assetModel?.marginAccount?.unrealisedPNL! ?? "0.0") as NSString).floatValue > 0.0 {
                
                self.unrealisedPNLL.textColor = COLOR_RiseColor
            }else if (((self.assetModel?.marginAccount?.unrealisedPNL! ?? "0.0") as NSString).floatValue < 0.0) {
                
                self.unrealisedPNLL.textColor = COLOR_FailColor
            }else {
                
            }
        }
    }
    
}
