//
//  FCContractHistoryCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/6.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractHistoryCell: UITableViewCell {
    
    @IBOutlet weak var shareItemBtn: UIButton!
    
    @IBOutlet weak var commissionedSourceL: UILabel!
    @IBOutlet weak var profitRateL: UILabel!
    @IBOutlet weak var symbolL: UILabel!
    @IBOutlet weak var orderStatusL: UILabel!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var profitL: UILabel!
    @IBOutlet weak var avgFilledPriceL: UILabel!
    @IBOutlet weak var cumFilledVolumeL: UILabel!
    @IBOutlet weak var tradeTypeL: UILabel!
    @IBOutlet weak var entrustTmL: UILabel!
    @IBOutlet weak var entrustPriceL: UILabel!
    @IBOutlet weak var entrustVolumeL: UILabel!
    @IBOutlet weak var actionTypeL: UILabel!
    
    @IBOutlet weak var cumFilledWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.actionTypeL.layer.cornerRadius = 5
        self.actionTypeL.clipsToBounds = true
        self.lineView.backgroundColor = COLOR_LineColor
        self.backgroundColor = COLOR_CellBgColor
        self.contentView.backgroundColor = COLOR_CellBgColor
        lineView.backgroundColor = COLOR_BGColor
        
        self.shareItemBtn.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        commissionedSourceL.font = UIFont(_DINProBoldTypeSize: 14)
        profitRateL.font = UIFont(_DINProBoldTypeSize: 14)
        symbolL.font = UIFont(_DINProBoldTypeSize: 13)
        orderStatusL.font = UIFont(_PingFangSCTypeSize: 14)
        profitL.font = UIFont(_DINProBoldTypeSize: 14)
        avgFilledPriceL.font = UIFont(_DINProBoldTypeSize: 14)
        tradeTypeL.font = UIFont(_PingFangSCTypeSize: 14)
        cumFilledVolumeL.font = UIFont(_DINProBoldTypeSize: 14)
        entrustTmL.font = UIFont(_DINProBoldTypeSize: 14)
        entrustPriceL.font = UIFont(_DINProBoldTypeSize: 14)
        entrustVolumeL.font = UIFont(_DINProBoldTypeSize: 14)
        actionTypeL.font = UIFont(_DINProBoldTypeSize: 14)
    }
    
    @IBAction func shareItemAction(_ sender: Any) {
        
        guard let model = historyModel else {
            return
        }
        
        let profitShareView = Bundle.main.loadNibNamed("FCProfitLossShareView", owner: nil, options:     nil)?.first as? FCProfitLossShareView
        
        profitShareView?.frame = CGRect(x: 20, y: 0, width: kSCREENWIDTH - 40, height: kSCREENWIDTH - 40)
        
        profitShareView?.shareModel = model.pnlShare
        
       _ = PCCustomAlert(shareCustomView: profitShareView)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    var historyModel: FCContractHistoryModel? {
        
        didSet {
            guard let historyModel = historyModel else {
                return
            }
            
            let shareModel = historyModel.pnlShare
            
            if shareModel?.symbolName?.count == 0 {
                self.shareItemBtn.isHidden = true
                self.profitRateL.isHidden = true
            }else {
                
                self.profitRateL.isHidden = false
                self.shareItemBtn.isHidden = false
            }
            
            self.symbolL.text = historyModel.symbolName

            
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
                    self.actionTypeL.text = "卖出减仓"
                }else {
                    // Liquidation 爆仓强平 平仓
                    self.actionTypeL.text = "卖出平多"
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
                    self.actionTypeL.text = "买入减仓"
                }else {
                    // Liquidation 爆仓强平 // 平仓
                    self.actionTypeL.text = "买入平空"
                }
            }
            
            var unitStr = historyModel.contractAsset ?? ""
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
                unitStr = "张"
            }
            
            self.entrustVolumeL.text = "委托数量 \(historyModel.entrustVolume ?? "")\(unitStr)"
            
            self.cumFilledVolumeL.text = "成交量 \(historyModel.cumFilledVolume ?? "")"
            
            self.entrustPriceL.text = "委托价格 \(historyModel.entrustPrice ?? "")"
            self.entrustPriceL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 4))
            self.entrustTmL.text = "委托时间 \(historyModel.entrustTm ?? "")"
            self.entrustTmL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 4))
            
            if (historyModel.tradeType == "Limit") {
                
                self.tradeTypeL.text = "委托类型 限价委托"
            }else {
                self.tradeTypeL.text = "委托类型 市价委托"
            }
            
             self.tradeTypeL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 4))
            
            if (historyModel.orderStatus == "Filled") {
                
                self.orderStatusL.text = "完全成交"
            }else if (historyModel.orderStatus == "PartiallyFilled") {
                
                self.orderStatusL.text = "部分成交"
            }else if (historyModel.orderStatus == "Pending") {
                
                self.orderStatusL.text = "委托中"
            }else if (historyModel.orderStatus == "Cancelled") {
                
                self.orderStatusL.text = "被撤销"
            }else {
                
                self.orderStatusL.text = "异常失败"
            }
            
            let pnlRateFloat = Float(historyModel.pnlRate ?? "0") ?? 0
            
            self.profitL.text = "收益 \(historyModel.profitAmount ?? "")"
            self.profitRateL.text = "收益率 \(String(format: "%.2f%%", pnlRateFloat*100))"
            self.avgFilledPriceL.text = "成交价 \(historyModel.avgFilledPrice ?? "")"
            
            /// 修改字体颜色
            self.entrustVolumeL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 4))
            self.cumFilledVolumeL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 3))
            self.avgFilledPriceL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 3))
            self.profitL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 2))
            self.profitRateL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 3))
            
            /// 后新增问题来源
            var dessourceStr = ""
            
            if (historyModel.triggerType == "LimitOrder") {
                dessourceStr = ""
                commissionedSourceL.isHidden = true
            }else if (historyModel.triggerType == "TriggerOpen") {
                dessourceStr = "委托来源 计划委托"
                commissionedSourceL.isHidden = false
            }else if (historyModel.triggerType == "TriggerTakeProfit") {
                dessourceStr = "委托来源 止盈触发"
                commissionedSourceL.isHidden = false
            }else if (historyModel.triggerType == "TriggerStopLoss") {
                dessourceStr = "委托来源 止损触发"
                commissionedSourceL.isHidden = false
            }else {
                dessourceStr = ""
                commissionedSourceL.isHidden = true
            }
            
            commissionedSourceL.text = dessourceStr
            
            if dessourceStr.count > 0 {
                self.commissionedSourceL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 5))
            }
            
            if shareModel?.symbolName?.count == 0 {
                
                self.commissionedSourceL.isHidden = true
                self.profitRateL.isHidden = false
                self.profitRateL.text = dessourceStr
                if dessourceStr.count > 0 {
                    self.profitRateL.setAttributeColor(COLOR_CellTitleColor, range: NSRange(location: 0, length: 5))
                }
            }
        }
    }
}
