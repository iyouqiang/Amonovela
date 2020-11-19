//
//  FCGesturePasswordController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/18.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import UtilsXP

let lessConnectPointsNum: Int = 4
let passwordKey = "gesture_password"
let errorPasswordKey = "error_gesture_password"

enum GType {
    case set
    case verify
    case modify
}

class WarnLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        textAlignment = .center
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func showNormal(with message: String) {
        text = message
        textColor = COLOR_TabBarTintColor
    }

    func showWarn(with message: String) {
        text = message
        textColor = UIColor(gpRGB: 0xC94349)
        layer.gp_shake()
    }
}

typealias PasswrodCallBackblock = (_ isDone: Bool) -> Void
typealias DismissBlock = () -> Void

class FCGesturePasswordController: UIViewController {
    
    fileprivate lazy var microView: UIView = {
       
        let microView = UIView.init(frame: CGRect(x: (kSCREENWIDTH - 60)/2.0, y: kNAVIGATIONHEIGHT + 30, width: 60, height: 60))
        microView.backgroundColor = .clear
        
        return microView
    }()
    
    // MARK: - Properies
    fileprivate lazy var passwordBox: Box = {
        let box = Box(frame: CGRect(x: 50, y: 160 + kNAVIGATIONHEIGHT, width: kSCREENWIDTH - 2 * 50, height: 400))
        box.delegate = self
        return box
    }()

    fileprivate lazy var warnLabel: WarnLabel = {
        let label = WarnLabel(frame: CGRect(x: 50, y: 110 + kNAVIGATIONHEIGHT, width: kSCREENWIDTH - 2 * 50, height: 20))
        label.textAlignment = .center
        label.text = "请输入手势密码"
        label.textColor = COLOR_TabBarTintColor
        return label
    }()

    fileprivate lazy var LoginBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: (kSCREENWIDTH - 200)/2, y: kSCREENHEIGHT - 140, width: 200, height: 60))
        button.setTitle("取消", for: .normal)
        button.setTitleColor(UIColor(gpRGB: 0xD9D9DD), for: .normal)
        button.addTarget(self, action: #selector(cancelTheDrawing(sender:)), for: .touchUpInside)
        return button
    }()
    
    fileprivate lazy var naviBackBtn: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: kSTATUSHEIGHT, width: 60, height: 60))
        //button.setTitle("取消", for: .normal)
        button.setImage(UIImage(named: "navbar_back"), for: .normal)
        button.setTitleColor(UIColor(gpRGB: 0xD9D9DD), for: .normal)
        button.addTarget(self, action: #selector(backGesturePassword), for: .touchUpInside)
        return button
    }()

    var trackArray = [Int]()
    var password: String = ""
    var firstPassword: String = ""
    var secondPassword: String = ""
    var canModify: Bool = false
    var passwrodCallBackblock:PasswrodCallBackblock?
    var dismissBlock: DismissBlock?
    var type: GType? {
        
        didSet {
            if type == .set {
                warnLabel.text = "请设置手势密码"
            } else if type == .verify {
                warnLabel.text = "请输入手势密码"
                LoginBtn.setTitle("忘记密码？", for: .normal)
            } else {
                warnLabel.text = "请输入原手势密码"
                LoginBtn.setTitle("忘记密码？", for: .normal)
            }
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit {
        print("deinit")
    }

    // MARK: - layout
    func setupSubviews() {
        view.backgroundColor = COLOR_BGColor
        title = "手势密码"
    
        gpasswordconfig { (options) in
            options.connectLineStart = .border
            options.normalstyle = .outerStroke
            options.isDrawTriangle = false
            options.connectLineWidth = 4
            options.matrixNum = 3
            options.keySuffix = "yochi"
        }

        view.addSubview(microView)
        view.addSubview(passwordBox)
        view.addSubview(warnLabel)
        view.addSubview(LoginBtn)
        view.addSubview(naviBackBtn)
        drawTheTrajectory()
    }
    
    /// 移除手势密码
  @objc class func removeGesturePassword()
    {
        gpasswordremovePassword()
    }
    
    /// 验证是否存在手势密码
    class func verifiedGesturePassword() -> Bool {
        
        let savePassword = gpasswordgetPassword()
        if savePassword != nil {
            
            return true
        }
        
        return false
    }
    
    /// 显示登录密码
    class func showGesturePasswordView(passwrodCallBackblock: @escaping (_ isDone: Bool) -> Void) {
        
        DispatchQueue.main.async {
            
            let gpVC = FCGesturePasswordController()
            gpVC.modalPresentationStyle = .fullScreen
            kAPPDELEGATE?.topViewController?.present(gpVC, animated: true, completion: {
                             
            })
                         
            gpVC.passwrodCallBackblock = passwrodCallBackblock
        }
    }
}

extension FCGesturePasswordController: GPasswordEventDelegate {
    func sendTouchPoint(with tag: String) {
        print(tag)
        trackArray.append(Int(tag) ?? 0)
        password += tag
    }

    func touchesEnded() {
        print("gesture end")
        for subView in self.microView.subviews {
            subView.removeFromSuperview()
        }
        
        /// 绘制小视图
        drawTheTrajectory()
        trackArray.removeAll()
        
        if password.count < lessConnectPointsNum {
            warnLabel.showWarn(with: "至少连接 4 个点, 请重新绘制")
            warnLabel.textColor = UIColor(gpRGB: 0xC94349)
        } else {
            if type == .set {
                setPassword()
                self.LoginBtn.setTitle("重新绘制", for: .normal)
            } else if type == .modify {
                let savePassword = gpasswordgetPassword()
                if let pass = savePassword {
                    if canModify {
                        setPassword()
                        self.LoginBtn.setTitle("重新绘制", for: .normal)
                    } else {
                        /// 密码验证成功
                        if password == pass {
                            warnLabel.showNormal(with: "请设置手势密码")
                            canModify = true
                            cancelTheDrawing()
                            LoginBtn.setTitle("取消", for: .normal)
                        } else {
                            verifyPasswordError()
                        }
                    }
                }
            } else {
                let savePassword = gpasswordgetPassword() ?? ""
                if password == savePassword {
                    
                    navigationController?.popViewController(animated: true)
                    self.dismiss(animated: true) {
                        /// 密码验证成功
                        self.gesturePasswordVerifiedSuccess()
                        if let passwrodCallBackblock = self.passwrodCallBackblock {
                            passwrodCallBackblock(true)
                        }
                    }
                } else {
                    verifyPasswordError()
                }
            }
        }
        password = ""
    }
}

extension FCGesturePasswordController {
    func setPassword() {
        if firstPassword.isEmpty {
            firstPassword = password
            warnLabel.showNormal(with: "再次输入以确认")
        } else {
            secondPassword = password
            if firstPassword == secondPassword {
                // 保存密码
                gpasswordsave(password: firstPassword)
                warnLabel.showNormal(with: "手势设置成功")
                navigationController?.popViewController(animated: true)
                FCUserInfoManager.sharedInstance.isGestureVerify = true
                self.dismiss(animated: true) {
                    
                    //self.passwrodCallBackblock
                    if let passwrodCallBackblock = self.passwrodCallBackblock {
                        passwrodCallBackblock(true)
                    }
                }
            } else {
                warnLabel.showWarn(with: "密码不一致, 请重新设置")
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    self.warnLabel.showNormal(with: "请设置手势密码")
                }
                firstPassword = ""
                secondPassword = ""
            }
        }
    }

    func verifyPasswordError() {
        
        let errorTitle = "密码错误，请重新绘制"
        warnLabel.showWarn(with: errorTitle)
        
        /***
         gpasswordincreaseErrorNum()
        let errorNum = globalOptions.maxErrorNum - gpasswordgetErrorNum()!
        
        if errorNum == 0 {
            // do action about forgetting password
            warnLabel.showWarn(with: "忘记手势密码?")
        } else {
            var errorTitle = "密码错误, 你还可以输入" + "\(errorNum)"
            errorTitle += "次"
            errorTitle = "密码错误，请重新输入"
            warnLabel.showWarn(with: errorTitle)
        }
         */
    }
    
    func gesturePasswordVerifiedSuccess() {
        
        print("密码验证成功，登录")
    }
    
    @objc func backGesturePassword() {
        
        if let passwrodCallBackblock = self.passwrodCallBackblock {
            passwrodCallBackblock(false)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelTheDrawing(sender: UIButton? = nil) {
    
        /// 点击调用
        if sender != nil {
            
            if self.LoginBtn.titleLabel?.text == "取消" {
                    /// 返回
                self.dismiss(animated: true) {
                       
                    if let passwrodCallBackblock = self.passwrodCallBackblock {
                        passwrodCallBackblock(false)
                    }
                }
                    
                return
            }
            
            if self.LoginBtn.titleLabel?.text == "重新绘制" {
                
                trackArray.removeAll()
                self.drawTheTrajectory()
                /// 密码重新绘制
                gpasswordcloseGesture()
                password = ""
                firstPassword = ""
                warnLabel.showNormal(with: "请设置手势密码")
                return
            }
            
            if ((self.LoginBtn.titleLabel?.text?.contains("忘记密码") ?? false)) {
                
                /// 清除手势并重新登录
                 let alertView = PCCustomAlert(viewWithTitle: "", message: "清除手势密码，并重新登录吗", preferredStyle: PCCustomAlert_Alert)
                 alertView?.addAction("取消", style: PCCustomAction_Normal, btnAction: { (title) in
                     
                     self.dismiss(animated: true, completion: nil)
                 })
                alertView?.addAction("确定", style: PCCustomAction_highlight, btnAction: { (title) in
                     
                 /// 清除登录状态，弹出登录页
                 FCUserInfoManager.sharedInstance.remveUserInfo()
                 NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUserLogout), object: nil)
                 self.dismiss(animated: false) {
                     
                     if let dismissBlock = self.dismissBlock {
                         
                         dismissBlock()
                     }
                 }
                 //FCLoginViewController.showLogView { (userModel) in }
                })
                 
                alertView?.presentViewAlert()
                
                return
            }
            
        }else {
            
        }
 }
    
    func drawTheTrajectory()
    {
        var count = 0
        for x in 0...2 {
            for y in 0...2 {
                
                let mimiView = UIView()
                let avWidth:CGFloat = 10
                mimiView.frame = CGRect(x: CGFloat(y) * (avWidth + avWidth), y: CGFloat(x) * (avWidth + avWidth
                    ), width: avWidth, height: avWidth)
                mimiView.layer.cornerRadius = avWidth/2.0
                mimiView.clipsToBounds = true
                microView.addSubview(mimiView)
                
                if self.trackArray.contains(count) {
                    mimiView.backgroundColor = COLOR_TabBarTintColor
                }else {
                    mimiView.backgroundColor = COLOR_HexColor(0x69696D)
                }
                count += 1
            }
        }
    }
}

