//
//  FCLoginViewController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/2.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import IQKeyboardManager

class FCLoginViewController: UIViewController {
    
    var phoneTextField: UITextField!
    var codeTextField: UITextField!
    var getCodeL: UILabel!
    var affirmBtn: UIButton!
    var phoneWarmingL: UILabel!
    var CodeWarmingL: UILabel!
    var bgTimeInterval: Int = 0
    var fgTimeInterval: Int = 59
    var gt_token: String!
    private var timer: DispatchSourceTimer?
    var pageStepTime: DispatchTimeInterval = .seconds(1)
    
    typealias FinishBlock = (_ userInfoModel: FCUserInfoModel) -> Void
    var finishBlock: FinishBlock?
    var loginView: FCLoginView?
    
    deinit {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupSubviews()
        
        //adjuestInsets()
        
        self.edgesForExtendedLayout = .all
        
        //self.navigationController?.delegate = self
    }
    
    func setupSubviews () {
        //        self.title = "登录/注册"
        self.view.backgroundColor = COLOR_BGColor
        //self.adjuestInsets()
        self.setupNavbar()
        
        let loginView = FCLoginView.init(frame: CGRect.zero)
        self.loginView = loginView
        self.view.addSubview(loginView)
        
        loginView.snp.makeConstraints { (make) in
            //make.top.equalToSuperview()
            make.top.equalTo(50)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        loginView.loginAction {[unowned self] (isLegal: Bool, loginType: FCLoginType, coutryCode: String?, phone: String?, phonePwd: String?, email: String?, emailPwd: String?) in
            self.signIn(loginType: loginType, coutryCode: coutryCode, phone: phone, phonePwd: phonePwd, email: email, emailPwd: emailPwd)
        }
        
        loginView.forgetAction { [unowned self] in
            let forgetVC = FCForgetPasswordController.init()
            self.navigationController?.pushViewController(forgetVC, animated: true)
        }
        
        loginView.registerAction { [unowned self] in
            let registerVC = FCRegisterController.init()
            self.navigationController?.pushViewController(registerVC, animated: true)
        }
        
    }
    
    func setupNavbar () {
        weak var weakSelf = self
        self.addleftNavigationItemImgNameStr("navbar_back", title: nil, textColor: nil, textFont: nil) {
            weakSelf?.dismiss(animated: true, completion: nil)
            weakSelf?.view.endEditing(true)
        }
        
        
        self.addrightNavigationItemImgNameStr(nil, title: "登录", textColor: COLOR_MinorTextColor, textFont: UIFont(_customTypeSize: 17), clickCallBack: {
            // weakSelf?.loginView?.loginBtnClick()
            //            let modifyVC = FCModifyPasswordController.init()
            //            weakSelf?.navigationController?.pushViewController(modifyVC, animated: true)
        })
    }
    
    func signIn (loginType: FCLoginType, coutryCode: String?, phone: String?, phonePwd: String?, email: String?, emailPwd: String?) {
        let type = loginType == .phone ? "PhonePassword" : "EmailPassword"
        let password = loginType == .phone ? phonePwd ?? "" : emailPwd ?? ""
        let loginApi = FCApi_login.init(loginType: type, phoneCode: coutryCode ?? "+86", phoneNumber: phone ?? "", email: email ?? "", password: password)
        loginApi.startWithCompletionBlock(success: { [weak self] (response) in

            //
            let result = response.responseObject as? [String : AnyObject]
            if result?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let validResult = result?["data"] as? [String : Any] {
                                  
                    DispatchQueue.main.async {
                    
                        // 主线程同步登录信息
                        FCUserInfoManager.sharedInstance.saveUserInfo(validResult)
                    }
                    
                    //var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
                    
                    //print("var userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ", userId)
                    
                    self?.view.makeToast("登录成功", position: .center)
                                  //发出登陆成功的通知
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUserLogin), object: nil)
                    self?.navigationController?.dismiss(animated: true)
                    self?.finishBlock?(FCUserInfoManager.sharedInstance.userInfo ?? FCUserInfoModel.init())
                }
                
            }else {
                let errMsg = result?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    @objc class func showLogView(loginBlock: @escaping FinishBlock) {
        DispatchQueue.main.async {
            
            //229278149@qq.com
            
            /// 已经弹过登录了，不弹了
            if kAPPDELEGATE?.topViewController?.isKind(of: FCLoginViewController.self) == true{
                
                let loginController = kAPPDELEGATE?.topViewController as? FCLoginViewController
                loginController?.finishBlock = loginBlock
                return
            }
             
            let loginController = FCLoginViewController()
            loginController.finishBlock = loginBlock
            
            let navVC = PCNavigationController.init(rootViewController: loginController)
            navVC.modalPresentationStyle = .fullScreen
            // navVC.navigationBar.backgroundColor = .red
            kAPPDELEGATE?.topViewController?.present(navVC, animated: true, completion: {
                
            })
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

extension FCLoginViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        let isSelf = viewController.isKind(of: FCLoginViewController.self)

        self.navigationController?.setNavigationBarHidden(isSelf, animated: animated)
    }
}


extension String {
    func toRange(_ range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex, offsetBy: range.location, limitedBy: utf16.endIndex) else { return nil }
        guard let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex) else { return nil }
        guard let from = String.Index(from16, within: self) else { return nil }
        guard let to = String.Index(to16, within: self) else { return nil }
        return from ..< to
    }
}

