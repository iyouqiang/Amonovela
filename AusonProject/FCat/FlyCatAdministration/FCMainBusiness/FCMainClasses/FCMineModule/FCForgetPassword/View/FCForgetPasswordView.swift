//
//  FCForgetPasswordView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCForgetPasswordView: UIView {
    let disposeBag = DisposeBag()
    var phoneComponet: FCPhoneComponent?
    var emailComponent: FCEmailComponent?
    var segmentControl: FCSegmentControl?
    var continueBtn: FCThemeButton?
    var tipsLab: UILabel?
    var loginType: FCLoginType = .phone
    
    typealias FinishBlock = (_ isLegal: Bool, _ loginType: FCLoginType, _ countryCode: String?, _ phoneNum: String?, _ email: String? ) -> Void
    var callback: FinishBlock?
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
        self.phoneComponet = FCPhoneComponent.init(frame: .zero)
        self.emailComponent = FCEmailComponent.init(placeholder: "请输入邮箱", leftImg: "mine_email")
        self.tipsLab  = fc_labelInit(text: "重置登录密码后24小时内禁止提现", textColor: COLOR_TipsTextColor, textFont: 12, bgColor: COLOR_Clear)
        self.continueBtn = FCThemeButton.init(title: "下一步", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        
        self.addSubview(self.segmentControl!)
        self.addSubview(self.phoneComponet!)
        self.addSubview(self.emailComponent!)
        self.addSubview(self.tipsLab!)
        self.addSubview(self.continueBtn!)
        
        self.segmentControl?.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(50 + 64)
            make.left.equalToSuperview()
            make.height.equalTo(25)
        }
        
        self.phoneComponet?.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        self.emailComponent?.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(40)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        self.reloadContentView(loginType: self.loginType)
        
        self.continueBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tipsLab!.snp.bottom).offset(25)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        })
        
    }
    
    
    private func reloadContentView (loginType: FCLoginType) {
        
        let refView: UIView?
        if loginType == .phone {
            refView = self.phoneComponet
            self.phoneComponet?.isHidden = false
            self.emailComponent?.isHidden = true
            
        } else {
            refView = self.emailComponent
            self.phoneComponet?.isHidden = true
            self.emailComponent?.isHidden = false
        }
        
        self.tipsLab?.snp.remakeConstraints({ (make) in
            make.top.equalTo(refView!.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(20)
        })
        
        
    }
    
    private func handleRxSignals() {
        self.segmentControl?.didSelectedItem({ [unowned self] (index: Int) in
            self.loginType = index == 0 ? .phone : .email
            self.reloadContentView(loginType: self.loginType)
        })
        
        self.continueBtn?.rx.tap.subscribe({[weak self] (event) in
            self?.continueBtnClick()
        }).disposed(by: disposeBag)
    }
    
    
    func continueBtnClick () {
        if self.isParamsLegal() == false { return }
         
         if self.loginType == .phone {
            self.callback?(true,.phone,self.phoneComponet?.coutryCode, self.phoneComponet?.phoneTxd.text, "")
         } else {
            self.callback?(true,.email,"", "", self.emailComponent?.textFiled.text ?? "")
         }
    }
    
    func continueAction(callback: @escaping FinishBlock) {
        self.callback = callback
    }
    
    private func isParamsLegal () -> Bool{
        
        if self.loginType == .phone && self.phoneComponet?.phoneTxd.text?.count ?? 0 < 6 {
            self.makeToast("手机号有误", duration: 0.5, position: .top)
            return false
        }  else if self.loginType == .email && !(FCRegularExpression.isEmailLagal(email: self.emailComponent?.textFiled?.text)) {
            self.makeToast("邮箱有误", duration: 0.5, position: .top)
            return false
        } else {
            return true
        }
    }
}
