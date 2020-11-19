//
//  FCmainSymbolsView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

typealias ClickColumnItem = (_ index: Int, _ symbolModel: FCHomeSymbolsModel) -> Void

class FCMainSymbolsView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /// 第一列
    @IBOutlet weak var column1TitleL: UILabel!
    @IBOutlet weak var column1NumL: UILabel!
    @IBOutlet weak var column1PercentL: UILabel!
    @IBOutlet weak var column1measureL: UILabel!
    
    @IBOutlet weak var column2TitleL: UILabel!
    @IBOutlet weak var column2NumL: UILabel!
    @IBOutlet weak var column2PercentL: UILabel!
    @IBOutlet weak var column2measureL: UILabel!
    
    @IBOutlet weak var column3TitleL: UILabel!
    @IBOutlet weak var column3NumL: UILabel!
    @IBOutlet weak var column3PercentL: UILabel!
    @IBOutlet weak var column3measureL: UILabel!
    
    var clickColumnItem: ClickColumnItem?
    
    override func awakeFromNib() {
        
        column1TitleL.adjustsFontSizeToFitWidth = true
        column1NumL.adjustsFontSizeToFitWidth = true
        column1PercentL.adjustsFontSizeToFitWidth = true
        column1measureL.adjustsFontSizeToFitWidth = true
        
        column2TitleL.adjustsFontSizeToFitWidth = true
        column2NumL.adjustsFontSizeToFitWidth = true
        column2PercentL.adjustsFontSizeToFitWidth = true
        column2measureL.adjustsFontSizeToFitWidth = true
        
        column3TitleL.adjustsFontSizeToFitWidth = true
        column3NumL.adjustsFontSizeToFitWidth = true
        column3PercentL.adjustsFontSizeToFitWidth = true
        column3measureL.adjustsFontSizeToFitWidth = true
        
        let column1Btn = fc_buttonInit(imgName: "")
        column1Btn.tag = 100
        let column2Btn = fc_buttonInit(imgName: "")
        column2Btn.tag = 101
        let column3Btn = fc_buttonInit(imgName: "")
        column3Btn.tag = 102
        
        column1Btn.addTarget(self, action: #selector(clickColumnAction(sender:)), for: .touchUpInside)
        column2Btn.addTarget(self, action: #selector(clickColumnAction(sender:)), for: .touchUpInside)
        column3Btn.addTarget(self, action: #selector(clickColumnAction(sender:)), for: .touchUpInside)
        
        addSubview(column1Btn)
        addSubview(column2Btn)
        addSubview(column3Btn)
        
        column1Btn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.equalTo(kSCREENWIDTH/3.0)
        }
        column2Btn.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(kSCREENWIDTH/3.0)
            make.center.equalToSuperview()
        }
        column3Btn.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(kSCREENWIDTH/3.0)
        }
    }
    
    @objc func clickColumnAction(sender: UIButton) {
        
        if let clickColumnItem = self.clickColumnItem {
            if self.dataSource?.count ?? 0 > (sender.tag - 100) {
                
                let model = self.dataSource?[sender.tag - 100]
                clickColumnItem(sender.tag-100, model!)
            }
        }
    }
    
    var dataSource:[FCHomeSymbolsModel]? {
           didSet {
            guard let dataSource = dataSource else {
                return
            }
            
            /**
             changePercent = "2.34";
             close = "0.0";
             fiatCurrency = CNY;
             fiatPrice = "\Uffe584885.47";
             high = "12062.05";
             isOptional = 0;
             latestPrice = "11955.70";
             low = "11682.51";
             marketType = Spot;
             name = "BTC/USDT";
             open = "0.0";
             symbol = "BTC-USDT";
             tradingAmount = "1195.04";
             priceTrend = // up down stable Up为绿，Down为红，Stable为白
             */
            
            /// 三列
            for (index, symbolModel) in dataSource.enumerated() {
                                
                switch index {
                case 0:
                    do {
                        column1TitleL.text = symbolModel.name
                        column1NumL.text = symbolModel.latestPrice
                        column1PercentL.text = "\(symbolModel.changePercent ?? "--")%"
                        column1measureL.text = "≈\(symbolModel.fiatPrice ?? "")\(symbolModel.fiatCurrency ?? "")"
                        
                        if symbolModel.priceTrend == "Up" {
                            
                            column1NumL.textColor = COLOR_RiseColor
                            //column1PercentL.textColor = COLOR_RiseColor
                            
                        }else if symbolModel.priceTrend == "Down" {
                            
                            column1NumL.textColor = COLOR_FailColor
                            //column1PercentL.textColor = COLOR_FailColor
                        }else {
                            // Stable
                            column1NumL.textColor = COLOR_HexColor(0xdadada)
                            //column1PercentL.textColor = COLOR_HexColor(0xdadada)
                            
                        }
                        
                        
                        if (symbolModel.changePercent! as NSString).floatValue >= 0 {
                            
                            //column1TitleL.textColor = COLOR_RiseColor
                            //column1NumL.textColor = COLOR_RiseColor
                            column1PercentL.textColor = COLOR_RiseColor
                            column1PercentL.text = "+" + column1PercentL.text!
                            //column1measureL.textColor = COLOR_RiseColor
                        }else {
                            
                            //column1NumL.textColor = COLOR_FailColor
                            column1PercentL.textColor = COLOR_FailColor
                            column1PercentL.text = column1PercentL.text!
                            //column1measureL.textColor = COLOR_FailColor
                        }
                        
                    }
                    break
                case 1:
                    do {
                          
                        column2TitleL.text = symbolModel.name
                        column2NumL.text = symbolModel.latestPrice
                        column2PercentL.text = "\(symbolModel.changePercent ?? "--")%"
                        column2measureL.text = "≈\(symbolModel.fiatPrice ?? "")CNY"
                        
                        if symbolModel.priceTrend == "Up" {
                            
                            column2NumL.textColor = COLOR_RiseColor
                            //column2PercentL.textColor = COLOR_RiseColor
                            
                        }else if symbolModel.priceTrend == "Down" {
                            
                            column2NumL.textColor = COLOR_FailColor
                            //column2PercentL.textColor = COLOR_FailColor
                        }else {
                            // Stable
                            column2NumL.textColor = COLOR_HexColor(0xdadada)
                            //column2PercentL.textColor = COLOR_HexColor(0xdadada)
                        }
                        
                        if (symbolModel.changePercent! as NSString).floatValue >= 0 {
                            
                            //column2NumL.textColor = COLOR_RiseColor
                            column2PercentL.textColor = COLOR_RiseColor
                            column2PercentL.text = "+" + column2PercentL.text!
                            //column2measureL.textColor = COLOR_RiseColor
                        }else {
                            
                            //column2NumL.textColor = COLOR_FailColor
                            column2PercentL.textColor = COLOR_FailColor
                            column2PercentL.text = column2PercentL.text!
                            //column2measureL.textColor = COLOR_FailColor
                        }
                         
                    }
                    break
                case 2:
                    do {
                        
                        column3TitleL.text = symbolModel.name
                        column3NumL.text = symbolModel.latestPrice
                        column3PercentL.text = "\(symbolModel.changePercent ?? "--")%"
                        column3measureL.text = "≈\(symbolModel.fiatPrice ?? "")CNY"
                        
                        if symbolModel.priceTrend == "Up" {
                            
                            column3NumL.textColor = COLOR_RiseColor
                            //column3PercentL.textColor = COLOR_RiseColor
                            
                        }else if symbolModel.priceTrend == "Down" {
                            
                            column3NumL.textColor = COLOR_FailColor
                            //column3PercentL.textColor = COLOR_FailColor
                        }else {
                            // Stable
                            column3NumL.textColor = COLOR_HexColor(0xdadada)
                            //column3PercentL.textColor = COLOR_HexColor(0xdadada)
                            
                        }
                        
                        
                        if (symbolModel.changePercent! as NSString).floatValue >= 0 {
                            
                            //column3NumL.textColor = COLOR_RiseColor
                            column3PercentL.textColor = COLOR_RiseColor
                            column3PercentL.text = "+" + column3PercentL.text!
                            //column3measureL.textColor = COLOR_RiseColor
                        }else {
                            
                            //column3NumL.textColor = COLOR_FailColor
                            column3PercentL.textColor = COLOR_FailColor
                            column3PercentL.text = column3PercentL.text!
                            //column3measureL.textColor = COLOR_FailColor
                        }
                         
                    }
                    break
                default:
                    do {
                        
                    }
                }
            }
        }
    }
}
