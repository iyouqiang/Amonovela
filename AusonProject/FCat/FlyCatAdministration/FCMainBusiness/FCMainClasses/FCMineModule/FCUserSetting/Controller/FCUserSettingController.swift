
//
//  FCuserSettingController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCUserSettingController: UIViewController {
    
    let disposeBag = DisposeBag()
    var userTableView: UITableView!
    //    var tabHeaderView: FCMIneTabHeaderView!
    var userInfoModel: FCUserInfoModel?
    //    typealias Callbcak = () -> Void
    var cellDataSoure: [Int: [FCCustomCellModel]] = [
        0 : [
            FCCustomCellModel.init(leftIcon: nil, title: "修改密码"),
            FCCustomCellModel.init(leftIcon: nil, title: "手机号"),
            FCCustomCellModel.init(leftIcon: nil, title: "邮箱"),
            //FCCustomCellModel.init(leftIcon: nil, title: "Google身份认证",showSwitch: true),
            FCCustomCellModel.init(leftIcon: nil, title: "手势密码", showSwitch: true, showSwitchIsOn: FCGesturePasswordController.verifiedGesturePassword())
        ],
        1 :  [
            FCCustomCellModel.init(leftIcon: nil, title: "退出登录"),
        ]
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.title = "安全中心"
        self.view.backgroundColor = COLOR_BGColor
        // setupNavbar()
        
        setupSubviews()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func setupNavbar () {
        //        weak var weakSelf = self
        self.addrightNavigationItemImgNameStr(nil, title: "设置", textColor: COLOR_MinorTextColor, textFont: UIFont(_customTypeSize: 17), clickCallBack: {
            // weakSelf?.registerView?.registerBtnClick()
        })
    }

    func setupSubviews (){
        /// 存在手势密码 添加修改手势密码栏
        if (FCGesturePasswordController.verifiedGesturePassword()) {
            self.cellDataSoure[0]?.append(FCCustomCellModel.init(leftIcon: nil, title: "修改手势密码"))
        }
        self.userTableView = UITableView.init(frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: self.view.frame.height), style: .plain)
        self.userTableView.bounces    = false
        self.userTableView.delegate   = self
        self.userTableView.dataSource = self
        self.userTableView.separatorColor  = COLOR_LineColor
        self.userTableView.backgroundColor = COLOR_CellBgColor
        self.userTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.userTableView.separatorColor = COLOR_SeperateColor
        self.userTableView.bounces = true
        self.view.addSubview(self.userTableView)
    }
    
    func logoutAction () {
        let logoutApi = FCApi_logout.init(userId: FCUserInfoManager.sharedInstance.userInfo?.userId ?? "")
        logoutApi.startWithCompletionBlock(success: { (response) in
            
            print("response.responseCode ",response.responseCode)
            
            if response.responseCode == 0 {
                //
                //                let result = response.responseObject as? [String : AnyObject]
                //                if let validResult = result?["data"] as? [String : Any] {
                //
                //                    FCUserInfoManager.sharedInstance.saveUserInfo(validResult)
                //                    self.view.makeToast("登录成功", position: .center)
                //                    //发出登陆成功的通知
                //                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUserLogin), object: nil)
                //                    self.navigationController?.dismiss(animated: true)
                //                    self.finishBlock?(FCUserInfoManager.sharedInstance.userInfo ?? FCUserInfoModel.init())
                //                }
                
                 FCUserInfoManager.sharedInstance.remveUserInfo()
                //发出登陆成功的通知
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUserLogout), object: nil)
                //kAPPDELEGATE?.topViewController?.navigationController?.popViewController(animated: true)
                self.navigationController?.popToRootViewController(animated: true)
                
            } else{
                
                self.view.makeToast(response.responseMessage, position: .center)
            }
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
}

extension FCUserSettingController : UITableViewDataSource, UITableViewDelegate {
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            let modelArray = cellDataSoure[indexPath.section]
            let model = modelArray?[indexPath.row]
            
            if model?.title == "修改密码" {
                
                let modifyPasswordVC = FCModifyPasswordController()
                self.navigationController?.pushViewController(modifyPasswordVC, animated: true)
                
            }else if (model?.title == "手机号") {
                
                let changePhoneVC = FCChangePhoneNumberController()
                self.navigationController?.pushViewController(changePhoneVC, animated: true)
            }else if (model?.title == "邮箱") {
                
                let addEmailVC = FCAddEmailViewController()
                self.navigationController?.pushViewController(addEmailVC, animated: true)
                
            }else if (model?.title == "Google身份认证") {
                
                self.view.makeToast("敬请期待", duration: 0.5, position: .center)
                
            }else if (model?.title == "手势密码") {
                
                /**
                if FCGesturePasswordController.verifiedGesturePassword() {
                    return
                }
                
                let gestureVC = FCGesturePasswordController()
                gestureVC.type = .set
                gestureVC.modalPresentationStyle = .fullScreen
                self.present(gestureVC, animated: true) {
    
                }
                 */
            }else if (model?.title == "修改手势密码") {
                   
                let gestureVC = FCGesturePasswordController()
                gestureVC.type = .modify//.verify//.modify
                gestureVC.modalPresentationStyle = .fullScreen
                self.present(gestureVC, animated: true) {
                }
            }
            else {
                
                //退出登录
                self.logoutAction()
            }
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return cellDataSoure[section]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellDataSoure.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 10))
        viewFooter.backgroundColor = COLOR_SectionFooterBgColor
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = cellDataSoure[indexPath.section]?[indexPath.row]
        let cell = FCCustomTableViewCell.init(style: .default, reuseIdentifier: FCCustomTableViewCellIdentifier, leftIcon: model?.leftIcon, title: model?.title, message: model?.message, rightIcon: model?.rightIcon, showSwitch: model?.showSwitch, showSwitchIsOn: model?.showSwitchIsOn)
        
        var desTextL = cell.viewWithTag(999) as? UILabel
        if (desTextL == nil) {
            
            desTextL = UILabel(frame: CGRect(x: kSCREENWIDTH - 290, y: 0, width: 250, height: 50))
            desTextL?.textColor = COLOR_HexColor(0xB0B1B3)
            desTextL?.font = UIFont.systemFont(ofSize: 15)
            desTextL?.adjustsFontSizeToFitWidth = true
            desTextL?.tag = 999
            desTextL?.textAlignment = .right
            cell.addSubview(desTextL!)
        }
        
        if model?.title == "邮箱" {
            
            let emailStr = FCUserInfoManager.sharedInstance.userInfo?.email
            desTextL?.text = emailStr?.count ?? 0 > 0 ? emailStr : "添加"
            
        }else if (model?.title == "手机号") {
            
            let phoneStr = FCUserInfoManager.sharedInstance.userInfo?.phoneNumber
            desTextL?.text = phoneStr?.count ?? 0 > 0 ? phoneStr : ""
            
        }else {
            
            desTextL?.text = ""
        }
        
        cell.switchChangeValueBlock = {
            (sender, str) in
            
            if str == "手势密码" {
                
                let gestureVC = FCGesturePasswordController()
                gestureVC.modalPresentationStyle = .fullScreen
                
                if !sender.isOn {
                    
                    gestureVC.type = .verify
                    gestureVC.passwrodCallBackblock = {
                        (isDone) in
                        
                        /// 移除密码
                        FCGesturePasswordController.removeGesturePassword()
                        
                        /// 界面删除修改手势栏
                        self.cellDataSoure[0]?.removeLast()
                        self.cellDataSoure[0]?.removeLast()
                        self.cellDataSoure[0]?.append( FCCustomCellModel.init(leftIcon: nil, title: "手势密码", showSwitch: true, showSwitchIsOn: FCGesturePasswordController.verifiedGesturePassword()))
                        self.userTableView.reloadData()
                    }
                }else {
                   
                    gestureVC.type = .set
                    gestureVC.passwrodCallBackblock = {
                        (isDone) in
                        
                        if isDone == false {
                            self.userTableView.reloadData()
                            return
                        }
                        
                        // 界面增加修改手势栏
                        self.cellDataSoure[0]?.removeLast()
                        self.cellDataSoure[0]?.append(FCCustomCellModel.init(leftIcon: nil, title: "手势密码", showSwitch: true, showSwitchIsOn: FCGesturePasswordController.verifiedGesturePassword()))
                        self.cellDataSoure[0]?.append(  FCCustomCellModel.init(leftIcon: nil, title: "修改手势密码"))
                        self.userTableView.reloadData()
                    }
                }
                
                self.present(gestureVC, animated: true) {
                
                }
                
                /// 清除密码 退出登录状态
                gestureVC.dismissBlock = {
                    
                    self.navigationController?.popToRootViewController(animated: true)
                }
                
            }else if (str == "Google身份认证") {
                
            }else {
                
            }
            
        }
        
        return cell
    }
    
    func handleCell(_ cell: FCCommonCell, indexPath: NSIndexPath)  {
        
        //        if indexPath.section == 0 && indexPath.row == 0 {
        //
        //            cell.leftIconWidthConstraint.constant = 54
        //        }else {
        //
        //            cell.leftIconWidthConstraint.constant = 20
        //        }
        //
        //        if indexPath.section == 1 {
        //            cell.switchBtn.isHidden  = false
        //            cell.arrowsIcon.isHidden = true
        //        }else {
        //            cell.switchBtn.isHidden  = true
        //            cell.arrowsIcon.isHidden = false
        //        }
        //
        //        var imageStr = ""
        //        var titleStr = ""
        //
        //        if indexPath.section == 0 {
        //
        //            if FCUserInfoManager.sharedInstance.isLogin {
        //
        //                let userInfo = FCUserInfoManager.sharedInstance.getUserInfo()
        //                self.userInfoModel = userInfo;
        //                titleStr = (self.userInfoModel?.phone)!
        //
        //            }else {
        //
        //                titleStr = "请先登录"
        //            }
        //
        //            imageStr = self.imageArray[0] as! String
        //
        //        }else if (indexPath.section == 1) {
        //
        //            imageStr = self.imageArray[1] as! String
        //            titleStr = self.titleArray[0] as! String
        //            cell.switchBtn.isOn = FCUserDefaults.boolForKey(kSMALLASSETS)
        //
        //        }else if (indexPath.section == 2) {
        //
        //            if indexPath.row == 0 {
        //
        //                imageStr = self.imageArray[2] as! String
        //                titleStr = self.titleArray[1] as! String
        //                cell.describeL.text = "fcatcom"
        //            }else {
        //
        //                imageStr = self.imageArray[3] as! String
        //                titleStr = self.titleArray[2] as! String
        //                cell.describeL.text = HREF_Telegram
        //            }
        //
        //        }else {
        //
        //        }
        //
        //        cell.leftIcon.image = UIImage(named: imageStr)
        //        cell.titleL.text = titleStr
    }
}

