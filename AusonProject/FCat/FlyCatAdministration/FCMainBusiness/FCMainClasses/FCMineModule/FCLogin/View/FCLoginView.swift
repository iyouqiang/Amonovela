
//
//  FCLoginView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum FCLoginType {
    case phone
    case email
}

class FCLoginView: UIView {
    
    let disposeBag = DisposeBag()
    var segmentControl: FCSegmentControl?
    var phoneComponent: FCPhoneComponent?
    var phonePwdComponent: FCPasswordComponent?
    var emailComponent: FCEmailComponent?
    var emailPwdComponnet: FCPasswordComponent?
    var phoneContentView: UIView?
    var emailContentView: UIView?

    var loginBtn: FCThemeButton?
    var forgetBtn: UIButton?
    var registerBtn: UIButton?
    var loginType: FCLoginType = .phone
    
    
    typealias FinishBlock = (_ isLegal: Bool, _ loginType: FCLoginType, _ countryCode: String?, _ phoneNum: String?, _ phonePwd: String?, _ email: String?, _ emailPwd: String ) -> Void
    var callback: FinishBlock?
    
    typealias pushblock = () -> Void
    
    var forgetCallback: pushblock?
    var registerCallback: pushblock?
    
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
        
        self.segmentControl = FCSegmentControl.init(frame: CGRect.zero)
        segmentControl?.itemSpace = 13
        segmentControl?.setTitles(titles: ["手机登录", "邮箱登录"], fontSize: 18, normalColor: COLOR_MinorTextColor, tintColor: COLOR_White, showUnderLine: false)
        self.addSubview(self.segmentControl!)
        
        self.segmentControl?.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kNAVIGATIONHEIGHT)
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.height.equalTo(25)
        }
        
        loadPhoneSubviews()
        loadEmailSubviews()
        
        self.loginBtn = FCThemeButton.init(title: "登录", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        self.addSubview(self.loginBtn!)
        
        reloadContentView(loginType: .phone)
        self.loginType = .phone
        
        self.forgetBtn = fc_buttonInit(imgName: nil, title: "忘记密码", fontSize: 15, titleColor: COLOR_BtnTitleColor, bgColor: COLOR_Clear)
        let tipsLab = fc_labelInit(text: "没有账号？", textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.registerBtn = fc_buttonInit(imgName: nil, title: "立即注册", fontSize: 15, titleColor: COLOR_BtnTitleColor, bgColor: COLOR_Clear)
        let bottomLab = fc_labelInit(text: "更专业 更稳定 更高效", textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        
        self.addSubview(self.forgetBtn!)
        self.addSubview(tipsLab)
        self.addSubview(self.registerBtn!)
        self.addSubview(bottomLab)
        
        self.forgetBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.loginBtn!.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(kMarginScreenLR)
        })
        
        tipsLab.snp.makeConstraints { (make) in
            make.top.equalTo(self.loginBtn!.snp.bottom).offset(20)
            make.right.equalTo(self.registerBtn!.snp.left)
            make.height.equalTo(self.registerBtn!)
        }
        
        self.registerBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.loginBtn!.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
        })
        
        bottomLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    
    private func loadPhoneSubviews () {
        
        self.phoneContentView = UIView.init(frame: .zero)
        self.phoneComponent = FCPhoneComponent.init(frame: .zero)
        self.phoneContentView?.addSubview(self.phoneComponent!)
        self.phoneComponent?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.phonePwdComponent = FCPasswordComponent.init(placeholder: "请输入登录密码", leftImg: "mine_phonePwd")
        self.phoneContentView?.addSubview(self.phonePwdComponent!)
        self.phonePwdComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.phoneComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        })
        
        self.addSubview(self.phoneContentView!)
        self.phoneContentView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            
        })
    }
    
    
    private func loadEmailSubviews () {
        self.emailContentView = UIView.init(frame: .zero)
        self.emailComponent = FCEmailComponent.init(placeholder: "请输入邮箱", leftImg: "mine_email")
        self.emailContentView?.addSubview(self.emailComponent!)
        self.emailComponent?.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.emailPwdComponnet = FCPasswordComponent.init(placeholder: "请输入登录密码", leftImg: "mine_emailPwd")
        self.emailContentView?.addSubview(self.emailPwdComponnet!)
        self.emailPwdComponnet?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.emailComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        })
        
        self.addSubview(self.emailContentView!)
        self.emailContentView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(40)
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
        })
    }
    
    
    private func reloadContentView (loginType: FCLoginType) {
        
        let refView: UIView?
        if loginType == .phone {
            refView = self.phoneContentView
            self.phoneContentView?.isHidden = false
            self.emailContentView?.isHidden = true
            
        } else {
            refView = self.emailContentView
            self.phoneContentView?.isHidden = true
            self.emailContentView?.isHidden = false
        }
        
        
        self.loginBtn?.snp.remakeConstraints({ (make) in
            make.top.equalTo(refView!.snp.bottom).offset(30)
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.height.equalTo(50)
        })
    }
    
    func handleRxSignals () {
        
        self.segmentControl?.didSelectedItem({ [unowned self] (index: Int) in
            self.loginType = index == 0 ? .phone : .email
            self.reloadContentView(loginType: self.loginType)
        })
        
        self.loginBtn?.rx.tap.subscribe { [unowned self] (onNext) in
            self.loginBtnClick()
        }.disposed(by: disposeBag)
        
        self.forgetBtn?.rx.tap.subscribe { [unowned self] (onNext) in
            self.forgetCallback?()
        }.disposed(by: disposeBag)
        
        self.registerBtn?.rx.tap.subscribe { [unowned self] (onNext) in
            self.registerCallback?()
        }.disposed(by: disposeBag)
    }
    
    
    func loginBtnClick () {
        if self.loginBtn?.isEnabled == false {return}
        // 校验参数是否合法
        if (!(isParamsLegal())) {return}
        if self.loginType == .phone {
            self.callback?(true,.phone,self.phoneComponent?.coutryCode, self.phoneComponent?.phoneTxd?.text, self.phonePwdComponent?.textFiled?.text, "", "")
        } else {
            self.callback?(true,.email,"", "", "", self.emailComponent?.textFiled.text ?? "", self.emailPwdComponnet?.textFiled.text ?? "")
        }
    }
    
    
    func loginAction(callback: @escaping FinishBlock) {
        self.callback = callback
    }
    
    func forgetAction(callback: @escaping pushblock) {
        self.forgetCallback = callback
    }
    
    func registerAction(callback: @escaping pushblock) {
        self.registerCallback = callback
    }
    
    private func isParamsLegal () -> Bool{
        
        if self.loginType == .phone && self.phoneComponent?.phoneTxd.text?.count ?? 0 < 6 {
            self.makeToast("手机号有误", duration: 0.5, position: .top)
            return false
        } else if self.loginType == .phone && self.phonePwdComponent?.textFiled?.text?.count ?? 0 < 6 {
            self.makeToast("密码有误", duration: 0.5, position: .top)
            return false
        } else if self.loginType == .email && !(FCRegularExpression.isEmailLagal(email: self.emailComponent?.textFiled?.text)) {
            self.makeToast("邮箱有误", duration: 0.5, position: .top)
            return false
        } else if self.loginType == .email && self.emailPwdComponnet?.textFiled?.text?.count ?? 0 < 6 {
            self.makeToast("密码有误", duration: 0.5, position: .top)
            return false
        } else {
            return true
        }
    }
}
