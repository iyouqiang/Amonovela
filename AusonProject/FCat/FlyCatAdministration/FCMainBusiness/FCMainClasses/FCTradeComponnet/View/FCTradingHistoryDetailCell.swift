//
//  FCTradingHistoryDetailCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCTradingHistoryDetailCell: UITableViewCell {

    
    @IBOutlet weak var tradingVolumL: UILabel!
    @IBOutlet weak var tradingPriceL: UILabel!
    @IBOutlet weak var tradingTmL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = COLOR_BGColor
        self.contentView.backgroundColor = COLOR_BGColor
        let lineView = UIView()
        lineView.backgroundColor = COLOR_TabBarBgColor
        self.contentView.addSubview(lineView)
        
        lineView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(5)
            
        }
    }
    
    var historyModel: FCHistoryDelModel? {
        
        didSet {
            
            guard let historyModel = historyModel else {
                return
            }
            
            let timeArray = (historyModel.filledTm ?? "").split(separator: "+").compactMap { "\($0)"}
            let timestr = "\(timeArray.first ?? "0")"
            self.tradingTmL.text = timestr.replacingOccurrences(of: "T", with: " ")
            
            //self.tradingTmL.text = historyModel.filledTm
            self.tradingPriceL.text = "₮\(historyModel.price ?? "")"
            self.tradingVolumL.text = (historyModel.volume ?? "") + (historyModel.currency ?? "")
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
