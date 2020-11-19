//
//  FCProfitLossInputView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCProfitLossInputView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var sliderItemValue: ((_ value: Float) -> Void)?
    
    lazy var priceTxd: UITextField = {
        
        let priceTxd = fc_textfiledInit(placeholder: "价格", holderColor: COLOR_CharTipsColor, textColor: COLOR_InputText, fontSize: 16, borderStyle: .roundedRect)
        priceTxd.delegate = self
        priceTxd.setValue(5, forKey: "paddingLeft")
        priceTxd.rightViewMode = .always
        priceTxd.backgroundColor = COLOR_BGColor
        priceTxd.layer.borderWidth = 0.5
        priceTxd.layer.borderColor = COLOR_InputBorder.cgColor
        priceTxd.layer.cornerRadius = 5
        priceTxd.tintColor = COLOR_InputText
    
        return priceTxd
    }()
    
    lazy var priceDownBtn: UIButton = {
        
        let downBtn = fc_buttonInit(imgName: "trade_priceDown")
        downBtn.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        downBtn.tag = 100
        downBtn.addTarget(self, action: #selector(setAmountValue(sender:)), for: .touchUpInside)
        return downBtn
    }()
    
    lazy var priceUpBtn: UIButton = {
        let upBtn = fc_buttonInit(imgName: "trade_priceUp")
        upBtn.imageEdgeInsets = UIEdgeInsets(top: 3, left: 3, bottom: 3, right: 3)
        upBtn.addTarget(self, action: #selector(setAmountValue(sender:)), for: .touchUpInside)
        upBtn.tag = 101
        return upBtn
    }()
    
    lazy var slider: PCSlider = {
        // height 30
        let slider = PCSlider.init(frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 30) / 2.0 , height: 0), scaleLineNumber: 4)
        slider?.setSliderValue(0.0)
        slider?.isHidden = true
        return slider!
    }()
    
    lazy var percentLab: UILabel = {
        let percentLab = fc_labelInit(text: "0%", textColor: COLOR_MinorTextColor , textFont: 12, bgColor: COLOR_BGColor)
        percentLab.numberOfLines = 0
        percentLab.isHidden = true
        return percentLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // 价格
        let txdRightView = UIView.init(frame: CGRect(x: 0, y: 0, width: 88, height: 36))
        let border = UIView.init(frame: .zero)
        border.backgroundColor = COLOR_InputBorder
        let seperator = UIView.init(frame: .zero)
        seperator.backgroundColor = COLOR_InputBorder
        
        txdRightView.addSubview(border)
        txdRightView.addSubview(seperator)
        txdRightView.addSubview(priceDownBtn)
        txdRightView.addSubview(priceUpBtn)
        priceTxd.rightView = txdRightView
        
        addSubview(priceTxd)
        addSubview(slider)
        addSubview(percentLab)
        
        priceTxd.snp.makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        txdRightView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 88, height: 36))
            
        }
        
        border.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(0.5)
        }
        
        seperator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(20)
        }
        
        priceDownBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.right.equalTo(seperator.snp.left).offset(-10)
        }
        
        priceUpBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.left.equalTo(seperator.snp.right).offset(10)
        }
        
        /// height = 0
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(priceTxd.snp_bottom)
            make.left.right.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0)
        }
        
        /// height
        percentLab.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp_bottom).offset(8)
            make.right.equalToSuperview()
        }
        
        changeSliderValue()
    }
    
    func changeSliderValue() {
        
        slider.monitorSliderValue { (value) in
            
            self.percentLab.text = String(format: "%.0f%%", value * 100)
            
            if let sliderItemValue = self.sliderItemValue  {
                sliderItemValue(value)
            }
        }
    }
    
    @objc func setAmountValue(sender: UIButton) {
        
        if sender.tag == 100 {
            
            var priceValue = Int(self.priceTxd.text ?? "") ?? 0
            if(priceValue >= 1) {
                priceValue = priceValue - 1
                self.priceTxd.text = String(format:"%d", priceValue)
            }
        }else {
            
            var priceValue = Int(self.priceTxd.text ?? "") ?? 0
            if(priceValue >= 0) {
                priceValue = priceValue + 1
                self.priceTxd.text = String(format:"%d", priceValue)
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FCProfitLossInputView: UITextFieldDelegate
{
    
}
