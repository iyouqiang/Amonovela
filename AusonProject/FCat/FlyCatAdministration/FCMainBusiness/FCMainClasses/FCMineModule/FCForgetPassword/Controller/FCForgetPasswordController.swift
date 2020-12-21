
//
//  FCForgetPasswordController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCForgetPasswordController: UIViewController {
    
    var forgetView: FCForgetPasswordView?
    var verificationId: String = ""
    var verificationCode: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavbar()
        setupSubviews()
        //self.title = "忘记密码"
        
        self.edgesForExtendedLayout = .all
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func setupNavbar () {
        weak var weakSelf = self
        
        
        self.addleftNavigationItemImgNameStr("", title: "", textColor: nil, textFont: nil) {
            weakSelf?.dismiss(animated: true, completion: nil)
            weakSelf?.view.endEditing(true)
        }
         
        /**
        self.addrightNavigationItemImgNameStr(nil, title: "重置密码", textColor: COLOR_MinorTextColor, textFont: UIFont(_PingFangSCTypeSize: 17), clickCallBack: {
            weakSelf?.forgetView?.continueBtnClick()
        })
         */
    }
    
    func setupSubviews (){
        
        self.view.backgroundColor = COLOR_BGColor
        
        self.forgetView = FCForgetPasswordView.init(frame: .zero)
        self.view.addSubview(self.forgetView!)
        self.forgetView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.bottom.equalToSuperview()
        })
        
        self.forgetView?.dismissViewBlock = {
            
            self.navigationController?.popViewController(animated: true)
        }
        
        self.forgetView?.continueAction(callback: { (isLegal: Bool, loginType: FCLoginType, coutryCode: String?, phone:String?, email:String?) in
            
            /// 申请邮箱验证码
            self.userResetApply(loginType: loginType, phoneNum: phone ?? "", coutryCode: coutryCode ?? "", email: email ?? "") { (verificationId) in

                self.verificationId = verificationId
            }
            
            let verificationView = FCVerificationCodeAlertView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: (2.0/3.0)*kSCREENHEIGHT))
            
            if loginType == .phone {
                
                verificationView.setTitleInfo(Str: "(\(coutryCode ?? ""))\(phone ?? "")", loginType: loginType)
            } else {
                
                verificationView.setTitleInfo(Str: email ?? "", loginType: loginType)
            }
            
            verificationView.resendBlock = {
                
                /// 重新发送
                self.userResetApply(loginType: loginType, phoneNum: phone ?? "", coutryCode: coutryCode ?? "", email: email ?? "") { (verificationId) in
                    
                    self.verificationId = verificationId
                }
            }
            
            let alertView = PCCustomAlert(customView: verificationView)
            
            verificationView.inputBoxStrBlock = {
                textStr in
                
                if (kAPPDELEGATE?.topViewController is FCPasswordResetController) {
                    return
                }
                
                if (self.verificationId.count > 0 && textStr.count == 6) {
                    
                    self.verificationCode = textStr
                    alertView?.disappear()
                    let resetVC = FCPasswordResetController.init()
                    resetVC.verificationId = self.verificationId
                    resetVC.verificationCode = textStr
                    resetVC.loginType = loginType
                    if loginType == .phone {
                        resetVC.coutryCode = coutryCode ?? ""
                        resetVC.phoneNum = phone ?? ""
                    } else {
                        resetVC.email = email ?? ""
                    }
                    self.navigationController?.pushViewController(resetVC, animated: true)
                }
            }
        })
    }
    
    
    func userResetApply(loginType: FCLoginType,  phoneNum: String , coutryCode : String, email: String,verificationIdBlock: @escaping  (_ verificationId : String) -> Void) {
        
        let channelType = loginType == .phone ? "Phone" : "Email"
        
        let applyModifyApi = FCApi_Password_ResetApply(channelType: channelType, phoneCode: coutryCode, phoneNumber: phoneNum, email: email)
        applyModifyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as? [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                let data = responseData?["data"] as? [String: AnyObject]
                let verificationId = data?["verificationId"] as? String
                
                verificationIdBlock(verificationId ?? "")
                    
            }else {
                   
                    let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
                }
                
            }) { [weak self] (response) in
                
            self?.view.makeToast(response.responseMessage, position: .center)
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
