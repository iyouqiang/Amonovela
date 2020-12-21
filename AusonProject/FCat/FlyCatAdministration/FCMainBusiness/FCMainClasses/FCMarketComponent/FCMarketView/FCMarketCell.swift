//
//  FCMarketCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCMarketCell: UITableViewCell {

    @IBOutlet weak var marketBgView: UIView!
    
    @IBOutlet weak var exchangeL: UILabel!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var turnoverL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var CNYL: UILabel!
    
    @IBOutlet weak var changepercentL: UILabel!
    
    @IBOutlet weak var symbolIconImgView: UIImageView!
    typealias LongPressBlock = (Bool, NSIndexPath) -> Void
    
    var longPressBlock: LongPressBlock?
    
    var indexPath: NSIndexPath?
    
    lazy var longPress: UILongPressGestureRecognizer = {
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        return longPress
    }()
    
    func configureCell(_ model: FCMarketModel, isOptional: Bool) {
        
        if isOptional {
         
            self.addGestureRecognizer(self.longPress)
        }
        
        let arrayStrings: [String] = model.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
        
        if model.name.count > 0 {
            
            self.titleL.text = model.name
            self.exchangeL.text = ""
        }else {
            
            self.titleL.text = arrayStrings.first
            self.exchangeL.text = "/\(arrayStrings.last ?? "")"
        }
        
        self.symbolIconImgView.sd_setImage(with: URL(string: model.iconUrl), placeholderImage: UIImage(named: "trade_BTC"), options: .retryFailed, completed: nil)
        
        self.turnoverL.text = "24h量 \(model.volume)"
        self.priceL.text = "$ \(model.latestPrice)"
        
        self.CNYL.text = model.estimatedValue
        //self.changepercentL.text = "\(model.changePercent)%"
        let percentValue = Double(model.changePercent) ?? 0.0
        
        
        if model.priceTrend == "Up" {
            
            self.priceL.textColor = COLOR_RiseColor

        }else if model.priceTrend == "Down" {
            
            self.priceL.textColor = COLOR_FailColor
        }else {
            // Stable market
            self.priceL.textColor = .white
        }
         
        self.priceL.setAttributeColor(COLOR_HexColor(0x848D9B), range: NSMakeRange(0, 1))
        
        if percentValue == 0.0 {
            
            //self.changepercentL.backgroundColor = COLOR_BGRiseColor
            self.changepercentL.textColor = COLOR_RiseColor
            
        } else if percentValue < 0.0 {
            self.changepercentL.text = "\(model.changePercent)%"
            //self.changepercentL.backgroundColor = COLOR_BGFailColor
            self.changepercentL.textColor = COLOR_FailColor
        } else {
            self.changepercentL.text = "+\(model.changePercent)%"
            //self.changepercentL.backgroundColor = COLOR_BGRiseColor
            self.changepercentL.textColor = COLOR_RiseColor
        }
         
    }
    
    @objc func longPressAction(longPress: UILongPressGestureRecognizer) {
        
        if longPress.state == .began {
            
            PCAlertManager.showCustomAlertView("温馨提示", message: "是否将\(self.titleL.text!)从自选中移除", btnFirstTitle: "取消", btnFirstBlock: {
                
                if let longBlock = self.longPressBlock {
                    
                    longBlock(false, self.indexPath!)
                }
                
            }, btnSecondTitle: "确定") {
                
                if let longBlock = self.longPressBlock {
                    
                    longBlock(true, self.indexPath!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.marketBgView.backgroundColor = COLOR_HexColor(0x1D2439)
        self.marketBgView.layer.cornerRadius = 8
        self.exchangeL.font = UIFont(_DINProBoldTypeSize: 13)
        self.titleL.font = UIFont(_DINProBoldTypeSize: 16)
        self.turnoverL.font = UIFont(_DINProBoldTypeSize: 13)
        self.priceL.font = UIFont(_DINProBoldTypeSize: 15)
        self.CNYL.font = UIFont(_DINProBoldTypeSize: 13)
        self.changepercentL.font = UIFont(_DINProBoldTypeSize: 14)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

