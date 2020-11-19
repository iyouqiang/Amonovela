//
//  FCAddEmailViewController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/21.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FCAddEmailViewController: UIViewController {

    var inputEmailTextField: FCEmailComponent!
    var codeComponent: FCTextFieldComponent!
    var countdownBtn: FCCountDownButton!
    var loginPwdcomponent: FCPasswordComponent!
    var bottomLab: UILabel!
    var confirmBtn: FCThemeButton!
    let disposebag = DisposeBag()
    typealias callback = () -> Void
    var codeCallback: callback?
    var verificationId: String?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .all
        self.title = "添加邮箱"
        self.view.backgroundColor = COLOR_BGColor
        
        self.setupView()
        
        self.countdownBtn?.rx.tap.subscribe({ [weak self] (event) in
            
            if (self?.inputEmailTextField?.textFiled?.text?.count == 0) {
                
                self?.bottomLab.text = "请输入邮箱账号"
                self?.shakeAnimation()
                return
            }
            
            if !(FCRegularExpression.isEmailLagal(email: self?.inputEmailTextField?.textFiled?.text)) {
                
                self?.bottomLab.text = "邮箱格式不正确"
                self?.shakeAnimation()
                return
            }
            
            self?.countdownNow()
            self?.codeCallback?()
            }).disposed(by: disposebag)
        
        self.confirmBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.confirmAddEmailAction()
        }).disposed(by: disposebag)
    }
    
    func setupView() {
        
        self.inputEmailTextField = FCEmailComponent.init(placeholder: "请输入邮箱账号", leftImg: "")
        self.inputEmailTextField.textFieldDidBeginEditingBlock = {
            [weak self] in
            self?.bottomLab.isHidden = true
            self?.bottomLab.textColor = COLOR_FooterTextColor
        }
        
        self.view.addSubview(self.inputEmailTextField)
        
        self.codeComponent = FCPasswordComponent.init(placeholder: "请输入6位验证码")
        self.view.addSubview(self.codeComponent)
        self.codeComponent.textFieldDidBeginEditingBlock = {
            [weak self] in
            self?.bottomLab.isHidden = true
            self?.bottomLab.textColor = COLOR_FooterTextColor
        }
        
        self.countdownBtn = FCCountDownButton.init(normalTitle: "获取验证码", countdownTitle: "后重试", resendTitle: "重新发送验证码", duration: 60)
        self.view.addSubview(self.countdownBtn)
        self.countdownBtn?.contentHorizontalAlignment = .right
        self.codeComponent?.textFiled.rightView = self.countdownBtn
        self.codeComponent?.textFiled.rightViewMode = .always
        
         self.loginPwdcomponent = FCPasswordComponent.init(placeholder: "请输入登录密码", leftImg: "")
        self.view.addSubview(self.loginPwdcomponent)
        self.loginPwdcomponent.textFieldDidBeginEditingBlock = {
            [weak self] in
            self?.bottomLab.isHidden = true
            self?.bottomLab.textColor = COLOR_FooterTextColor
        }
        
        self.bottomLab =  fc_labelInit(text: "6-16位含数字和字母组合，并与原密码不同", textColor: COLOR_FooterTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.bottomLab.isHidden = true
        self.view.addSubview(self.bottomLab)
        self.confirmBtn = FCThemeButton.init(title: "确定", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        
        self.view.addSubview(self.confirmBtn)
        
        self.inputEmailTextField.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(kNAVIGATIONHEIGHT + 30)
            make.height.equalTo(50)
        }
        
        self.codeComponent.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.inputEmailTextField.snp_left)
            make.right.equalTo(self.inputEmailTextField.snp_right)
            make.height.equalTo(50)
            make.top.equalTo(self.inputEmailTextField.snp_bottom).offset(30)
        }
        
        self.countdownBtn.snp.makeConstraints { (make) in
            
            make.height.equalTo(40)
        }
        
        self.loginPwdcomponent.snp.makeConstraints { (make) in
        
            make.left.equalTo(self.inputEmailTextField.snp_left)
            make.right.equalTo(self.inputEmailTextField.snp_right)
            make.height.equalTo(50)
            make.top.equalTo(self.codeComponent.snp_bottom).offset(30)
        }
        
        self.bottomLab.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.inputEmailTextField.snp_left)
            make.right.equalTo(self.inputEmailTextField.snp_right)
            make.height.equalTo(30)
            make.top.equalTo(self.loginPwdcomponent.snp_bottom).offset(30)
        }
        
        self.confirmBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.inputEmailTextField.snp_left)
            make.right.equalTo(self.inputEmailTextField.snp_right)
            make.height.equalTo(50)
            make.top.equalTo(self.bottomLab.snp_bottom).offset(30)
        }
    }
    
    func countdownNow () {
        
        self.countdownBtn?.deinitTimer()
        self.countdownBtn?.setupTimer()
            
        self.userEmailModifyApply(email: self.inputEmailTextField.textFiled.text ?? "") { (verifcatinoId) in
            
            self.verificationId = verifcatinoId
        }

    }
    
    private func fetchCaptcha () {

        /**
        let captchaApi = FCApi_captcha_send(busType: "ModifyEmail", chanType: "Email", phoneCode: "", phoneNum: "", email: self.inputEmailTextField.textFiled.text)
        captchaApi.startWithCompletionBlock(success: { (response) in
            if response.responseCode == 0 {
                //
                let result = response.responseObject as? [String : Any]
                
                if let validResult = result?["data"] as? [String : Any] {
                    self.verificationId = validResult["verificationId"] as? String  ?? self.verificationId
                }
            } else{
                
                //self.view.makeToast(response.responseMessage, position: .center)
            }
        }) { (response) in
            //self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
         */
    }
    
    /// 申请修改邮箱
    func userEmailModifyApply(email:String, verificationIdBlock: @escaping  (_ verificationId : String) -> Void) {
        
        let applyModifyApi = FCApi_email_modify_apply(email: email)
        applyModifyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as? [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                let data = responseData?["data"] as? [String: AnyObject]
                let verificationId = data?["verificationId"] as? String
                
                verificationIdBlock(verificationId ?? "")
                    
            }else {
                   
                self?.countdownBtn.reapplyVerificationCode()
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
                
            }) { [weak self] (response) in
                
                self?.view.makeToast(response.responseMessage, position: .center)
        }

    }
    
    /// 确认修改
    func confirmAddEmailAction() {
        
        /// 邮箱格式判断
        if (self.inputEmailTextField?.textFiled?.text?.count == 0) {
            
            self.bottomLab.text = "请输入邮箱账号"
            self.shakeAnimation()
            return
        }
        
        if !(FCRegularExpression.isEmailLagal(email: self.inputEmailTextField?.textFiled?.text)) {
            
            self.bottomLab.text = "邮箱格式不正确"
            self.shakeAnimation()
            return
        }
        
        /// 验证码判断
        if (self.codeComponent?.textFiled?.text?.count == 0) {
            
            self.bottomLab.text = "请输入正确验证码"
            self.shakeAnimation()
            return
        }
        
        /// 登录密码判断
        if (self.codeComponent?.textFiled?.text?.count == 0) {
            
            self.bottomLab.text = "请输入登录密码"
            self.shakeAnimation()
            return
        }
        
        let modifyConfigrApi = FCApi_email_moify_confirm(verificationId: self.verificationId ?? "", verificationCode: self.codeComponent.textFiled.text ?? "", loginPassword: self.loginPwdcomponent.textFiled.text ?? "")
              modifyConfigrApi.startWithCompletionBlock(success: { [weak self] (response) in
                let responseData = response.responseObject as? [String : AnyObject]
                if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                          
                    self?.navigationController?.popToRootViewController(animated: true)
                      
                      /// 清除登录状态，弹出登录页
                    /**
                      FCUserInfoManager.sharedInstance.remveUserInfo()
                      NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUserLogout), object: nil)
                      FCLoginViewController.showLogView { (userModel) in
                      }
                     */
                    
                }else {
                             
                    let errMsg = responseData?["err"]?["msg"] as? String
                    self?.view.makeToast(errMsg ?? "", position: .center)
                }
                          
              }) { [weak self] (response) in
                          
                self?.view.makeToast(response.responseMessage, position: .center)
        }
        
        /// 确认添加邮箱
    }

    func shakeAnimation(){
        
        self.bottomLab.textColor = COLOR_TipsTextColor;
        self.bottomLab.isHidden = false
        let kfa = CAKeyframeAnimation()
        kfa.keyPath = "transform.translation.x"
        let s = 16
        kfa.values = [-s,0,s,0,-s,0,s,0]
        kfa.duration = 0.1
        kfa.repeatCount = 2
        kfa.isRemovedOnCompletion = true
        self.bottomLab.layer.add(kfa, forKey: "shake")
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
