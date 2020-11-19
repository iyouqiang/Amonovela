//
//  FCHistoryDetialHeaderView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCHistoryDetialHeaderView: UIView {

    @IBOutlet weak var symbolTitleL: UILabel!
      @IBOutlet weak var avgFilledPriceL: UILabel!
      @IBOutlet weak var cumFilledVolumeL: UILabel!
      @IBOutlet weak var tradeTypeL: UILabel!
      @IBOutlet weak var entrustTmL: UILabel!
      @IBOutlet weak var entrustPriceL: UILabel!
      @IBOutlet weak var entrustVolumeL: UILabel!
    @IBOutlet weak var leverL: UILabel!
    @IBOutlet weak var actionTypeL: UILabel!
    @IBOutlet weak var commissionL: UILabel!
    var tradeEventBlock: (() -> Void)?
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        // Initialization code
        self.actionTypeL.layer.cornerRadius = 3
        self.actionTypeL.clipsToBounds = true
        //self.lineView.backgroundColor = COLOR_TabBarBgColor
        self.backgroundColor = COLOR_BGColor
        
        self.leverL.layer.cornerRadius = 3
        self.leverL.clipsToBounds = true
    }
    
    @IBAction func gotTradeAction(_ sender: Any) {
        
        if let tradeEventBlock = tradeEventBlock {
            tradeEventBlock()
        }
    }
    
    var historyModel: FCContractHistoryModel? {
        didSet {
            guard let historyModel = historyModel else {
                return
            }
            
            if historyModel.side == "Ask" {
                // 卖出
                self.actionTypeL.backgroundColor = COLOR_FailColor
                                 
                if historyModel.action == "Open" {
                    // 开仓
                    self.actionTypeL.text = "卖出开空"
                }else if (historyModel.action == "Close") {
                    // 平仓
                    self.actionTypeL.text = "卖出平多"
                }else if (historyModel.action == "ADL") {
                    // 自动减仓
                    self.actionTypeL.text = "自动减仓"
                }else {
                    // Liquidation 爆仓强平
                    self.actionTypeL.text = "爆仓强平"
                }
            }else {
                           
                self.actionTypeL.backgroundColor = COLOR_RiseColor
                if historyModel.action == "Open" {
                    // 开仓
                    self.actionTypeL.text = "买入开多"
                }else if (historyModel.action == "Close") {
                    // 平仓
                    self.actionTypeL.text = "买入平空"
                }else if (historyModel.action == "ADL") {
                    // 自动减仓
                    self.actionTypeL.text = "自动减仓"
                }else {
                    // Liquidation 爆仓强平
                    self.actionTypeL.text = "爆仓强平"
                }
            }
                     
            self.entrustVolumeL.text = "\(historyModel.entrustVolume ?? "")"
            self.cumFilledVolumeL.text = "\(historyModel.cumFilledVolume ?? "")"
                     
            self.entrustPriceL.text = "₮\(historyModel.entrustPrice ?? "")"
            self.entrustTmL.text = "\(historyModel.entrustTm ?? "")"
                     
            if (historyModel.tradeType == "Limit") {
                         
                self.tradeTypeL.text = "限价委托"
            }else {
                self.tradeTypeL.text = "市价委托"
            }
                     
            self.avgFilledPriceL.text = "₮\(historyModel.avgFilledPrice ?? "")"
            
            self.commissionL.text = historyModel.commission
            self.leverL.text = historyModel.leverage
            self.symbolTitleL.text = "\(historyModel.symbol ?? "") 永续"
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
