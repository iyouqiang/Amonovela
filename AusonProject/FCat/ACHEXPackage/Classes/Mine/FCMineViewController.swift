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

import ZendeskCoreSDK
import SupportProvidersSDK
import AnswerBotProvidersSDK
import ChatProvidersSDK

import AnswerBotSDK
import MessagingSDK
import MessagingAPI
import SDKConfigurations

import SupportSDK
import ChatSDK

class FCMineViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var userTableView: UITableView!
    var tabHeaderView: FCMIneTabHeaderView!
    var userInfoModel: FCUserInfoModel?
    typealias Callbcak = () -> Void
    let cellDataSoure: [Int: [FCCustomCellModel]] = [
        0 : [
            FCCustomCellModel.init(leftIcon: "mine_service", title: "在线客服")
            //FCCustomCellModel.init(leftIcon: "mine_help", title: "帮助中心"),
        ],
        1 :  [
            
            FCCustomCellModel.init(leftIcon: "mine_setting", title: "设置"),
            FCCustomCellModel.init(leftIcon: "mine_about", title: "关于我们")
            //FCCustomCellModel.init(leftIcon: "mine_version", title: "检查版本", message: "1.0.0"),
        ]
    ]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //self.navigationController?.setNavigationBarHidden(true, animated: false)
        if FCUserInfoManager.sharedInstance.isLogin {
            
            getUserInfo()
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
        
        configZendesk()
        
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
        
        self.addleftNavigationItemImgNameStr("", title: "我的", textColor: .white, textFont: UIFont.systemFont(ofSize: 22)) {
        }
        
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
                    
                        // 主线程同步登录信息
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
            
            self?.checkLoginStatus(callback: {

                let settingVC = FCUserSettingController.init()
                settingVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(settingVC, animated: true)
            })
            
        }).disposed(by: self.disposeBag)
        
        self.tabHeaderView.inviteFriendBtn?.rx.tap.subscribe({ [weak self] (event) in
           
            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_INVITE))!
                webVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(webVC, animated: true)
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
    
    func configZendesk() {
        
        /// 账号初始化
        Zendesk.initialize(appId: "608de082c4033714aa5abb4ba1ef786778db8d5ecb05b5e2",
            clientId: "mobile_sdk_client_0f056517e831c4c25103",
            zendeskUrl: "https://supportchex.zendesk.com")
        Support.initialize(withZendesk: Zendesk.instance)

        /// 小机器人
        AnswerBot.initialize(withZendesk: Zendesk.instance, support: Support.instance!)
        let chat = Chat.initialize(accountKey: "bSAJxnD9HZ6hHCYRWov22pDHWNeMSwBR")
        
        /// 创建匿名账号
        let ident = Identity.createAnonymous()
        Zendesk.instance?.setIdentity(ident)
        
        /**
         surfingzhang@163.com
         团队名称：supportchex
         密码：xiangbing2020！
         */
        //let identity = Identity.createAnonymous(name: "supportchex", email: "surfingzhang@163.com")
        //Zendesk.instance?.setIdentity(identity)
    }
    
    func status(for info: String?) -> FormFieldStatus {
        info?.isEmpty == true ? .optional: .hidden
    }

    // pass chatUIConfig into buildUI(engines:, configs:)
    
    func buildUI() throws -> UIViewController {
        
        let messagingConfiguration = MessagingConfiguration()
        messagingConfiguration.name = "CHEX"
        messagingConfiguration.botAvatar = UIImage(named: "APPIcon")!
        messagingConfiguration.isMultilineResponseOptionsEnabled = true
        
        let answerBotEngine = try AnswerBotEngine.engine()
        let supportEngine = try SupportEngine.engine()
        let chatEngine = try ChatEngine.engine()
        
        return try Messaging.instance.buildUI(engines: [ answerBotEngine, supportEngine, chatEngine],
                                              configs: [messagingConfiguration])
    }
    
    private func pushViewController() throws {
        
        let viewController = try buildUI()
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
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
            
            do {
                       
                try pushViewController()
                       
            } catch {
                          
                print("在线客服报错",error)
            }

        } else if indexPath.section == 1 {
            
            if indexPath.row == 0 {
                  
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


