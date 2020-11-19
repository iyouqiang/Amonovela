
//
//  FCTextFieldComponent.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCTextFieldComponent: UIView, UITextFieldDelegate {
    
    var textFiled: UITextField!
    var phoneTxd: UITextField!
    var bottomLine: UIView?
    var regularExpression: String? = nil
    var textFieldDidBeginEditingBlock: (() -> Void)?
    var text: String? = ""
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(placeholder: String? = "", holderColor: UIColor? = COLOR_MinorTextColor, textColor: UIColor? = COLOR_White, fontSize: CGFloat? = 15, leftImg: String?, keyboardType: UIKeyboardType? = .default) {
        super.init(frame: CGRect.zero)
        
        self.textFiled = fc_textfiledInit(placeholder: placeholder, holderColor: holderColor, textColor: textColor, fontSize: 15, borderStyle: UITextField.BorderStyle.none)
        self.textFiled.setModifyClearButton()
        self.textFiled.clearButtonMode = .whileEditing
        let bottomLine = UIView.init(frame: .zero)
        self.bottomLine = bottomLine
        bottomLine.backgroundColor = COLOR_SeperateColor
        self.addSubview(self.textFiled)
        self.addSubview(bottomLine)
        
        if let validLeftImg = leftImg {
            let leftView = UIImageView.init(image: UIImage(named: validLeftImg))
            self.textFiled.leftView = leftView
            self.textFiled.leftViewMode = .always
        }
        
        setupConstraints()
        self.textFiled.keyboardType = keyboardType!
        self.textFiled.delegate = self
        self.textFiled.clearButtonMode = .whileEditing
        
    }
    
    private func setupConstraints () {
        self.textFiled.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            //make.height.equalToSuperview()
             make.height.equalTo(40)
        }
        
        self.bottomLine?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.textFiled.snp.bottom).offset(-0.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        })
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let toBeStr = textField.text
        let rag = toBeStr?.toRange(range)
        let tempStr = textField.text?.replacingCharacters(in:rag!, with: string)
        
        return self.regularExpression != nil ?  (tempStr?.isMatch(self.regularExpression))! : true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if let textFieldDidBeginEditingBlock = textFieldDidBeginEditingBlock {
            
            textFieldDidBeginEditingBlock()
        }
            
    }
}

// MARK: -添加自定义清除按钮

extension UITextField {
    ///给UITextField添加一个清除按钮
    func setModifyClearButton() {
        let clearButton = UIButton(type: .custom)
        clearButton.setImage(UIImage(named: "textfiled_clear"), for: .normal)
        clearButton.frame = CGRect(x: -40, y: 0, width: 35, height: 35)
        clearButton.contentMode = .scaleAspectFit
        clearButton.addTarget(self, action: #selector(UITextField.clear(sender:)), for: .touchUpInside)
        self.rightView = clearButton
        self.rightViewMode = .whileEditing
    }

    /// 点击清除按钮，清空内容
    @objc func clear(sender: AnyObject) {
        self.text = ""
    }

}
