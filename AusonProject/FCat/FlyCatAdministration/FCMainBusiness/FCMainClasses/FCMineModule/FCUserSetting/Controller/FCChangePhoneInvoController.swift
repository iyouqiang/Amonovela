//
//  FCChangePhoneInvoController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/21.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCChangePhoneInvoController: UIViewController {

    var phoneComponent: FCPhoneComponent!
    var codeComponent: FCTextFieldComponent!
    var countdownBtn: FCCountDownButton!
    var loginPwdcomponent: FCPasswordComponent!
    var confirmBtn: FCThemeButton!
    var bottomLab: UILabel!
    var verificationId : String?
    
    let disposebag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.edgesForExtendedLayout = .all
        
        self.view.backgroundColor = COLOR_BGColor
        self.title = "手机号码"
        self.setupView()
        
        self.countdownBtn?.rx.tap.subscribe({ [weak self] (event) in
                  
            if (self?.phoneComponent?.phoneTxd?.text?.count ?? 0 < 11) {
                      
                self?.bottomLab.text = "请输入正确手机号码"
                self?.shakeAnimation()
                return
            }
                  
            self?.countdownNow()
            
        }).disposed(by: disposebag)
              
        self.confirmBtn?.rx.tap.subscribe({ [weak self] (event) in
            self?.confirmAddEmailAction()
        }).disposed(by: disposebag)
    }
    
    func setupView() {
        
        phoneComponent = FCPhoneComponent.init(frame: .zero)
        phoneComponent.phoneTxd.leftView = nil;
        self.view.addSubview(phoneComponent)
        phoneComponent.textFieldDidBeginEditingBlock = {
            [weak self] in
            self?.bottomLab.isHidden = true
            self?.bottomLab.textColor = COLOR_FooterTextColor
        }
        phoneComponent.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(kNAVIGATIONHEIGHT + 30)
            make.height.equalTo(44)
        }
        
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
        
         self.loginPwdcomponent = FCPasswordComponent.init(placeholder: "请输入手机密码", leftImg: "")
        self.view.addSubview(self.loginPwdcomponent)
        
        /// 底部提示语
        self.bottomLab =  fc_labelInit(text: "6-16位含数字和字母组合，并与原密码不同", textColor: COLOR_FooterTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.bottomLab.isHidden = true
        self.view.addSubview(self.bottomLab)
        
        confirmBtn = FCThemeButton.init(title: "确定", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        self.view.addSubview(confirmBtn)
     
        self.codeComponent.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.phoneComponent.snp_left)
            make.right.equalTo(self.phoneComponent.snp_right)
            make.height.equalTo(50)
            make.top.equalTo(self.phoneComponent.snp_bottom).offset(30)
        }
        
        self.countdownBtn.snp.makeConstraints { (make) in
            
            make.height.equalTo(40)
        }
        
        self.loginPwdcomponent.snp.makeConstraints { (make) in
        
            make.left.equalTo(self.phoneComponent.snp_left)
            make.right.equalTo(self.phoneComponent.snp_right)
            make.height.equalTo(50)
            make.top.equalTo(self.codeComponent.snp_bottom).offset(30)
        }
        
        self.bottomLab.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.phoneComponent.snp_left)
            make.right.equalTo(self.phoneComponent.snp_right)
            make.height.equalTo(30)
            make.top.equalTo(self.loginPwdcomponent.snp_bottom).offset(30)
        }
        
        self.confirmBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(self.phoneComponent.snp_left)
            make.right.equalTo(self.phoneComponent.snp_right)
            make.height.equalTo(50)
            make.top.equalTo(self.bottomLab.snp_bottom).offset(30)
        }
    }
    
    func countdownNow () {
           
           self.countdownBtn?.deinitTimer()
           self.countdownBtn?.setupTimer()
               
           /// 申请验证码
        self.userPhoneModifyApply(phoneCode: self.phoneComponent.coutryCode, phoneNumber: self.phoneComponent.phoneTxd.text ?? "") { (verifcatinoId) in
           
            self.verificationId = verifcatinoId
        }
    }
       
       private func fetchCaptcha () {
           
        let captchaApi = FCApi_captcha_send(busType: "ModifyPhone", chanType: "Phone", phoneCode: self.phoneComponent.coutryCode, phoneNum: self.phoneComponent.phoneTxd.text, email: "")
           captchaApi.startWithCompletionBlock(success: { (response) in
               if response.responseCode == 0 {
                   //
                   let result = response.responseObject as? [String : Any]
                   
                   if let validResult = result?["data"] as? [String : Any] {
                       self.verificationId = validResult["verificationId"] as? String  ?? self.verificationId
                   }
               } else{
                
                self.countdownBtn.reapplyVerificationCode()
                   
                self.view.makeToast(response.responseMessage, position: .center)
               }
           }) { (response) in
               //self.view.makeToast(response.error?.localizedDescription, position: .center)
           }
       }
       
       /// 申请修改邮箱
    func userPhoneModifyApply(phoneCode:String, phoneNumber:String, verificationIdBlock: @escaping  (_ verificationId : String) -> Void) {
           
        let applyModifyApi = FCApi_phone_modify_apply(phoneCode: phoneCode, phoneNumber: phoneNumber)
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
        if (self.phoneComponent?.phoneTxd?.text?.count ?? 0 < 11) {
               
               self.bottomLab.text = "请输入正确手机号码"
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
           
        /// 确认添加手机
        let modifyConfigrApi = FCApi_phone_modify_confirm(verificationId: self.verificationId ?? "", verificationCode: self.codeComponent.textFiled.text ?? "", loginPassword: self.loginPwdcomponent.textFiled.text ?? "")
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
