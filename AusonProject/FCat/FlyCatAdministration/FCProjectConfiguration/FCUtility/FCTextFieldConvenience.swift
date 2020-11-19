

//
//  FCTextFieldConvenience.swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import Foundation

func fc_textfiledInit(placeholder: String!, holderColor: UIColor!, textColor: UIColor!, fontSize: CGFloat!, borderStyle: UITextField.BorderStyle!) -> UITextField {
    
    let textFiled = UITextField.init(frame: CGRect.zero)
    
    textFiled.textColor = textColor
    textFiled.font = UIFont.init(_customTypeSize: fontSize)
    textFiled.borderStyle = borderStyle
    
    //占位符设置
    let placeholserAttributes = [NSAttributedString.Key.foregroundColor : holderColor, NSAttributedString.Key.font : UIFont.systemFont(ofSize: fontSize)] as [NSAttributedString.Key : Any]
    textFiled.attributedPlaceholder = NSAttributedString(string: placeholder,attributes: placeholserAttributes)
    
    return textFiled
}


