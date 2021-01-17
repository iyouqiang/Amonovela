//
//  FCTransferRecordCell.swift
//  Auson
//
//  Created by Yochi on 2021/1/11.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit

class FCTransferRecordCell: UITableViewCell {

    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var assetL: UILabel!
    @IBOutlet weak var transferTypeL: UILabel!
    @IBOutlet weak var numbL: UILabel!
    @IBOutlet weak var timeL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var transferRecordModel:FCTransferRecordModel? {
        
        didSet{
            guard let transferRecordModel = transferRecordModel else {
                return
            }
            
            self.assetL.text = transferRecordModel.asset
            self.timeL.text = transferRecordModel.time
            self.numbL.text = transferRecordModel.amount
            
            let dic = ["Spot" : "币币", "Otc" : "法币", "Swap" : "合约"]
            let fromAccountStr = dic[transferRecordModel.fromAccount] ?? ""
            let toAccountStr   = dic[transferRecordModel.toAccount] ?? ""
            self.transferTypeL.text = fromAccountStr + "转" + toAccountStr
        }
    }
    
}
