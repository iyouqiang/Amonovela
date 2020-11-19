
//
//  FCModifyPasswordController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCModifyPasswordController: UIViewController {
    
    var modifyView: FCPasswordModifyView?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.edgesForExtendedLayout = .all
        // Do any additional setup after loading the view.
        setupNavbar()
        setupSubviews()
    }
    
    func setupNavbar () {
        
        //weak var weakSelf = self
        
        /// 只显示文字
        self.addrightNavigationItemImgNameStr(nil, title: "修改密码", textColor: COLOR_MinorTextColor, textFont: UIFont(_customTypeSize: 17), clickCallBack: {
            //weakSelf?.modifyView?.confirmBtnClick()
        })
    }
    
    func setupSubviews (){
        self.title = ""
        self.view.backgroundColor = COLOR_BGColor
        self.modifyView = FCPasswordModifyView.init(frame: .zero)
        self.view.addSubview(self.modifyView!)
        
        self.modifyView?.snp.makeConstraints({ (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.bottom.equalToSuperview()
        })
        
        self.modifyView?.confirmAction(callback: { [weak self] (oldPwd: String, newPwd: String) in
            
            self?.modifyPassword(oldPwd: oldPwd, newPwd: newPwd)
        })
    }
    
    private func modifyPassword(oldPwd: String, newPwd: String) {
        
        /// 修改密码 跳转到修改成功界面
        let userId = FCUserInfoManager.sharedInstance.userInfo?.userId
        
        let modifyApi = FCApi_password_modify(userId: userId ?? "", oldPassword: oldPwd, newPassword: newPwd)
        modifyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as? [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                let resultVC = FCPasswordModifiedController.init()
                self?.navigationController?.pushViewController(resultVC, animated: true)
                
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
