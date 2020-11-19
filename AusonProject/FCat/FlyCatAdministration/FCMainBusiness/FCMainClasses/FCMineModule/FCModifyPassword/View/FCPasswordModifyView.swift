
//
//  FCPasswordModifyView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCPasswordModifyView: UIView {
    let disposeBag = DisposeBag()
    var oldPwdComponent: FCPasswordComponent?
    var newPwdComponent: FCPasswordComponent?
    var validPwdcomponent: FCPasswordComponent?
    var confirmBtn: FCThemeButton?
    
    typealias modifyBlock = (_ oldPwd: String, _ newPwd: String) -> Void
    var callback: modifyBlock?
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
        handleRxSignals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func loadSubviews() {
        
        let titleLab = fc_labelInit(text: "修改密码", textColor: COLOR_White, textFont: 18, bgColor: COLOR_Clear)
        self.oldPwdComponent = FCPasswordComponent.init(placeholder: "请输入旧密码", leftImg: "")
        self.oldPwdComponent?.regularExpression = "[0-9A-Za-z]{0,16}$"
        self.newPwdComponent = FCPasswordComponent.init(placeholder: "请输入新密码", leftImg: "")
        self.validPwdcomponent = FCPasswordComponent.init(placeholder: "请确认新密码",  leftImg: "")
        let bottomLab =  fc_labelInit(text: "6-16位含数字和字母组合，并与原密码不同", textColor: COLOR_FooterTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.confirmBtn = FCThemeButton.init(title: "确定", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        
        self.addSubview(titleLab)
        self.addSubview(self.oldPwdComponent!)
        self.addSubview(self.newPwdComponent!)
        self.addSubview(self.validPwdcomponent!)
        self.addSubview(bottomLab)
        self.addSubview(self.confirmBtn!)
        
        
        titleLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50 + 64)
            make.left.equalToSuperview()
        }
        
        self.oldPwdComponent?.snp.makeConstraints { (make) in
            make.top.equalTo(titleLab.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.newPwdComponent?.snp.makeConstraints { (make) in
            make.top.equalTo(self.oldPwdComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        self.validPwdcomponent?.snp.makeConstraints { (make) in
            make.top.equalTo(self.newPwdComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bottomLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.validPwdcomponent!.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        self.confirmBtn?.snp.makeConstraints { (make) in
            make.top.equalTo(bottomLab.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
    }
    
    private func handleRxSignals() {
        self.confirmBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.confirmBtnClick()
        }).disposed(by: disposeBag)
    }
    
    func confirmAction(callback: @escaping modifyBlock) {
        self.callback = callback
    }
    
    func confirmBtnClick () {
        if isParamsLegal() == false { return }
        self.callback?(self.oldPwdComponent?.textFiled.text ?? "", self.newPwdComponent?.textFiled.text ?? "")
    }
    
    
    private func isParamsLegal () -> Bool{
        if self.oldPwdComponent?.textFiled.text?.count ?? 0 < 6 {
            self.makeToast("旧密码有误", position: .top)
            return false
        } else if self.oldPwdComponent?.textFiled.text == self.newPwdComponent?.textFiled.text {
            self.makeToast("不能与原密码相同", position: .top)
            return false
        }
        else if self.newPwdComponent?.textFiled.text?.count ?? 0 < 6 {
            
            self.makeToast("新密码有误", position: .top)
            return false
        } else if self.newPwdComponent?.textFiled.text != self.validPwdcomponent?.textFiled.text {
            self.makeToast("两次输入的密码不一致", position: .top)
            return false
        }
        
        return true
    }
}
