

//
//  FCSymbolsDrawerCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/9.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCSymbolsDrawerCell: UITableViewCell {
    var tradeSymbolLab : UILabel?
    var baseSymbolLab : UILabel?
    var priceLab: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews () {
        self.selectionStyle = .none
        self.contentView.backgroundColor = COLOR_HexColor(0x202128)
        self.tradeSymbolLab = fc_labelInit(text: "--", textColor: COLOR_White, textFont: 16, bgColor: COLOR_Clear)
        let seperateLab = fc_labelInit(text: "/", textColor: COLOR_MinorTextColor, textFont: 16, bgColor: COLOR_Clear)
        seperateLab.isHidden = true
        self.baseSymbolLab = fc_labelInit(text: "--", textColor: COLOR_MinorTextColor, textFont: 12, bgColor: COLOR_Clear)
        self.priceLab = fc_labelInit(text: "-.--", textColor: COLOR_RiseColor, textFont: 14, bgColor: COLOR_Clear)
        self.contentView.addSubview(self.tradeSymbolLab!)
        self.contentView.addSubview(seperateLab)
        self.contentView.addSubview(self.baseSymbolLab!)
        self.contentView.addSubview(priceLab!)
        
        self.tradeSymbolLab?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
        })
        
        seperateLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.tradeSymbolLab!)
            make.left.equalTo(self.tradeSymbolLab!.snp.right)
        }
        
        self.baseSymbolLab?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(self.tradeSymbolLab!.snp.bottom)
            //            make.baseline.equalTo(self.tradeSymbolLab!.snp.bottom)
            make.left.equalTo(seperateLab.snp.right)
            make.right.lessThanOrEqualTo(self.priceLab!.snp.left)
        })
        
        self.priceLab?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        })
    }
    
    func loadData(model: FCMarketModel?) {
        if model == nil { return }
        let arrayStrings: [String] = model?.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
        self.tradeSymbolLab?.text = arrayStrings.first
        self.baseSymbolLab?.text = arrayStrings.last ?? ""
        self.priceLab?.text = model?.latestPrice
        
        
        let percentValue = Double(model?.changePercent ?? "0") ?? 0.0
        if percentValue == 0.0 {
            self.priceLab?.textColor = COLOR_RiseColor
        } else if percentValue < 0.0 {
            self.priceLab?.textColor = COLOR_FailColor
        } else {
            self.priceLab?.textColor = COLOR_RiseColor
        }
    }
    
    var contractModel: FCContractsModel? {
    
        didSet {
            guard let contractModel = contractModel else {
                return
            }
            
            //self.tradeSymbolLab?.text = contractModel.asset
            self.tradeSymbolLab?.text = contractModel.name
            //self.baseSymbolLab?.text = contractModel.currency
            self.baseSymbolLab?.text = ""
            self.priceLab?.text = contractModel.tradePrice
             
             let percentValue = Double(contractModel.changePercentage ?? "0") ?? 0.0
             if percentValue == 0.0 {
                 self.priceLab?.textColor = COLOR_RiseColor
             } else if percentValue < 0.0 {
                 self.priceLab?.textColor = COLOR_FailColor
             } else {
                 self.priceLab?.textColor = COLOR_RiseColor
             }
        }
        
    }
    
}
