
//
//  FCTradeDepthCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCTradeDepthCell: UITableViewCell {
    
    var isSell: Bool = true
    lazy var priceLab: UILabel = {
        let priceLab = fc_labelInit(text: "-.--", textColor: COLOR_White, textFont: 12, bgColor: COLOR_Clear)
        priceLab.textAlignment = .left
        return priceLab
    }()
    
    lazy var amountLab: UILabel = {
        let amountLab = fc_labelInit(text: "--", textColor: COLOR_White, textFont: 12, bgColor: COLOR_Clear)
        amountLab.textAlignment = .right
        return amountLab
    }()
    
    lazy var percentView: UIView = {
        let percentView = UIView.init(frame: .zero)
        return percentView
    }()
    
    lazy var animateView: UIView = {
        let animateView = UIView.init(frame: .zero)
        return animateView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
        
        // paly animation
        if (selected){
            self.isSelected = false
            playSelectAnimation()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.loadSubviews()
        self.selectionStyle = .none
        self.contentView.backgroundColor = COLOR_BGColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews () {
        self.contentView.addSubview(percentView)
        self.contentView.addSubview(animateView)
        self.contentView.addSubview(priceLab)
        self.contentView.addSubview(amountLab)
        
        animateView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        priceLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        amountLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
            make.left.greaterThanOrEqualTo(priceLab.snp_left)
        }
    }
    
    /// 永续合约深度
    func loadContractData(model: FCKLineDepthModel?, contractModel: FCContractsModel,isSell: Bool) {
        self.priceLab.text = model?.price ?? ""
        self.amountLab.text = model?.volume ?? ""
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {
            
            //let volumeValue = Float(model?.volume ?? "0")!
            //let size = Float(contractModel.size ?? "0")!
            self.amountLab.text = model?.volume ?? "0"
            //String(format: "%0.4f", volumeValue*size)
        }
        
        self.isSell = isSell
        if (isSell) {
            self.priceLab.textColor = COLOR_FailColor
            self.percentView.backgroundColor = COLOR_HexColorAlpha(0xD83A66, alpha: 0.2)
        } else {
            self.priceLab.textColor = COLOR_RiseColor
            self.percentView.backgroundColor = COLOR_HexColorAlpha(0x39CC43, alpha: 0.2)
        }
        
        self.percentView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(model?.barPercent ?? 0 > 1.0  ? 1.0 :  model?.barPercent ?? 0.0)
        }
    }
    
    /// 币币账户深度
    func loadData(model: FCKLineDepthModel?, isSell: Bool) {
        self.priceLab.text = model?.price ?? ""
        self.amountLab.text = model?.volume ?? ""
        self.isSell = isSell
        if (isSell) {
            self.priceLab.textColor = COLOR_FailColor
            self.percentView.backgroundColor = COLOR_HexColorAlpha(0xD83A66, alpha: 0.2)
        } else {
            self.priceLab.textColor = COLOR_RiseColor
            self.percentView.backgroundColor = COLOR_HexColorAlpha(0x39CC43, alpha: 0.2)
        }
        
        
        self.percentView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(model?.barPercent ?? 0 > 1.0  ? 1.0 :  model?.barPercent ?? 0.0)
        }
    }

    
    func playSelectAnimation () {
        // 根据涨跌选择不同颜色
        animateView.backgroundColor = self.isSell ? COLOR_HexColorAlpha(0xD83A66, alpha: 0.4) :  COLOR_HexColorAlpha(0x39CC43, alpha: 0.4)
        
        UIView.animate(withDuration: 1.0) {
            self.animateView.backgroundColor = COLOR_HexColorAlpha(0x39CC43, alpha: 0.0)
        }
    }
    
}
