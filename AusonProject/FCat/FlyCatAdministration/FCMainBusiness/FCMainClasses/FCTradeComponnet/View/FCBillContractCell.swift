//
//  FCBillContractCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/1.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCBillContractCell: UITableViewCell {
    
    @IBOutlet weak var billDateL: UILabel!
    
    @IBOutlet weak var symbolL: UILabel!
    
    @IBOutlet weak var billDesTitleL: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var symbolNumL: UILabel!
    
    @IBOutlet weak var tradeAccountNumL: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lineView.backgroundColor = COLOR_TabBarBgColor
    }
    
    var model: FCBillContractModel? {
        didSet {
            guard let model = model else {
                return
            }
            
            self.billDateL.text = model.updateTm
            self.symbolL.text = model.symbol
            self.tradeAccountNumL.text = "交易金额"
            let volumeValue = (model.volume! as NSString).floatValue
            if volumeValue > 0 {
                self.symbolNumL.textColor = COLOR_RiseColor
            }else {
                self.symbolNumL.textColor = COLOR_FailColor
            }
            self.symbolNumL.text = "₮\(model.volume ?? "/")"
            
            /**
             // FundRecord 资金修改记录
             // Action操作类型有:
             // Deposit: 转入
             // Withdrawal: 转出
             // FundCost: 资金费用
             // OpenLong: 开多
             // OpenShort: 开空
             // CloseLong: 平多
             // CloseShort: 平空
             // DeleveragingLong: 减仓平多
             // DeleveragingShort: 减仓平空
             // LiquidationLong: 强平平多
             // LiquidationShort: 强平平空
             */
            
            let symbolArray = model.symbol?.split(separator: "-")
            
            let unitStr = "\(symbolArray?.first ?? "")"
            
            let contractVolume = model.contractVolume ?? ""
           
            if model.action == "OpenLong" {
                
                self.billDesTitleL.text = "开多\(contractVolume + unitStr)"
            }else if (model.action == "OpenShort") {
                
                self.billDesTitleL.text = "开空\(contractVolume + unitStr)"
            }else if (model.action == "CloseShort") {
                
                self.billDesTitleL.text = "平空\(contractVolume + unitStr)"
            }else if (model.action == "CloseLong") {
                
                self.billDesTitleL.text = "平多\(contractVolume + unitStr)"
            }else if (model.action == "Deposit") {
                
                self.billDesTitleL.text = "入金"
                
            }else if (model.action == "Withdrawal") {
                
                self.billDesTitleL.text = "出金"
            }else if (model.action == "FundCost") {
                
                self.billDesTitleL.text = "费用资金"
            }else if (model.action == "DeleveragingLong") {
                
                self.billDesTitleL.text = "减仓平多"
            }else if (model.action == "DeleveragingShort") {
                
                self.billDesTitleL.text = "减仓平空"
            }else if (model.action == "LiquidationLong") {
                
                self.billDesTitleL.text = "强平平多"
            }else if (model.action == "LiquidationShort") {
                
                self.billDesTitleL.text = "强平平空"
            }else {
                self.billDesTitleL.text = "资金费用"
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
