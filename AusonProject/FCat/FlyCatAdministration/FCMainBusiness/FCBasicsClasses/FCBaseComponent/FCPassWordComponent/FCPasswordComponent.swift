//
//  FCPasswordComponent.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCPasswordComponent: FCTextFieldComponent {
let disposeBag = DisposeBag()
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
  
    override init(placeholder: String? = "", holderColor: UIColor? = COLOR_MinorTextColor, textColor: UIColor? = COLOR_White, fontSize: CGFloat? = 15, leftImg: String? = "", keyboardType: UIKeyboardType? = .alphabet) {
        super.init(placeholder: placeholder!, leftImg: leftImg!, keyboardType: keyboardType!)
        self.regularExpression = "[0-9A-Za-z]{0,16}$"
        let rightBtn: UIButton = fc_buttonInit(imgName: "mine_securePwd")
          rightBtn.contentHorizontalAlignment = .right
          
          rightBtn.rx.tap.subscribe { [unowned self] (onNext) in
            rightBtn.setImage(UIImage(named: self.textFiled.isSecureTextEntry ? "mine_plainPwd" : "mine_securePwd" ), for: .normal)
            self.textFiled.isSecureTextEntry = !self.textFiled.isSecureTextEntry
          }.disposed(by: disposeBag)
        self.textFiled.rightView = rightBtn
        self.textFiled.rightViewMode = .always
        self.textFiled.isSecureTextEntry = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
