//
//  FCContractInputView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractInputView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var textField: UITextField!
    var preTitleL: UILabel!
    var suffixL: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setUp()
        self.backgroundColor = COLOR_HexColorAlpha(0xD8D8D8, alpha: 0.2)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var preTitle:String? {
        
        didSet {
            guard let preTitle = preTitle else {
                return
            }
            
            textField.snp.remakeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(preTitleL.snp_right).offset(8)
                make.right.equalTo(-15)
            }
            
            self.preTitleL.text = preTitle
            
            let titleWidth = preTitleL.labelWidthMaxHeight(30)
            
            preTitleL.snp.updateConstraints { (make) in
                make.width.equalTo(titleWidth)
            }
        }
    }
    
    var suffixTitle:String? {
       
        didSet {
            guard let suffixTitle = suffixTitle else {
                return
            }
            self.suffixL.text = suffixTitle
            
            textField.snp.makeConstraints { (make) in
                make.top.bottom.equalTo(0)
                make.left.equalTo(preTitleL.snp_right)
                make.right.equalTo(-50)
            }
        }
    }
    
    func setUp() {
        
        preTitleL = fc_labelInit(text: "", textColor: COLOR_CellTitleColor, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        addSubview(preTitleL)
        
        textField = UITextField()
        textField.tintColor = COLOR_TabBarTintColor
        textField.keyboardType = .decimalPad
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.textColor = COLOR_RichBtnTitleColor
        textField.borderStyle = .none
        textField.textAlignment = .right
        addSubview(textField)
        
        suffixL = fc_labelInit(text: "", textColor: COLOR_CellTitleColor, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        suffixL.textAlignment = .right
        addSubview(suffixL)
        
        /// 布局
        preTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalTo(0)
            make.width.equalTo(50)
        }
        
        suffixL.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.bottom.equalTo(0)
            make.width.equalTo(36)
        }
        
        textField.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
    }

}
