//
//  FCMineViewController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/11.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCMineViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var userTableView: UITableView!
    var tabHeaderView: FCMIneTabHeaderView!
    var userInfoModel: FCUserInfoModel?
    typealias Callbcak = () -> Void
    let cellDataSoure: [Int: [FCCustomCellModel]] = [
        0 : [
            FCCustomCellModel.init(leftIcon: "mine_service", title: "在线客服"),
            FCCustomCellModel.init(leftIcon: "mine_help", title: "帮助中心"),
        ],
        1 :  [
            FCCustomCellModel.init(leftIcon: "mine_invite", title: "邀请好友"),
            FCCustomCellModel.init(leftIcon: "mine_setting", title: "设置"),
            FCCustomCellModel.init(leftIcon: "mine_about", title: "关于我们")
            //FCCustomCellModel.init(leftIcon: "mine_version", title: "检查版本", message: "1.0.0"),
        ]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
  //self.navigationController?.setNavigationBarHidden(true, animated: false)
        if FCUserInfoManager.sharedInstance.isLogin {
            
            getuserInfo()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_BGColor
        self.navigationItem.title = nil
        //self.adjuestInsets()
        self.loadSubviews()
        
        //登入登出通知
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogin))
            .takeUntil(self.rx.deallocated)
            .subscribe { [weak self] _ in
                DispatchQueue.main.async {
                     self?.tabHeaderView.refreshAfterLoginOrLogOut()
                }
        }
        
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogout))
            .takeUntil(self.rx.deallocated)
            .subscribe { [weak self]  _ in
                DispatchQueue.main.async {
                     self?.tabHeaderView.refreshAfterLoginOrLogOut()
                }
        }
    }
    
    
    private func loadSubviews () {
        if FCUserInfoManager.sharedInstance.isLogin {
            
            let userInfo = FCUserInfoManager.sharedInstance.getUserInfo()
            self.userInfoModel = userInfo;
        }
        
        self.userTableView = UITableView.init(frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: self.view.frame.height), style: .plain)
        self.userTableView.bounces    = false
        self.userTableView.delegate   = self
        self.userTableView.dataSource = self
        self.userTableView.separatorColor  = COLOR_LineColor
        self.userTableView.backgroundColor = COLOR_CellBgColor
        self.userTableView.separatorInset = UIEdgeInsets(top: 0, left: CGFloat(kMarginScreenLR + 18 + 10), bottom: 0, right: 0)
        self.userTableView.separatorColor = COLOR_SeperateColor
        self.userTableView.bounces = true
        self.view.addSubview(self.userTableView)
        
        self.tabHeaderView = FCMIneTabHeaderView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 224))
        self.userTableView.tableHeaderView = self.tabHeaderView
        
        // 处理headerview的交互事件
        self.handleHeaderViewActions()
    }
    
    private func refreshAfterLogin () {
        
    }
    
    
    private func refreshAfterLogout () {
        
    }
    
    func getUserInfo()  {
        
        let userInfoApi = FCApi_Get_UserInfo()
        userInfoApi.startWithCompletionBlock { (resposne) in

            let result = resposne.responseObject as? [String : AnyObject]
            if result?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let validResult = result?["data"] as? [String : Any] {
                                  
                    DispatchQueue.main.async {
                    
                        self.userInfoModel =  FCUserInfoModel.stringToObject(jsonData: validResult);
                        self.userTableView.reloadData()
                    }
                }
                
            }else {
           
            }

        } failure: { (response) in
            
        }

    }
    
    private func handleHeaderViewActions () {
        
        //点击了头像
        self.tabHeaderView.portraitBtn?.rx.tap.subscribe({ [weak self] (event) in
           
            self?.checkLoginStatus(callback: {

            })
            
        }).disposed(by: self.disposeBag)
        
        //点击了安全中心
        self.tabHeaderView.safeCenterBtn?.rx.tap.subscribe({ [weak self] (event) in
            
            DispatchQueue.main.async {
                
                self?.checkLoginStatus(callback: {

                    let settingVC = FCUserSettingController.init()
                    settingVC.hidesBottomBarWhenPushed = true
                    self?.navigationController?.pushViewController(settingVC, animated: true)
                })
            }
            
        }).disposed(by: self.disposeBag)
        
        //点击了身份认证
        self.tabHeaderView.identityBtn?.rx.tap.subscribe({ [weak self] (event) in
            
            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_KYC))!
                webVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(webVC, animated: true)
            }
        }).disposed(by: self.disposeBag)
    }
    
    func getuserInfo() {
        
        let userInfo = FCApi_Get_UserInfo()
        userInfo.startWithCompletionBlock { (resposne) in
            
        } failure: { (resposne) in
            
        }
    }
    
    private func checkLoginStatus (callback: kFCBlock?) {
        if FCUserInfoManager.sharedInstance.isLogin {
            callback?()
        } else {
            
            FCLoginViewController.showLogView { (userInfo) in
                
                self.userInfoModel = userInfo
                // 获取用户信息
                self.userTableView.reloadData()
                callback?()
                
                // self.getUserInfo()
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension FCMineViewController : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 选中事件
        if indexPath.section == 0 {
            //self.view.makeToast("敬请期待", duration: 0.5, position: .center)
            PCCustomAlert.showAppInConstructionAlert()
            
        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                
                FCUserInfoManager.sharedInstance.loginState { (model) in
                    
                    let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_INVITE))!
                    webVC.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(webVC, animated: true)
                }
                
            }else if indexPath.row == 1 {
            
            // self.view.makeToast("打开设置", duration: 0.5, position: .center)
            self.checkLoginStatus { [weak self] in
                let settingVC = FCUserSettingController.init()
                settingVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(settingVC, animated: true)
            }
                
            }
            
        } else {
            //self.view.makeToast("敬请期待", duration: 0.5, position: .center)
            PCCustomAlert.showAppInConstructionAlert()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellDataSoure[section]?.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cellDataSoure.count;
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
        let cell = FCCustomTableViewCell.init(style: .default, reuseIdentifier: FCCustomTableViewCellIdentifier, leftIcon: model?.leftIcon, title: model?.title, message: model?.message, rightIcon: model?.rightIcon)
        return cell
    }
    /// 
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


