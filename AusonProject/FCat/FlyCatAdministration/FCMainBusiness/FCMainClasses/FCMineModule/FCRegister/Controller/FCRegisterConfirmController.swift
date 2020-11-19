//
//  FCRegisterConfirmController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCRegisterConfirmController: UIViewController {
    var loginType: FCLoginType = .phone
    var countryCode: String = ""
    var phoneNum: String = ""
    var email: String = ""
    var password: String = ""
    var inviteCode: String = ""
    var verificationId: String? = ""
    var confirmView: FCRegisterConfirmView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .all
        
        // Do any additional setup after loading the view.
        setupNavbar()
        setupSubviews()
    }
    
    func setupNavbar () {
        weak var weakSelf = self
        self.addrightNavigationItemImgNameStr(nil, title: "注册", textColor: COLOR_MinorTextColor, textFont: UIFont(_customTypeSize: 17), clickCallBack: {
            weakSelf?.confirmView?.registerBtnClick()
        })
    }
    
    func setupSubviews (){
        self.title = ""
        self.view.backgroundColor = COLOR_BGColor
        
        let accountStr = loginType == .phone ? self.countryCode + self.phoneNum : self.email
        self.confirmView = FCRegisterConfirmView.init(loginType: self.loginType, account: accountStr)
        self.view.addSubview(self.confirmView!)
        self.confirmView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.bottom.equalToSuperview()
        })
        
        //默认开启倒计时
        self.confirmView?.countdownNow()
        
        self.confirmView?.getcCodeAction(callback: { [weak self] in
            self?.fetchCaptcha()
        })
        
        self.confirmView?.registerAction(callback: { [weak self]  (code: String) in
            self?.submitRegisterInfo(code: code)
        })
        
        self.confirmView?.loginAction(callback: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    //重新获取验证码
    private func fetchCaptcha () {
        let chanType = self.loginType == .phone ? "Phone" : "Email"        
        let captchaApi = FCApi_captcha_resend.init(verificationId: self.verificationId ?? "", channelType: chanType)
        captchaApi.startWithCompletionBlock(success: { (response) in
            if response.responseCode == 0 {
                //
                let result = response.responseObject as? [String : Any]
                
                if let validResult = result?["data"] as? [String : Any] {
                    self.verificationId = validResult["verificationId"] as? String  ?? self.verificationId
                }
            } else{
                
                self.view.makeToast(response.responseMessage, position: .center)
            }
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    private func submitRegisterInfo (code: String) {
        let chanType = self.loginType == .phone ? "Phone" : "Email"
        let verifyApi = FCApi_captcha_verify.init(tBusinessType: "Register", chanType: chanType, captchaId: self.verificationId ?? "", captcha: code)
        verifyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if response.responseCode == 0 {
                
                // let result = response.responseObject as? [String : Any]
                self?.navigationController?.popToRootViewController(animated: true)
            } else{
                
                //self?.view.makeToast(response.responseMessage, position: .center)
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
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
