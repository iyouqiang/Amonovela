
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavbar()
        setupSubviews()
        
        self.edgesForExtendedLayout = .all
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    
    func setupNavbar () {
        weak var weakSelf = self
//        self.addleftNavigationItemImgNameStr("navbar_back", title: nil, textColor: nil, textFont: nil) {
//            weakSelf?.dismiss(animated: true, completion: nil)
//            weakSelf?.view.endEditing(true)
//        }
        
        self.addrightNavigationItemImgNameStr(nil, title: "重置密码", textColor: COLOR_MinorTextColor, textFont: UIFont(_customTypeSize: 17), clickCallBack: {
            weakSelf?.forgetView?.continueBtnClick()
        })
    }
    
    func setupSubviews (){
        self.title = ""
        self.view.backgroundColor = COLOR_BGColor
        
        self.forgetView = FCForgetPasswordView.init(frame: .zero)
        self.view.addSubview(self.forgetView!)
        self.forgetView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.bottom.equalToSuperview()
        })
        
        self.forgetView?.continueAction(callback: { (isLegal: Bool, loginType: FCLoginType, coutryCode: String?, phone:String?, email:String?) in
            
            print("loginType, coutryCode, phone, email", loginType, coutryCode, phone, email)
            
            let resetVC = FCPasswordResetController.init()
            
            resetVC.loginType = loginType
            if loginType == .phone {
                resetVC.coutryCode = coutryCode ?? ""
                resetVC.phoneNum = phone ?? ""
            } else {
                resetVC.email = email ?? ""
            }
            self.navigationController?.pushViewController(resetVC, animated: true)

        })
        
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
