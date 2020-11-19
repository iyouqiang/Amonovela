//
//  FCKLineHeaderView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/10.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCKLineHeaderView: UIView {
    
    var priceLab: UILabel?
    var CNYLab: UILabel?
    var percentLab: UILabel?
    var highLab: UILabel?
    var lowLab: UILabel?
    var volumelab: UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadLastMarketData(model: FCMarketModel?) {
        if model == nil { return }
        
        self.priceLab?.text = model?.latestPrice
        self.CNYLab?.text = "≈\(model?.estimatedValue ?? "")\(model?.estimatedCurrency ?? "")"
        
        self.highLab?.text = model?.high
        self.lowLab?.text = model?.low
        self.volumelab?.text = model?.volume
        self.percentLab?.text = "\(model?.changePercent ?? "")%"
        
        let changePercent = Double(model?.changePercent ?? "") ?? 0.0
        if changePercent > 0.0 {
            self.priceLab?.textColor = COLOR_RiseColor
            self.percentLab?.textColor = COLOR_RiseColor
        } else if changePercent < 0.0 {
            self.priceLab?.textColor = COLOR_FailColor
            self.percentLab?.textColor = COLOR_FailColor
        } else {
            self.priceLab?.textColor = COLOR_RiseColor
            self.percentLab?.textColor = COLOR_RiseColor
        }
    }
    

    func loadSubviews () {
        self.priceLab = fc_labelInit(text: "-.--", textColor: COLOR_FailColor, textFont: UIFont.boldSystemFont(ofSize: 27), bgColor: COLOR_BGColor)
        self.CNYLab = fc_labelInit(text: "=-.--CNY", textColor: COLOR_CharTipsColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        self.percentLab = fc_labelInit(text: "-.--%", textColor: COLOR_FailColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        self.highLab = fc_labelInit(text: "-.--", textColor: COLOR_ChartAxisColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        self.lowLab = fc_labelInit(text: "-.--", textColor: COLOR_ChartAxisColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        self.volumelab = fc_labelInit(text: "-.--", textColor: COLOR_ChartAxisColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        
        let highLeftLab = fc_labelInit(text: "高", textColor: COLOR_CharTipsColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        let lowLeftLab = fc_labelInit(text: "低", textColor: COLOR_CharTipsColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        let volumeLeftLab = fc_labelInit(text: "24H", textColor: COLOR_CharTipsColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: COLOR_BGColor)
        
        self.addSubview(self.priceLab!)
        self.addSubview(self.CNYLab!)
        self.addSubview(self.percentLab!)
        self.addSubview(self.highLab!)
        self.addSubview(self.lowLab!)
        self.addSubview(self.volumelab!)
        self.addSubview(highLeftLab)
        self.addSubview(lowLeftLab)
        self.addSubview(volumeLeftLab)
        
        self.priceLab?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.top.equalToSuperview().offset(15)
        })
        
        self.CNYLab?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.top.equalTo(self.priceLab!.snp.bottom).offset(15)
        })
        
        self.percentLab?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.CNYLab!)
            make.left.equalTo(self.CNYLab!.snp.right).offset(15)
            make.bottom.equalToSuperview().offset(-15)
        })
        
        self.highLab?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
        })
        
        highLeftLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.highLab!)
            make.right.lessThanOrEqualTo(self.highLab!.snp.left).offset(-15)
        }
        
        self.lowLab?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.highLab!.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
        })
        
        lowLeftLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.lowLab!)
            make.centerX.equalTo(highLeftLab)
            make.right.lessThanOrEqualTo(self.lowLab!.snp.left).offset(-15)
        }
        
        self.volumelab?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.lowLab!.snp.bottom).offset(5)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
        })
        
        volumeLeftLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(self.volumelab!)
            make.centerX.equalTo(highLeftLab)
            make.right.lessThanOrEqualTo(self.volumelab!.snp.left).offset(-15)
        }
    }
    
}
