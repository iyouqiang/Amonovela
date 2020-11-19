//
//  FCTradeHistoryListCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCTradeHistoryListCell: UITableViewCell {
    
    @IBOutlet weak var makerSideLab: UILabel!
    
    @IBOutlet weak var symbolLab: UILabel!
    
    @IBOutlet weak var timeTitleLab: UILabel!
    
    @IBOutlet weak var entrustPriceTitleLab: UILabel!
    
    @IBOutlet weak var entrustAmounttitleLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var entrustPriceLab: UILabel!
    
    @IBOutlet weak var entrustAmountLab: UILabel!
    
    @IBOutlet weak var volumeTitlelab: UILabel!
    
    @IBOutlet weak var tradePriceTitleLab: UILabel!
    
    @IBOutlet weak var tradeAmountTitleLab: UILabel!
    
    @IBOutlet weak var volumeLab: UILabel!
    
    @IBOutlet weak var tradePriceLab: UILabel!
    
    @IBOutlet weak var tradeAmountLab: UILabel!
    
    @IBOutlet weak var oderStatusLab: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = COLOR_BGColor
        self.contentView.backgroundColor = COLOR_BGColor
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadData(model: FCTradeHistroyListModel) {
        let arrayStrings: [String] = model.symbol.split(separator: "-").compactMap { "\($0)" }
        self.makerSideLab.text = model.side == "Bid" ? "买入" : "卖出"
        self.makerSideLab.textColor = model.side == "Bid" ? COLOR_RiseColor : COLOR_FailColor
        self.symbolLab.text = model.symbol
        self.oderStatusLab.text = model.orderStatus == "Filled" ? "已成交" : "已撤销"
        self.entrustPriceTitleLab.text = "委托价\(arrayStrings.last ?? "")"
        self.entrustAmountLab.text = "委托量\(arrayStrings.first ??  "")"
        self.timeLab.text = model.entrustTm
        self.entrustPriceLab.text = model.entrustPrice
        self.entrustAmountLab.text = model.entrustVolume
        self.volumeTitlelab.text = "成交总额\(arrayStrings.last ?? "")"
        self.tradePriceTitleLab.text = "成交均价\(arrayStrings.last ?? "")"
        self.tradeAmountTitleLab.text = "成交量\(arrayStrings.first ?? "")"
        self.volumeLab.text = model.cumFilledAmount
        self.tradePriceLab.text = model.avgFilledPrice
        self.tradeAmountLab.text = model.cumFilledVolume
    }
}
