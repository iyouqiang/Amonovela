//
//  FCVerificationCodeAlertView.swift
//  Auson
//
//  Created by Yochi on 2020/11/23.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCVerificationCodeAlertView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var titleL: UILabel!
    var phoneIconView: UIImageView!
    var authenInfoL:UILabel!
    var countdownBtn: FCCountDownButton!
    var inputboxView: FCInputBoxTextFieldView!
    var verificationCode: String = ""
    var resendBlock: (() -> Void)?
    var inputBoxStrBlock: ((_ textStr: String) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.isUserInteractionEnabled = true
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setTitleInfo(Str: String, loginType: FCLoginType) {
        
        var titleStr = "短信验证码已发送至\n\(Str)\n请在下方输入验证码。"
        
        if loginType == .email {
            
            titleStr = "邮箱验证码已发送至\n\(Str)\n请在下方输入验证码。"
        }
        
        self.authenInfoL.text = titleStr
        self.authenInfoL.setAttributeColor(UIColor.white, range: NSMakeRange(10, Str.count))
    }
    
    func setupUI() {
        
        self.backgroundColor = COLOR_HexColor(0x2A2F3A)
        
        /// 验证码title
        titleL = fc_labelInit(text: "验证码", textColor: COLOR_MainThemeColor, textFont: UIFont(_customTypeSize: 30), bgColor: UIColor.clear)
        self.addSubview(titleL)
        
        /// 验证码重试按钮
        self.countdownBtn = FCCountDownButton.init(normalTitle: "获取验证码", countdownTitle: "后重试", resendTitle: "重新发送验证码", duration: 60)
        self.addSubview(self.countdownBtn)
        self.countdownBtn.setupTimer()
        self.countdownBtn.addTarget(self, action: #selector(resendVerificationCode), for: .touchUpInside)
        self.countdownBtn?.contentHorizontalAlignment = .right
        
        /// infoIcon
        phoneIconView = UIImageView(image: UIImage(named: "verificationIcon"))
        self.addSubview(phoneIconView)
        
        authenInfoL = fc_labelInit(text: "短信验证码已发送至\n(86)13818789469\n请在下方输入验证码。", textColor: COLOR_MinorTextColor, textFont: 14, bgColor: .clear)
        self.addSubview(authenInfoL)
        
        /// 输入框
        self.inputboxView = FCInputBoxTextFieldView(inputBoxFrame: CGRect(x: 20, y: 200, width: kSCREENWIDTH - 40, height: 48), boxNumber: 6, isPasswordformat: false)
        self.inputboxView.delegate = self
        
        self.addSubview(inputboxView)
        
        titleL.snp_makeConstraints { (make) in
            make.top.equalTo(20)
            make.left.equalTo(20)
        }
        
        countdownBtn.snp_makeConstraints { (make) in
            
            make.centerY.equalTo(titleL.snp_centerY)
            make.right.equalTo(-15)
        }
        
        phoneIconView.snp_makeConstraints { (make) in
            
            make.top.equalTo(titleL.snp_bottom).offset(30)
            make.left.equalTo(titleL.snp_left)
            make.height.equalTo(62.5)
            make.width.equalTo(52)
        }
        
        authenInfoL.snp_makeConstraints { (make) in
            
            make.left.equalTo(phoneIconView.snp_right).offset(20)
            make.centerY.equalTo(phoneIconView.snp_centerY)
        }
    }
    
    @objc func resendVerificationCode()
    {
        countdownNow()
        
        if let resendBlock = self.resendBlock {
            
            resendBlock()
        }
    }
    
    /// 重新计时
    func countdownNow () {
        
        self.countdownBtn?.deinitTimer()
        self.countdownBtn?.setupTimer()
    }
}

extension FCVerificationCodeAlertView: InputPasswordViewDelegate
{
    func inputBox(_ inputBoxString: String) {
        
        self.verificationCode = inputBoxString
        
        if let inputBoxStrBlock = self.inputBoxStrBlock {
            
            inputBoxStrBlock(inputBoxString)
        }
    }
}
