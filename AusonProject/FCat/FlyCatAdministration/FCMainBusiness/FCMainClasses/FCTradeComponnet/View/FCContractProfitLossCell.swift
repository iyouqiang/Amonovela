//
//  FCContractProfitLossCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractProfitLossCell: UITableViewCell {

    @IBOutlet weak var contentBgView: UIView!
    @IBOutlet weak var symboleTitleL: UILabel!
    @IBOutlet weak var tradeTypeL: UILabel!
    
    @IBOutlet weak var entrustVolumeL: UILabel!
    @IBOutlet weak var entrustVolumeTitleL: UILabel!
    @IBOutlet weak var entrustPriceTitleL: UILabel!
    @IBOutlet weak var entrustPriceL: UILabel!
    @IBOutlet weak var triggerStateTitleL: UILabel!
    @IBOutlet weak var triggerStateL: UILabel!
    @IBOutlet weak var orderStatusL: UILabel!
    
    @IBOutlet weak var orderTypeTitleL: UILabel!
    @IBOutlet weak var orderTypeL: UILabel!
    @IBOutlet weak var stopProfitTitleL: UILabel!
    @IBOutlet weak var stopProfitL: UILabel!
    @IBOutlet weak var stopLossTitleL: UILabel!
    @IBOutlet weak var stopLossL: UILabel!
    @IBOutlet weak var changeBtn: UIButton!
    @IBOutlet weak var cancelBtn: UIButton!
    
    var modifyAction: (() -> Void)?
    
    var cancelAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentBgView.backgroundColor = COLOR_CellBgColor
        changeBtn.layer.cornerRadius = 5
        changeBtn.clipsToBounds = true
        changeBtn.backgroundColor = .clear
        changeBtn.layer.borderWidth = 0.8
        changeBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        
        cancelBtn.layer.cornerRadius = 15
        cancelBtn.clipsToBounds = true
        cancelBtn.backgroundColor = .clear
        cancelBtn.layer.borderWidth = 0.7
        cancelBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        
        tradeTypeL.layer.cornerRadius = 5
        tradeTypeL.clipsToBounds = true
        self.triggerStateL.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func changeEntrustAction(_ sender: Any) {
        
        self.modifyAction?()
    }
    
    @IBAction func cancelEntrustAction(_ sender: Any) {
        
        self.cancelAction?()
    }
    
    func loadTriggerData(model: FCTriggerModel) {
        
        symboleTitleL.text = model.symbolName
        
        var unitStr = model.contractAsset ?? ""
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            unitStr = "张"
        }

        entrustVolumeTitleL.text = "委托量(\(unitStr))"
        // 止损价格
        stopLossL.text = model.stopLossPrice?.count == 0 ? "未设置" : model.stopLossPrice ?? ""
        // 止盈价格
        stopProfitL.text = model.takeProfitPrice?.count == 0 ? "未设置" : model.takeProfitPrice ?? ""
        
        // 委托价
        entrustPriceL.text = model.entrustPrice ?? ""
        entrustVolumeL.text = model.entrustVolume ?? "0"
        
        if model.tradeType == "Limit" {
            orderTypeL.text = "限价委托"
        }else {
            orderTypeL.text = "市价委托"
            entrustPriceL.text = "市价"
        }
        
        if model.side == "Ask" {
            // 卖出
            self.tradeTypeL.backgroundColor = COLOR_FailColor
                             
            if model.action == "Open" {
                // 开仓
                self.tradeTypeL.text = "卖出开空"
            }else if (model.action == "Close") {
                // 平仓
                self.tradeTypeL.text = "卖出平多"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.tradeTypeL.text = "自动减仓"
            }else {
                // Liquidation 爆仓强平
                self.tradeTypeL.text = "爆仓强平"
            }
        }else {
                       
            self.tradeTypeL.backgroundColor = COLOR_RiseColor
            if model.action == "Open" {
                // 开仓
                self.tradeTypeL.text = "买入开多"
            }else if (model.action == "Close") {
                // 平仓
                self.tradeTypeL.text = "买入平空"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.tradeTypeL.text = "自动减仓"
            }else {
                // Liquidation 爆仓强平
                self.tradeTypeL.text = "爆仓强平"
            }
        }
        
        // Triggered表示已触发
        // TriggerStopLoss表示止损已触发
        // TriggerTakeProfit表示止盈已触发
        // Pending表示委托中
        // Cancelled表示已撤销
        // Failed表示触发失败
        if model.orderStatus != "New" {
            /// 不在委托中
            self.triggerStateTitleL.text = "触发时间"
            if model.orderStatus == "Triggered" {
                self.orderStatusL.text = "已触发"
            }else if (model.orderStatus == "TriggerStopLoss") {
                self.orderStatusL.text = "止损已触发"
            }else if (model.orderStatus == "TriggerTakeProfit") {
                self.orderStatusL.text = "止盈已触发"
            }else if (model.orderStatus == "Cancelled")  {
                self.orderStatusL.text = "已撤销"
                self.triggerStateTitleL.text = "撤销时间"
            }else {
                self.orderStatusL.text = ""
            }
            
            let timeArray = (model.triggerTime ?? "").split(separator: "+").compactMap { "\($0)"}
            let timestr = "\(timeArray.first ?? "0")"
            self.triggerStateL.text = timestr.replacingOccurrences(of: "T", with: " ")
            
            return
        }
        
        /**
         // FullTriggered表示完成触发
         // PartiallyTriggered表示部分触发
         // Waiting表示监控中或者等待触发
         // Failed表示触发失败
         */
        
        if model.triggerStatus == "FullTriggered" {
            
            triggerStateL.text = "完成触发"
        }else if (model.triggerStatus == "PartiallyTriggered") {
            
            triggerStateL.text = "部分触发"
        }else if (model.triggerStatus == "Waiting") {
            
            triggerStateL.text = "待触发"
            
        }else if (model.triggerStatus == "FullTriggered") {
            triggerStateL.text = "触发失败"
        }
    }
    
    func loadTriggerEntrustData(model: FCTriggerModel) {
        
        var unitStr = model.contractAsset ?? ""
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            unitStr = "张"
        }

        entrustVolumeTitleL.text = "委托量(\(unitStr))"
        
        self.stopLossL.isHidden = true
        self.stopLossTitleL.isHidden = true
        self.stopProfitTitleL.text = "触发价(USDT)"
        self.stopProfitL.text = model.triggerPrice
        
        symboleTitleL.text = model.symbolName
        
        // 止损价格
        stopLossL.text = model.stopLossPrice?.count == 0 ? "未设置" : model.stopLossPrice ?? ""
        // 止盈价格
        //stopProfitL.text = model.takeProfitPrice?.count == 0 ? "未设置" : model.takeProfitPrice ?? ""
        
        // 委托价
        entrustPriceL.text = model.entrustPrice ?? ""
        entrustVolumeL.text = model.entrustVolume ?? "0"
        
        if model.tradeType == "Limit" {
            orderTypeL.text = "限价委托"
        }else {
            orderTypeL.text = "市价委托"
            entrustPriceL.text = "市价"
        }
        
        if model.side == "Ask" {
            // 卖出
            self.tradeTypeL.backgroundColor = COLOR_FailColor
                             
            if model.action == "Open" {
                // 开仓
                self.tradeTypeL.text = "卖出开空"
            }else if (model.action == "Close") {
                // 平仓
                self.tradeTypeL.text = "卖出平多"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.tradeTypeL.text = "自动减仓"
            }else {
                // Liquidation 爆仓强平
                self.tradeTypeL.text = "爆仓强平"
            }
        }else {
                       
            self.tradeTypeL.backgroundColor = COLOR_RiseColor
            if model.action == "Open" {
                // 开仓
                self.tradeTypeL.text = "买入开多"
            }else if (model.action == "Close") {
                // 平仓
                self.tradeTypeL.text = "买入平空"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.tradeTypeL.text = "自动减仓"
            }else {
                // Liquidation 爆仓强平
                self.tradeTypeL.text = "爆仓强平"
            }
        }
        
        // Triggered表示已触发
        // TriggerStopLoss表示止损已触发
        // TriggerTakeProfit表示止盈已触发
        // Pending表示委托中
        // Cancelled表示已撤销
        // Failed表示触发失败
        if model.orderStatus != "New" {
            /// 不在委托中
            self.triggerStateTitleL.text = "触发时间"
            if model.orderStatus == "Triggered" {
                self.orderStatusL.text = "已触发"
            }else if (model.orderStatus == "TriggerStopLoss") {
                self.orderStatusL.text = "止损已触发"
            }else if (model.orderStatus == "TriggerTakeProfit") {
                self.orderStatusL.text = "止盈已触发"
            }else if (model.orderStatus == "Cancelled")  {
                self.orderStatusL.text = "已撤销"
                self.triggerStateTitleL.text = "撤销时间"
            }else {
                self.orderStatusL.text = ""
            }
            
            let timeArray = (model.triggerTime ?? "").split(separator: "+").compactMap { "\($0)"}
            let timestr = "\(timeArray.first ?? "0")"
            self.triggerStateL.text = timestr.replacingOccurrences(of: "T", with: " ")
            
            return
        }
        
        /**
         // FullTriggered表示完成触发
         // PartiallyTriggered表示部分触发
         // Waiting表示监控中或者等待触发
         // Failed表示触发失败
         */
        
        if model.triggerStatus == "FullTriggered" {
            
            triggerStateL.text = "完成触发"
        }else if (model.triggerStatus == "PartiallyTriggered") {
            
            triggerStateL.text = "部分触发"
        }else if (model.triggerStatus == "Waiting") {
            
            triggerStateL.text = "待触发"
            
        }else if (model.triggerStatus == "FullTriggered") {
            triggerStateL.text = "触发失败"
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
