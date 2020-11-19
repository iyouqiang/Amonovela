
//
//  FCRegisterConfirmView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCRegisterConfirmView: UIView {
    
    let disposebag = DisposeBag()
    var loginType: FCLoginType = .phone
    var account: String = ""
    var segmentControl: FCSegmentControl?
    var titleLab: UILabel?
    var codeComponent: FCTextFieldComponent?
    var tipsLab: UILabel?
    var remindLab_0: UILabel?
    var remindLab_1: UILabel?
    var remindLab_2: UILabel?
    var countdownBtn: FCCountDownButton?
    var registerBtn: FCThemeButton?
    var loginBtn: UIButton?
    
    typealias callback = () -> Void
    typealias registerBlock = (_ code: String) -> Void
    
    var codeCallback: callback?
    var loginCallback: callback?
    var registerCallback: registerBlock?
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    init(loginType: FCLoginType, account: String) {
        super.init(frame: .zero)
        self.loginType = loginType
        self.account = account
        loadSubviews()
        handleRxSignals()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func loadSubviews() {
        
        var title: String = ""
        var placeholder: String = ""
        var tips: String = ""
        var remindText_0 = ""
        var remindText_1 = ""
        var remindText_2 = ""
        
        if loginType == .phone {
            title = "请输入\(self.account)收到的短信验证码"
            placeholder = "手机验证码"
            tips = "如果你未收到手机验证码，请尝试一下操作："
            remindText_0 = "1）确保手机号码是正确的"
            remindText_1 = "2）短信可能会被误判为垃圾短信，请注意检查"
            remindText_2 = "3）还没收到短信?"
        } else {
            title = "请输入\(self.account)收到的邮件验证码"
            placeholder = "邮件验证码"
            tips = "如果你未收到邮件，请尝试一下操作："
            remindText_0 = "1）确保邮件地址是正确的"
            remindText_1 = "2）邮件可能会被误判为垃圾邮件，请注意检查"
            remindText_2 = "3）还没收到邮件?"
        }
        
        self.segmentControl = FCSegmentControl.init(frame: CGRect.zero)
        segmentControl?.itemSpace = 13
        segmentControl?.setTitles(titles: ["手机登录", "邮箱登录"], fontSize: 18, normalColor: COLOR_MinorTextColor, tintColor: COLOR_White, showUnderLine: false)
        self.segmentControl?.isUserInteractionEnabled = false
        self.segmentControl?.setSelected(self.loginType == .phone ? 0 : 1)
        
        self.titleLab = fc_labelInit(text: title, textColor: COLOR_White, textFont: 15, bgColor: COLOR_Clear)
        self.codeComponent = FCTextFieldComponent.init(placeholder: placeholder, leftImg: "")
        self.codeComponent?.regularExpression = "[0-9A-Za-z]{0,16}$"
        self.tipsLab = fc_labelInit(text: tips, textColor: COLOR_White, textFont: 15, bgColor: COLOR_Clear)
        
        self.remindLab_0 = fc_labelInit(text: remindText_0, textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.remindLab_1 = fc_labelInit(text: remindText_1, textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.remindLab_2 = fc_labelInit(text: remindText_2, textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.countdownBtn = FCCountDownButton.init(normalTitle: "获取验证码", countdownTitle: "后重试", resendTitle: "重新发送验证码", duration: 60)
        
        let remindView = UIView.init(frame: .zero)
        remindView.addSubview(self.remindLab_0!)
        remindView.addSubview(self.remindLab_1!)
        remindView.addSubview(self.remindLab_2!)
        remindView.addSubview(self.countdownBtn!)
        
        self.registerBtn = FCThemeButton.init(title: "完成注册",  frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        
        let remindLab = fc_labelInit(text: "已有账号？", textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.loginBtn = fc_buttonInit(imgName: nil, title: "立即登录", fontSize: 15, titleColor: COLOR_BtnTitleColor, bgColor: COLOR_Clear)
        let bottomView = UIView.init(frame: .zero)
        bottomView.addSubview(remindLab)
        bottomView.addSubview(self.loginBtn!)
        
        self.remindLab_0?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        })
        
        self.remindLab_1?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.remindLab_0!.snp.bottom).offset(5)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        })
        
        self.remindLab_2?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.remindLab_1!.snp.bottom).offset(5)
            make.left.equalToSuperview()
        })
        
        self.countdownBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.remindLab_1!.snp.bottom).offset(5)
            make.left.equalTo(self.remindLab_2!.snp.right)
            make.right.lessThanOrEqualToSuperview()
            make.height.equalTo(self.remindLab_2!.snp.height)
            make.bottom.equalToSuperview()
        })
        
        
        remindLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(self.loginBtn!)
        }
        
        self.loginBtn?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalTo(remindLab.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        
        self.addSubview(self.segmentControl!)
        self.addSubview(self.titleLab!)
        self.addSubview(self.codeComponent!)
        self.addSubview(self.tipsLab!)
        self.addSubview(remindView)
        self.addSubview(self.registerBtn!)
        self.addSubview(bottomView)
        
        
        self.segmentControl?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(50 + 64)
            make.left.equalToSuperview()
            make.height.equalTo(25)
        })
        
        self.titleLab?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(45)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        })
        
        self.codeComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.titleLab!.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        self.tipsLab?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.codeComponent!.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview()
        })
        
        remindView.snp.makeConstraints { (make) in
            make.top.equalTo(self.tipsLab!.snp.bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.registerBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(remindView.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        })
        
        bottomView.snp.makeConstraints { (make) in
            make.top.equalTo(self.registerBtn!.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
    }
    
    private func handleRxSignals() {
        self.countdownBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.countdownNow()
            self?.codeCallback?()
            }).disposed(by: disposebag)
        
        self.registerBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.registerBtnClick()
            }).disposed(by: disposebag)
        
        self.loginBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.loginCallback?()
            }).disposed(by: disposebag)
    }
    
    func registerBtnClick() {
        if isParamsLegal() == false { return }
        self.registerCallback?(self.codeComponent?.textFiled.text ?? "")
    }
    
    func registerAction(callback: @escaping registerBlock) {
        self.registerCallback = callback
    }
    
    func getcCodeAction(callback: @escaping callback) {
        self.codeCallback = callback
    }
    
    func loginAction(callback: @escaping callback) {
        self.loginCallback = callback
    }
    
    func countdownNow () {
        self.countdownBtn?.deinitTimer()
        self.countdownBtn?.setupTimer()
    }
    
    private func isParamsLegal () -> Bool{
        
        if self.codeComponent?.textFiled.text?.count ?? 0 < 6 {
            self.makeToast("验证码有误", position: .top)
            return false
        }
        return true
    }
    
    
}
