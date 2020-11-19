
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
            weakSelf?.registerView?.registerBtnClick()
        })
        
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
        
        self.registerView?.registerAction(callback: { [weak self] (loginType: FCLoginType, countryCode: String?, phone: String?, email:String?, password: String, code: String?) in
            
            let registerType = loginType == .phone ? "PhonePassword" : "EmailPassword"
            let register_api = FCApi_account_register.init(registerType: registerType, phoneCode: countryCode, phoneNum: phone, email: email, password: password, invitaionCode: code)
            register_api.startWithCompletionBlock(success: { (response) in
                
                let result = response.responseObject as? [String : AnyObject]
                
                if response.responseCode == 0 {

                    if let validResult = result?["data"] as? [String : Any] {
                        let confirmVC = FCRegisterConfirmController.init()
                             confirmVC.loginType = loginType
                        confirmVC.verificationId = validResult["verificationId"] as? String ?? ""
                        self?.navigationController?.pushViewController(confirmVC, animated: true)
                    }
                } else{
                    
                    let errMsg = result?["err"]?["msg"] as? String
                    self?.view.makeToast(errMsg, position: .center)
                }
                
            }) { (response) in
                self?.view.makeToast(response.error?.localizedDescription, position: .center)
            }
        })
        
        self.registerView?.loginAction(callback: { [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
        })
    }
    
    private func navigateToRegisterComfirm () {
        //        let confirmVC = FCRegisterConfirmController.init()
        //                confirmVC.loginType = loginType
        //        confirmVC.inviteCode = code ?? ""
        //        if loginType == .phone {
        //            confirmVC.countryCode = countryCode ?? ""
        //            confirmVC.phoneNum = account
        //            confirmVC.password = password
        //        } else {
        //            confirmVC.email = account
        //            confirmVC.password = password
        //        }
        //
        //        self?.navigationController?.pushViewController(confirmVC, animated: true)
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
