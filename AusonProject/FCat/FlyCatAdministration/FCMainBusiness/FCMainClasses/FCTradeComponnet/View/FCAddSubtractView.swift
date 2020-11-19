//
//  FCAddSubtractView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCAddSubtractView: UIView {
    
    lazy var textField: UITextField = {
        
        let textField = fc_textfiledInit(placeholder: "", holderColor: COLOR_CharTipsColor, textColor: COLOR_InputText, fontSize: 16, borderStyle: .roundedRect)
        textField.rightViewMode = .always
        textField.textAlignment = .center
        textField.tintColor = COLOR_subTitleColor
    
        return textField
    }()
    
    lazy var leftDownBtn: UIButton = {
        let leftDownBtn = fc_buttonInit(imgName: "trade_priceDown")
        leftDownBtn.tag = 100
        leftDownBtn.addTarget(self, action: #selector(setAmountValue(sender:)), for: .touchUpInside)
        return leftDownBtn
    }()
    
    lazy var rightUpBtn: UIButton = {
        let rightUpBtn = fc_buttonInit(imgName: "trade_priceUp")
        rightUpBtn.addTarget(self, action: #selector(setAmountValue(sender:)), for: .touchUpInside)
        rightUpBtn.tag = 101
        return rightUpBtn
    }()
    
    var leftLineView: UIView!
    var rightLineView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        leftLineView = UIView.init(frame: .zero)
        leftLineView.backgroundColor = COLOR_InputText
        
        rightLineView = UIView.init(frame: .zero)
        rightLineView.backgroundColor = COLOR_InputText
        
        addSubview(self.leftDownBtn)
        addSubview(self.rightUpBtn)
        addSubview(self.textField)
        addSubview(leftLineView!)
        addSubview(rightLineView!)
        
        textField.snp.makeConstraints { (make) in
            make.left.equalTo(leftLineView.snp_right)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(rightLineView.snp_left)
        }

        leftDownBtn.snp.makeConstraints { (make) in
            
            make.width.height.equalTo(self.snp_height)
            make.top.left.bottom.equalToSuperview()
        }

        rightUpBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(self.snp_height)
            make.top.right.bottom.equalToSuperview()
        }

        leftLineView.snp.makeConstraints { (make) in
            make.left.equalTo(leftDownBtn.snp_right)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(0.5)
        }
        
        rightLineView.snp.makeConstraints { (make) in
            make.right.equalTo(rightUpBtn.snp_left)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(0.5)
        }
    }
    
    @objc func setAmountValue(sender: UIButton) {
        
        if sender.tag == 100 {
            let textStr = self.textField.text ?? ""
            var priceValue = NSDecimalNumber(string: textStr.count == 0 ? "0" : textStr)
            if(priceValue.doubleValue >= 0.01) {
                priceValue = priceValue.subtracting(NSDecimalNumber(0.01))
                self.textField.text = priceValue.stringValue
            }
        }else {
            
            let textStr = self.textField.text ?? ""
            var priceValue = NSDecimalNumber(string: textStr.count == 0 ? "0" : textStr)
            if(priceValue.doubleValue >= 0) {
                priceValue = priceValue.adding(NSDecimalNumber(0.01))
                self.textField.text = priceValue.stringValue
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
