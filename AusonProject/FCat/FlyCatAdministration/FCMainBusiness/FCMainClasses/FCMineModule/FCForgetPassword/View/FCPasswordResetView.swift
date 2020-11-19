
//
//  FCPasswordResetView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCPasswordResetView: UIView {
    
    let disposeBag = DisposeBag()
    var loginType: FCLoginType = .phone
    var segmentControl: FCSegmentControl?
    var pwdComponent: FCPasswordComponent?
    var validComponent: FCPasswordComponent?
    var codeComponent: FCPasswordComponent?
    var confirmBtn: FCThemeButton?
    var countdownBtn: FCCountDownButton?
    
    typealias FinishBlock = (_ pwd: String, _ validPwd: String, _ code: String ) -> Void
    var callback: FinishBlock?
    
    typealias Codeblock = () -> Void
    var codeCallback: Codeblock?
    
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    init(loginType: FCLoginType) {
        super.init(frame: .zero)
        self.loginType = loginType
        loadSubviews()
        handleRxSignals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func loadSubviews() {
        self.segmentControl = FCSegmentControl.init(frame: CGRect.zero)
        segmentControl?.itemSpace = 13
        segmentControl?.setTitles(titles: ["手机登录", "邮箱登录"], fontSize: 18, normalColor: COLOR_MinorTextColor, tintColor: COLOR_White, showUnderLine: false)
        self.segmentControl?.isUserInteractionEnabled = false
        self.segmentControl?.setSelected(self.loginType == .phone ? 0 : 1)
        self.pwdComponent = FCPasswordComponent.init(placeholder: "新密码", leftImg: "")
        self.validComponent = FCPasswordComponent.init(placeholder: "确认密码", leftImg: "")
        self.codeComponent = FCPasswordComponent.init(placeholder: self.loginType == .phone ? "手机验证码" : "邮箱验证码", leftImg: "")
        self.confirmBtn = FCThemeButton.init(title: "确认", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        
        self.countdownBtn = FCCountDownButton.init(normalTitle: "获取验证码", countdownTitle: "后重试", resendTitle: "重新获取", duration: 60)
        self.countdownBtn?.contentHorizontalAlignment = .right
        self.codeComponent?.textFiled.rightView = self.countdownBtn
        self.codeComponent?.textFiled.rightViewMode = .always
        
        
        self.addSubview(self.segmentControl!)
        self.addSubview(self.pwdComponent!)
        self.addSubview(self.validComponent!)
        self.addSubview(self.codeComponent!)
        self.addSubview(self.confirmBtn!)
        
        self.countdownBtn?.snp.makeConstraints({ (make) in
            make.height.equalTo(40)
        })
        
        self.segmentControl?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(50 + 64)
            make.left.equalToSuperview()
            make.height.equalTo(25)
        })
        
        self.pwdComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        self.validComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.pwdComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        self.codeComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.validComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        self.confirmBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.codeComponent!.snp.bottom).offset(25)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        })
        
    }
    
    private func handleRxSignals() {
        self.confirmBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.confirmBtnClick()
            }).disposed(by: disposeBag)
        
        self.countdownBtn?.rx.tap.subscribe({[weak self] (event) in
            self?.countdownBtn?.deinitTimer()
            self?.countdownBtn?.setupTimer()
            self?.codeCallback?()
            }).disposed(by: disposeBag)
    }
    
    func confirmBtnClick() {
        if self.isParamsLegal() == false { return }
        
        self.callback?(self.pwdComponent?.textFiled.text ?? "", self.validComponent?.textFiled.text ?? "", self.codeComponent?.textFiled.text ?? "")
    }
    
    
    func confirmAction(callback: @escaping FinishBlock) {
        self.callback = callback
    }
    
    func getCodeAction(codeCallback: @escaping Codeblock) {
        self.codeCallback = codeCallback
    }
    
    
    private func isParamsLegal () -> Bool{
        
        var toastStr: String = ""
        var isLegal = false
        if self.pwdComponent?.textFiled.text?.count ?? 0 == 0 {
            
            toastStr = "请输入密码"
        } else if self.pwdComponent?.textFiled.text?.count ?? 0 < 6 {
            
            toastStr = "密码有误"
        } else if self.validComponent?.textFiled.text?.count ?? 0 == 0 {
            
            toastStr = "请确认密码"
        } else if self.validComponent?.textFiled.text ?? "" != self.pwdComponent?.textFiled.text ?? ""  {
            
            toastStr = "两次输入密码不一致"
        } else if self.codeComponent?.textFiled.text?.count ?? 0 == 0 {
            
            toastStr = "请输入验证码"
        } else if self.codeComponent?.textFiled.text?.count ?? 0 < 6 {
            
            toastStr = "验证码有误"
        } else {
            isLegal = true
        }
        
        if !isLegal { self.makeToast(toastStr, position: .top)}
        return isLegal
    }
    
}
