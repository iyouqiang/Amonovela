//
//  FCRegisterView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
//
//enum FCRegisterType {
//    case phone
//    case email
//}



class FCRegisterView: UIView {
    
    let disposebag = DisposeBag()
    var loginType: FCLoginType = .phone
    var segmentControl: FCSegmentControl?
    var phoneComponent: FCPhoneComponent?
    var phonePwdComponent: FCPasswordComponent?
    var emailComponent: FCEmailComponent?
    var emailPwdComponnet: FCPasswordComponent?
    var phoneCodeComponent: FCTextFieldComponent?
    var emailCodeComponent: FCTextFieldComponent?
    var phoneContentView: UIView?
    var emailContentView: UIView?
    
    var registerBtn: FCThemeButton?
    var loginBtn: UIButton?
    
    
    typealias registerBlock = (_ loginType: FCLoginType, _ countryCode: String?, _ phone: String?, _ email: String?,  _ password: String, _ inviteCode: String?) -> Void
    var callback: registerBlock?
    
    typealias loginlock = () -> Void
    var loginCallback: loginlock?
    
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
        
        loadPhoneContentView()
        loadEmailContentView()
        
        self.registerBtn = FCThemeButton.init(title: "注册", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        
        let tipsLab = fc_labelInit(text: "已有账号？", textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.loginBtn = fc_buttonInit(imgName: nil, title: "立即登录", fontSize: 15, titleColor: COLOR_BtnTitleColor, bgColor: COLOR_Clear)
        let bottomView = UIView.init(frame: .zero)
        bottomView.addSubview(tipsLab)
        bottomView.addSubview(self.loginBtn!)
        
        let bottomLab = fc_labelInit(text: "更专业 更稳定 更高效", textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.addSubview(bottomLab)
        
        self.addSubview(self.registerBtn!)
        self.addSubview(bottomView)
        
        self.segmentControl?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview().offset(50 + 64)
            make.left.equalToSuperview()
            make.height.equalTo(25)
        })
        
        
        reloadSubview(loginType: self.loginType)
        
        tipsLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(self.loginBtn!)
        }
        
        self.loginBtn?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalTo(tipsLab.snp.right)
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
        
        bottomView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(self.registerBtn!.snp.bottom).offset(20)
            make.left.greaterThanOrEqualToSuperview()
            make.right.lessThanOrEqualToSuperview()
        }
        
        bottomLab.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-30)
            make.centerX.equalToSuperview()
        }
    }
    
    private func loadPhoneContentView () {
        self.phoneContentView = UIView.init(frame: .zero)
        self.phoneComponent = FCPhoneComponent.init(frame: .zero)
        self.phonePwdComponent = FCPasswordComponent.init(placeholder: "请输入登录密码", leftImg: "mine_phonePwd")
        self.phoneCodeComponent = FCTextFieldComponent.init(placeholder: "邀请码", leftImg: "invite_man")
        self.phoneCodeComponent?.regularExpression = "[0-9A-Za-z]{0,16}$"
        
        self.phoneContentView?.addSubview(self.phoneComponent!)
        self.phoneContentView?.addSubview(self.phonePwdComponent!)
        self.phoneContentView?.addSubview(self.phoneCodeComponent!)
        self.addSubview(self.phoneContentView!)
        
        self.phoneComponent?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
        
        self.phonePwdComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.phoneComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        self.phoneCodeComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.phonePwdComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        })
        
        self.phoneContentView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
    }
    
    private func loadEmailContentView () {
        self.emailContentView = UIView.init(frame: .zero)
        self.emailComponent = FCEmailComponent.init(placeholder: "请输入邮箱", leftImg: "mine_email")
        self.emailPwdComponnet = FCPasswordComponent.init(placeholder: "请输入登录密码", leftImg: "mine_emailPwd")
        self.emailCodeComponent = FCTextFieldComponent.init(placeholder: "邀请码", leftImg: "invite_man")
        self.emailCodeComponent?.regularExpression = "[0-9A-Za-z]{0,16}$"
        
        self.emailContentView?.addSubview(self.emailComponent!)
        self.emailContentView?.addSubview(self.emailPwdComponnet!)
        self.emailContentView?.addSubview(self.emailCodeComponent!)
        self.addSubview(self.emailContentView!)
        
        self.emailComponent?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
        
        self.emailPwdComponnet?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.emailComponent!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        self.emailCodeComponent?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.emailPwdComponnet!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
            make.bottom.equalToSuperview()
        })
        
        self.emailContentView?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        })
    }
    
    
    private func reloadSubview(loginType: FCLoginType) {
        
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
        
        self.registerBtn?.snp.remakeConstraints({ (make) in
            make.top.equalTo(refView!.snp.bottom).offset(30)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        })
    }
    
    
    private func  handleRxSignals () {
        self.loginBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.loginCallback?()
        }).disposed(by: disposebag)
        
        self.registerBtn?.rx.tap.subscribe({[weak self] (event) in
            self?.registerBtnClick()
        }).disposed(by: disposebag)
        
        self.segmentControl?.didSelectedItem({ [weak self] (index: Int) in
            self?.loginType = index == 0 ? .phone : .email
            self?.reloadSubview(loginType: self?.loginType ?? .phone)
        })
        
    }
    
    
    func registerBtnClick () {
        if self.isParamsLegal() == false { return }
        
        if self.loginType == .phone {
            self.callback?(self.loginType, self.phoneComponent?.coutryCode ?? "", self.phoneComponent?.phoneTxd.text ?? "", "", self.phonePwdComponent?.textFiled.text ?? "", self.phoneCodeComponent?.textFiled.text ?? "")
        } else {
            
            self.callback?(self.loginType, "", "", self.emailComponent?.textFiled.text ?? "", self.emailPwdComponnet?.textFiled.text ?? "", self.emailCodeComponent?.textFiled.text ?? "")
        }
        
        
    }
    
    func registerAction (callback: @escaping registerBlock) {
        self.callback = callback
    }
    
    func loginAction (callback: @escaping loginlock) {
        self.loginCallback = callback
    }
    
    private func isParamsLegal () -> Bool{
        
        var toastStr: String = ""
        var isLegal = false
        if self.loginType == .phone && self.phoneComponent?.phoneTxd.text?.count ?? 0 < 6 {
            toastStr = "手机号有误"
        } else if self.loginType == .phone && self.phonePwdComponent?.textFiled.text?.count ?? 0 < 6 {
            toastStr = "密码有误"
        } else if self.loginType == .email && !(FCRegularExpression.isEmailLagal(email: self.emailComponent?.textFiled?.text)) {
            toastStr = "邮箱有误"
        } else if self.loginType == .email && self.emailPwdComponnet?.textFiled?.text?.count ?? 0 < 6 {
            toastStr = "密码有误"
        } else if self.phoneCodeComponent?.textFiled.text?.count ?? 0 > 0 && self.phoneCodeComponent?.textFiled.text?.count ?? 0 < 0 {
            toastStr = "邀请码有误"
        }  else if self.emailCodeComponent?.textFiled.text?.count ?? 0 > 0 && self.emailCodeComponent?.textFiled.text?.count ?? 0 < 0{
            toastStr = "邀请码有误"
        }
        else {
            isLegal = true
        }
        
        if !isLegal { self.makeToast(toastStr, position: .top)}
        return isLegal
    }
    
    
}
