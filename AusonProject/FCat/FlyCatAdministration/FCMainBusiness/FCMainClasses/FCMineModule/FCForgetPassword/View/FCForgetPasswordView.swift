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
    var viewTitleL: UILabel?
    var dismissBtn: UIButton!
    var dismissViewBlock: (() -> Void)?
    
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
        
        self.dismissBtn = fc_buttonInit(imgName: "", title: "取消", fontSize: 15, titleColor: COLOR_MinorTextColor, bgColor: UIColor.clear)
        self.dismissBtn.contentHorizontalAlignment = .left
        self.dismissBtn.addTarget(self, action: #selector(dismissViewAction), for: .touchUpInside)
        self.addSubview(self.dismissBtn)
        
        self.viewTitleL = fc_labelInit(text: "重置密码", textColor: UIColor.white, textFont: 28, bgColor: .clear)
        self.addSubview(self.viewTitleL!)
        
        self.segmentControl = FCSegmentControl.init(frame: CGRect.zero)
        segmentControl?.itemSpace = 20
        segmentControl?.setTitles(titles: ["手机", "邮箱"], fontSize: 15, normalColor: COLOR_MinorTextColor, tintColor: UIColor.white, showUnderLine: true)
        self.phoneComponet = FCPhoneComponent.init(frame: .zero)
        self.emailComponent = FCEmailComponent.init(placeholder: "请输入邮箱", leftImg: "")
        self.tipsLab  = fc_labelInit(text: "重置登录密码后24小时内禁止提现", textColor: COLOR_TipsTextColor, textFont: 12, bgColor: UIColor.clear)
        self.continueBtn = FCThemeButton.init(title: "下一步", frame:CGRect.zero, cornerRadius: 4)
        
        self.addSubview(self.segmentControl!)
        self.addSubview(self.phoneComponet!)
        self.addSubview(self.emailComponent!)
        self.addSubview(self.tipsLab!)
        self.addSubview(self.continueBtn!)
        
        self.dismissBtn.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(kNAVIGATIONHEIGHT)
        }
        
        self.viewTitleL?.snp_makeConstraints({ (make) in
            make.left.equalTo(self.dismissBtn.snp_left)
            make.top.equalTo(self.dismissBtn.snp_bottom).offset(40)
        })
        
        self.segmentControl?.snp.makeConstraints { (make) in
            make.top.equalTo(self.viewTitleL!.snp_bottom).offset(40)
            make.left.equalTo(15)
            make.height.equalTo(25)
        }
        
        self.phoneComponet?.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(50)
            make.left.equalTo(15)
            make.right.equalToSuperview()
        }
        
        self.emailComponent?.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentControl!.snp.bottom).offset(50)
            make.left.equalTo(15)
            make.right.equalToSuperview()
        }
        
        self.reloadContentView(loginType: self.loginType)
        
        self.continueBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self.tipsLab!.snp.bottom).offset(40)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(44)
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
            make.left.equalTo(15)
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
    
    @objc func dismissViewAction() {
        if let dismissViewBlock = self.dismissViewBlock {
            dismissViewBlock()
        }
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
            //self.makeToast("手机号有误", duration: 0.5, position: .top)
            PCCustomAlert.showWarningAlertMessage("手机号有误")
            return false
        }  else if self.loginType == .email && !(FCRegularExpression.isEmailLagal(email: self.emailComponent?.textFiled?.text)) {
            //self.makeToast("邮箱有误", duration: 0.5, position: .top)
            PCCustomAlert.showWarningAlertMessage("邮箱有误")
            return false
        } else {
            return true
        }
    }
}
