//
//  FCCCXPAssetHistoryCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCCCXPAssetHistoryCell: UITableViewCell {

    @IBOutlet weak var typeTitleL: UILabel!
    @IBOutlet weak var symbolNumL: UILabel!
    @IBOutlet weak var optionTimeL: UILabel!
    @IBOutlet weak var stateL: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var walletInfoModel:FCWalletOrderInfoModel? {
        
        didSet {
            
            guard let walletInfoModel = walletInfoModel  else {
                return
            }
            
            if walletInfoModel.state == "已完成" {
                
                self.stateL.textColor = COLOR_HexColor(0xFFAE18)
            }else {
                
                self.stateL.textColor = COLOR_HexColor(0x39cc43)
            }
            
            self.stateL.text = walletInfoModel.state
            self.typeTitleL.text = "普通充币"
            self.optionTimeL.text = walletInfoModel.createTm
            self.symbolNumL.text = walletInfoModel.volume
        }
    }
}
