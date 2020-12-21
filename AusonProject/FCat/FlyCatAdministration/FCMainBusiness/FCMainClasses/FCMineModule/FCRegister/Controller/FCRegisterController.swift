
//
//  FCRegisterController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCRegisterController: UIViewController {
    
    var registerView: FCRegisterView?
    var loginType: FCLoginType?
    var verificationId: String = ""
    var verificationCode: String = ""
    var alertView: PCCustomAlert!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.edgesForExtendedLayout = .all
        // Do any additional setup after loading the view.
        setupNavbar()
        setupSubviews()
    }
    
    func setupNavbar () {
        
        self.addleftNavigationItemImgNameStr("", title: " ", textColor: UIColor.clear, textFont: UIFont(_PingFangSCTypeSize: 12)) {
            
        }
        /**
        weak var weakSelf = self
        self.addrightNavigationItemImgNameStr(nil, title: "注册", textColor: COLOR_MinorTextColor, textFont: UIFont(_PingFangSCTypeSize: 17), clickCallBack: {
            weakSelf?.registerView?.registerBtnClick()
        })
         */
    }
    
    func setupSubviews (){
        
        self.title = ""
        self.view.backgroundColor = COLOR_BGColor
        
        self.registerView = FCRegisterView.init(frame: .zero)
        self.view.addSubview(self.registerView!)
        self.registerView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.bottom.equalToSuperview()
        })
        
        /// 点击注册按钮
        self.registerView?.registerAction(callback: { [weak self] (loginType: FCLoginType, countryCode: String?, phone: String?, email:String?, password: String, code: String?) in
            self?.loginType = loginType
            let registerType = loginType == .phone ? "PhonePassword" : "EmailPassword"
            let register_api = FCApi_account_register.init(registerType: registerType, phoneCode: countryCode, phoneNum: phone, email: email, password: password, invitaionCode: code)
            register_api.startWithCompletionBlock(success: { (response) in
                
                let result = response.responseObject as? [String : AnyObject]
                
                if response.responseCode == 0 {

                    if let validResult = result?["data"] as? [String : Any] {
                        
                        let verificationId = validResult["verificationId"]
                        self?.verificationId = verificationId as! String
                        
                        /// 获取验证码
                        self?.fetchCaptcha()
                        
                        /// 验证弹窗
                        self?.showverificationCodeView(countryCode: countryCode ?? "", loginType: loginType, email: email ?? "", phone: phone ?? "")
                       
                        /**
                        let confirmVC = FCRegisterConfirmController.init()
                             confirmVC.loginType = loginType
                        confirmVC.verificationId = validResult["verificationId"] as? String ?? ""
                        self?.navigationController?.pushViewController(confirmVC, animated: true)
                         */
                    }
                } else{
                    
                    let errMsg = result?["err"]?["msg"] as? String
                    //self?.view.makeToast(errMsg, position: .center)
                    PCCustomAlert.showWarningAlertMessage(errMsg)
                }
                
            }) { (response) in
                self?.view.makeToast(response.error?.localizedDescription, position: .center)
            }
        })
        
        self.registerView?.loginAction(callback: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    func showverificationCodeView(countryCode: String, loginType: FCLoginType, email: String, phone: String) {
        
        //// 弹窗
        let verificationView = FCVerificationCodeAlertView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: (2.0/3.0)*kSCREENHEIGHT))
        
        if loginType == .phone {
            
            verificationView.setTitleInfo(Str: "(\(countryCode ))\(phone )", loginType: loginType)
        } else {
            
            verificationView.setTitleInfo(Str: email , loginType: loginType)
        }
        
        verificationView.resendBlock = {
            
            /// 重新发送
            self.fetchCaptcha()
        }
        
        self.alertView = PCCustomAlert(customView: verificationView)
        
        verificationView.inputBoxStrBlock = {
            textStr in
            
            if textStr == self.verificationCode {
                return
            }
            
            if (self.verificationId.count > 0 && textStr.count == 6) {
                
                self.verificationCode = textStr
                self.submitRegisterInfo(code: textStr)
            }
        }
    }
    
    private func navigateToRegisterComfirm () {

    }
    
    //重新获取验证码
    private func fetchCaptcha () {
        
        let chanType = self.loginType == .phone ? "Phone" : "Email"
        let captchaApi = FCApi_captcha_resend.init(verificationId: self.verificationId, channelType: chanType)
        captchaApi.startWithCompletionBlock(success: { (response) in
            if response.responseCode == 0 {
                //
                let result = response.responseObject as? [String : AnyObject]
                
                if let validResult = result?["data"] as? [String : Any] {
                    self.verificationId = validResult["verificationId"] as? String  ?? self.verificationId
                }
            } else{
                
                let responseData = response.responseObject as?  [String : AnyObject]
                let errMsg = responseData?["err"]?["msg"] as? String
                PCCustomAlert.showWarningAlertMessage(errMsg)

            }
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    private func submitRegisterInfo (code: String) {
        let chanType = self.loginType == .phone ? "Phone" : "Email"
        let verifyApi = FCApi_captcha_verify.init(tBusinessType: "Register", chanType: chanType, captchaId: self.verificationId , captcha: code)
        verifyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if response.responseCode == 0 {
                self?.alertView?.disappear()
                // let result = response.responseObject as? [String : Any]
                self?.navigationController?.popToRootViewController(animated: true)
            } else{
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.alertView.makeToast(errMsg, position: .center)
            }
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
