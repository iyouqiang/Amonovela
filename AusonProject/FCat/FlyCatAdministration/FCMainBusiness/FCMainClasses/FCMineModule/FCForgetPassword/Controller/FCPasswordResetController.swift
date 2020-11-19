
//
//  FCPasswordResetController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCPasswordResetController: UIViewController {
    var loginType: FCLoginType = .phone
    var coutryCode: String = ""
    var phoneNum: String = ""
    var email: String = ""
    var verificationId: String = ""
    
    var resetView: FCPasswordResetView?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavbar()
        setupSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.resetView?.countdownBtn?.deinitTimer()
    }
    
    func setupNavbar () {
        weak var weakSelf = self
        
        self.edgesForExtendedLayout = .all
        
        self.addrightNavigationItemImgNameStr(nil, title: "重置密码", textColor: COLOR_MinorTextColor, textFont: UIFont(_customTypeSize: 17), clickCallBack: {
            weakSelf?.resetView?.confirmBtnClick()
        })
    }

    func setupSubviews (){
        self.title = ""
        self.view.backgroundColor = COLOR_BGColor
        
        self.resetView = FCPasswordResetView.init(loginType: self.loginType)
        self.view.addSubview(self.resetView!)
        self.resetView?.snp.makeConstraints({ (make) in
                        make.top.equalToSuperview()
                        make.left.equalToSuperview().offset(kMarginScreenLR)
                        make.right.equalToSuperview().offset(-kMarginScreenLR)
                        make.bottom.equalToSuperview()
        })
        
        self.resetView?.codeCallback = {
            
            [weak self] in
            self?.userResetApply(verificationIdBlock: { [weak self] (verificationId) in
                 
                self?.verificationId = verificationId
            })
        }
        
        self.resetView?.confirmAction(callback: { [weak self](pwd: String, validPwd: String, code: String) in
            
            let confirmApi = FCApi_Password_ResetConfirm(verificationId: self?.verificationId ?? "", verificationCode: code, password: validPwd)
            
            confirmApi.startWithCompletionBlock(success: { [weak self] (response) in
              let responseData = response.responseObject as? [String : AnyObject]
              if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                        
                  self?.navigationController?.popToRootViewController(animated: true)
                
              }else {
                           
                  let errMsg = responseData?["err"]?["msg"] as? String
                  self?.view.makeToast(errMsg ?? "", position: .center)
              }
                        
            }) { [weak self] (response) in
                        
              self?.view.makeToast(response.responseMessage, position: .center)
            }
     })
    }
    
    /// 申请修改邮箱
    func userResetApply(verificationIdBlock: @escaping  (_ verificationId : String) -> Void) {
        
        let channelType = self.loginType == .phone ? "Phone" : "Email"
        
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
