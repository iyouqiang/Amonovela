//
//  FCPerpetualEntrustListCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/4.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCPerpetualEntrustListCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var modifyBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
    
    @IBOutlet weak var sideLab: UILabel!
    
    @IBOutlet weak var symbolLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var entrustTitleLab: UILabel!
    
    @IBOutlet weak var entrustVolumeLab: UILabel!
    
    @IBOutlet weak var entrustPriceTitleLab: UILabel!
    
    @IBOutlet weak var entrustPriceLab: UILabel!
    
    @IBOutlet weak var fillVolumeTitleLab: UILabel!
    
    @IBOutlet weak var filleVolumeLab: UILabel!
    
    @IBOutlet weak var fillPriceTitleLab: UILabel!
    
    @IBOutlet weak var fillPriceLab: UILabel!
    
    var modifyAction: (() -> Void)?
    
    var cancelAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.backgroundColor = COLOR_CellBgColor
        self.backgroundColor = COLOR_CellBgColor
        
        self.modifyBtn.isHidden = true
        
        modifyBtn.layer.cornerRadius = 12
        modifyBtn.layer.borderColor = COLOR_HighlightColor.cgColor
        modifyBtn.layer.borderWidth = 0.5
        cancelBtn.layer.cornerRadius = 12
        cancelBtn.layer.borderColor = COLOR_HighlightColor.cgColor
        cancelBtn.layer.borderWidth = 0.5
        self.sideLab.layer.cornerRadius = 3
        self.sideLab.layer.masksToBounds = true
        self.modifyBtn.setTitle("修改", for: .normal)
        self.cancelBtn.setTitle("撤单", for: .normal)
        self.entrustTitleLab.text = "委托总量"
        self.entrustPriceTitleLab.text = "委托价格"
        self.fillVolumeTitleLab.text = "已成交量"
        self.fillPriceTitleLab.text = "成交均价"
        
        self.modifyBtn.rx.tap.subscribe { (event) in
            // self.modifyAction?()
            
            
             let positionView = FCPerpetualModifyView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 430))
            // positionView.positionModel = self.positionModel
             
            let alertView = PCCustomAlert(customView: positionView)
             positionView.closeAlertBlock = {
                 
                 alertView?.disappear()
             }
            

        }.disposed(by: self.disposeBag)
        
        self.cancelBtn.rx.tap.subscribe { (event) in
            self.cancelAction?()
        }.disposed(by: self.disposeBag)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func loadData(model: FCPerpetualEntrustModel) {
        
        if model.side == "Ask" {
            // 卖出
            self.sideLab.backgroundColor = COLOR_FailColor
                    
            if model.action == "Open" {
                // 开仓
                self.sideLab.text = "卖出开空"
            }else if (model.action == "Close") {
                // 平仓
                self.sideLab.text = "卖出平多"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.sideLab.text = "卖出减仓"
            }else {
                // Liquidation 爆仓强平 平仓
                self.sideLab.text = "卖出平多"
            }
        }else {
              
            self.sideLab.backgroundColor = COLOR_RiseColor
            if model.action == "Open" {
                // 开仓
                self.sideLab.text = "买入开多"
            }else if (model.action == "Close") {
                // 平仓
                self.sideLab.text = "买入平空"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.sideLab.text = "买入减仓"
            }else {
                // Liquidation 爆仓强平 // 平仓
                self.sideLab.text = "买入平空"
            }
        }
        
        self.symbolLab.text = model.symbolName ?? ""//(model.symbol ?? "" ) + "永续"
        let timeArray = (model.entrustTm ?? "").split(separator: " ").compactMap { "\($0)"}
        self.timeLab.text = timeArray.last
        //let symbolArray = (model.symbol ?? "").split(separator: "-")
        var symbolUnit = model.contractAsset
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            symbolUnit = "张"
        }
        self.entrustVolumeLab.text = "\(model.entrustVolume ?? "")\(symbolUnit ?? "")"
        self.entrustPriceLab.text = "₮\(model.entrustPrice ?? "")"
        self.filleVolumeLab.text = "\(model.cumFilledVolume ?? "")\(symbolUnit ?? "")"
        self.fillPriceLab.text = "\(model.avgFilledPrice ?? "")"
    }
    
    func loadTriggerData(model: FCTriggerModel) {
        
        if model.side == "Ask" {
            // 卖出
            self.sideLab.backgroundColor = COLOR_FailColor
                    
            if model.action == "Open" {
                // 开仓
                self.sideLab.text = "卖出开空"
            }else if (model.action == "Close") {
                // 平仓
                self.sideLab.text = "卖出平多"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.sideLab.text = "卖出减仓"
            }else {
                // Liquidation 爆仓强平 平仓
                self.sideLab.text = "卖出平多"
            }
        }else {
              
            self.sideLab.backgroundColor = COLOR_RiseColor
            if model.action == "Open" {
                // 开仓
                self.sideLab.text = "买入开多"
            }else if (model.action == "Close") {
                // 平仓
                self.sideLab.text = "买入平空"
            }else if (model.action == "ADL") {
                // 自动减仓
                self.sideLab.text = "买入减仓"
            }else {
                // Liquidation 爆仓强平 // 平仓
                self.sideLab.text = "买入平空"
            }
        }
        
        self.symbolLab.text = model.symbol ?? ""//(model.symbol ?? "" ) + "永续"
        let timeArray = (model.entrustTime ?? "").split(separator: "+").compactMap { "\($0)"}
        let timestr = "\(timeArray.first ?? "0")"
        var symbolUnit = model.contractAsset
        self.timeLab.text = timestr.replacingOccurrences(of: "T", with: " ")
        let symbolArray = (model.symbol ?? "").split(separator: "-")
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            symbolUnit = "张"
        }
        self.entrustVolumeLab.text = "\(model.entrustVolume ?? "")\(symbolUnit ?? "")"
        self.entrustPriceLab.text = "₮\(model.entrustPrice ?? "")"
        self.filleVolumeLab.text = "\(model.cumFilledVolume ?? "")\(symbolUnit ?? "")"
        self.fillPriceLab.text = "\(model.avgFilledPrice ?? "")"
    }
    
}
