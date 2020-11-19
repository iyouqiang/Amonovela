//
//  FCKLineDealCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCKLineDealCell: UITableViewCell {

    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var bidLab: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var amountLab: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(index: Int, tradeModel: FCKLineTradeModel?) {
        
        self.timeLab.text = tradeModel?.time
        self.bidLab.text = tradeModel?.makerSide == "Ask" ? "卖出" : "买入"
        self.bidLab.textColor = tradeModel?.makerSide == "Ask" ? COLOR_FailColor : COLOR_RiseColor
        self.priceLab.text = tradeModel?.price
        self.amountLab.text = tradeModel?.volume
    }

    
}
