

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
    var iconImgView: UIImageView?
    
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
        self.contentView.backgroundColor = COLOR_HexColor(0x131829)
        self.tradeSymbolLab = fc_labelInit(text: "--", textColor: UIColor.white, textFont: 16, bgColor: UIColor.clear)
        self.tradeSymbolLab?.font = UIFont(_DINProBoldTypeSize: 16)
        let seperateLab = fc_labelInit(text: "/", textColor: COLOR_MinorTextColor, textFont: 16, bgColor: UIColor.clear)
        seperateLab.font = UIFont(_DINProBoldTypeSize: 16)
        seperateLab.isHidden = true
        self.baseSymbolLab = fc_labelInit(text: "--", textColor: COLOR_MinorTextColor, textFont: 12, bgColor: UIColor.clear)
        self.baseSymbolLab?.font = UIFont(_DINProBoldTypeSize: 12)
        self.priceLab = fc_labelInit(text: "-.--", textColor: COLOR_RiseColor, textFont: 14, bgColor: UIColor.clear)
        self.priceLab?.font = UIFont(_DINProBoldTypeSize: 14)
        self.iconImgView = UIImageView(image: UIImage(named: "btc"))
        self.contentView.addSubview(self.iconImgView!)
        self.contentView.addSubview(self.tradeSymbolLab!)
        self.contentView.addSubview(seperateLab)
        self.contentView.addSubview(self.baseSymbolLab!)
        self.contentView.addSubview(priceLab!)
        
        self.tradeSymbolLab?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview().offset(-10)
            make.left.equalTo(self.iconImgView!.snp_right).offset(5)
        })
        
        self.iconImgView?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(12)
            make.width.height.equalTo(38)
        })
        
        seperateLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.tradeSymbolLab!)
            make.left.equalTo(self.tradeSymbolLab!.snp.right)
        }
        
        self.baseSymbolLab?.snp.makeConstraints({ (make) in
            
            make.centerY.equalToSuperview().offset(10)
            make.left.equalTo(self.iconImgView!.snp_right).offset(5)
        })
        
        self.priceLab?.snp.makeConstraints({ (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        })
    }
    
    func loadData(model: FCMarketModel?) {
        
        if model == nil { return }
        
        self.iconImgView?.sd_setImage(with: URL(string: (model?.iconUrl ?? "")), placeholderImage: UIImage(named: "btc"), options: .retryFailed, completed: nil)
        
        let arrayStrings: [String] = model?.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
        self.tradeSymbolLab?.text = arrayStrings.first
        self.baseSymbolLab?.text = "$\(model?.latestPrice ?? "0.00")"
        self.priceLab?.text = "\(model?.changePercent ?? "0.00")%"
        
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
            
            self.iconImgView?.sd_setImage(with: URL(string: (contractModel.iconUrl ?? "")), placeholderImage: UIImage(named: "btc"), options: .retryFailed, completed: nil)
            //self.tradeSymbolLab?.text = contractModel.asset
            self.tradeSymbolLab?.text = contractModel.name
            //self.baseSymbolLab?.text = contractModel.currency
            self.baseSymbolLab?.text = "$\(contractModel.tradePrice ?? "0.00")"
            self.priceLab?.text = "\(contractModel.changePercentage ?? "0.00")%"
            
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
