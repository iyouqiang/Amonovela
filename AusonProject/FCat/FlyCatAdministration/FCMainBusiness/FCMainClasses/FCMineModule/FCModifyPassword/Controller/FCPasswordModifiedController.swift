
//
//  FCPasswordModifiedController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCPasswordModifiedController: UIViewController {
    let disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupNavbar()
        setupSubviews()
    }
    
    
    func setupNavbar () {
        
        self.addmutableleftNavigationItemImgNameStr("navbar_back", title: nil, textColor: nil, textFont: nil) {
            [weak self] in
            self?.navigationController?.popToRootViewController(animated: true)
           }
        
        //self.addmutableleftNavigationItemImgNameStr("nav_close", title: nil, textColor: nil, textFont: nil) {
        // self.navigationController?.dismiss(animated: true)
        // }
        
        /**
        self.addrightNavigationItemImgNameStr(nil, title: "修改密码", textColor: COLOR_MinorTextColor, textFont: UIFont(_customTypeSize: 17), clickCallBack: {
        })
         */
    }
    
    func setupSubviews (){
        self.title = ""
        self.view.backgroundColor = COLOR_BGColor
        
        let statusImgView = fc_imageViewInit(imageName: "modifySuccess")
        let statusLab = fc_labelInit(text: "密码修改成功", textColor: COLOR_White, textFont: 15, bgColor: COLOR_Clear)
        let loginBtn = FCThemeButton.init(title: "马上登录", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
        
        self.view.addSubview(statusImgView)
        self.view.addSubview(statusLab)
        self.view.addSubview(loginBtn)
        
        statusImgView.snp.makeConstraints { (make) in
            make.bottom.equalTo(statusLab.snp.top).offset(-20)
            make.centerX.equalToSuperview()
            make.size.equalTo(CGSize(width: 67.5, height: 67.5))
        }
        
        statusLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(loginBtn.snp.top).offset(-50)
            make.centerX.equalToSuperview()
            make.left.greaterThanOrEqualToSuperview().offset(kMarginScreenLR)
            make.right.lessThanOrEqualToSuperview().offset(-kMarginScreenLR)
        }
        
        loginBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview().offset(-50)
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.height.equalTo(50)
        }
        
        loginBtn.rx.tap.subscribe { [weak self] (event) in
            self?.navigationController?.popToRootViewController(animated: true)
            
            /// 清除登录状态，弹出登录页
            FCUserInfoManager.sharedInstance.remveUserInfo()
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUserLogout), object: nil)
            FCLoginViewController.showLogView { (userModel) in
                
            }
            
        }.disposed(by: disposeBag)
        
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
