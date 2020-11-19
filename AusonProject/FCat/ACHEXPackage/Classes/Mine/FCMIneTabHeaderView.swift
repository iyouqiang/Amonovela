
//
//  FCMIneTabHeaderView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/18.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCMIneTabHeaderView: UIView {
    
    var safeCenterBtn: UIButton?
    var identityBtn: UIButton?
    var portraitBtn: UIButton?
    var accountLab: UILabel?
    var uidLab: UILabel?
    var verifyBtn: UIButton?
    
    var inviteFriendBtn: UIButton?
    var inviteFriendLab: UIButton?
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var userData: FCUserInfoModel?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadsubViews()
        self.refreshAfterLoginOrLogOut()
    }
    
    func refreshAfterLoginOrLogOut() {
        
        self.userData = FCUserInfoManager.sharedInstance.userInfo
        
        if(FCUserInfoManager.sharedInstance.isLogin && self.userData != nil) {
            self.accountLab?.text = self.userData?.userName
            self.uidLab?.text =  "UID: \(self.userData?.userId ?? "---")"
            
            guard let state = Int(FCUserInfoManager.sharedInstance.userInfo?.state ?? "0") else { return  }
            
            if state > 0 {
               
                self.verifyBtn?.setImage(UIImage(named: "mine_verified"), for: .normal)
                self.verifyBtn?.setTitle("已认证", for: .normal)
            }else {
                
                self.verifyBtn?.setImage(UIImage(named: "mine_unverify"), for: .normal)
                 self.verifyBtn?.setTitle("未认证", for: .normal)
            }
            
        } else {
            self.accountLab?.text = "未登录/注册"
            self.uidLab?.text = "UID: ---"
            self.verifyBtn?.setImage(UIImage(named: "mine_unverify"), for: .normal)
             self.verifyBtn?.setTitle("未认证", for: .normal)
        }
    }
    
    private func loadsubViews () {
        
        self.backgroundColor = COLOR_BGColor
        
        //let imgView = fc_imageViewInit(imageName: "mine_header")
        //self.addSubview(imgView)
        
        let userBgView = UIView()
        userBgView.backgroundColor = COLOR_CellBgColor
        userBgView.layer.cornerRadius = 8.0
        userBgView.isUserInteractionEnabled = true
        userBgView.clipsToBounds = true
        self.addSubview(userBgView)
        userBgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(15)
            make.height.equalTo(90)
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(loginAction))
        userBgView.addGestureRecognizer(tap)
        
//        imgView.isUserInteractionEnabled = true
//        imgView.snp.makeConstraints { (make) in
//            make.top.equalToSuperview().offset(kMarginScreenLR)
//            make.bottom.equalToSuperview().offset(-kMarginScreenLR)
//            make.left.equalToSuperview().offset(kMarginScreenLR)
//            make.right.equalToSuperview().offset(-kMarginScreenLR)
//        }
        
        //self.portraitBtn = fc_buttonInit(imgName: "mine_portrait")
        self.accountLab = fc_labelInit(text: "未登录/注册", textColor: COLOR_White, textFont: 22, bgColor: COLOR_Clear)
        self.accountLab?.isUserInteractionEnabled = true
        self.uidLab = fc_labelInit(text: "UID: ---", textColor: COLOR_MinorTextColor, textFont: 16, bgColor: COLOR_Clear)
        self.verifyBtn = fc_buttonInit(imgName: "mine_unverify", title: "未认证", fontSize: 15, titleColor: COLOR_MinorTextColor, bgColor: COLOR_SectionFooterBgColor)

        self.verifyBtn?.isUserInteractionEnabled = false
        // self.verifyBtn?.layer.borderWidth = 10
        
        //imgView.addSubview(self.portraitBtn!)
        userBgView.addSubview(self.accountLab!)
        userBgView.addSubview(self.uidLab!)
        userBgView.addSubview(self.verifyBtn!)
        
        /// security center
        let securityView = UIView()
        securityView.layer.cornerRadius = 8.0
        securityView.clipsToBounds = true
        securityView.backgroundColor = COLOR_CellBgColor
        self.addSubview(securityView)
        securityView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(userBgView.snp_bottom).offset(15)
            make.height.equalTo(90)
        }
        
        self.safeCenterBtn = fc_buttonInit(imgName: "mine_safeCenter", bgColor: COLOR_Clear)
        self.identityBtn = fc_buttonInit(imgName: "mine_identity", bgColor: COLOR_Clear)
        self.inviteFriendBtn = fc_buttonInit(imgName: "InviteIcon")
        
        let safeLab = fc_labelInit(text: "安全中心", textColor: COLOR_RichBtnTitleColor, textFont: 15, bgColor: COLOR_Clear)
        let identityLab = fc_labelInit(text: "身份认证", textColor: COLOR_RichBtnTitleColor, textFont: 15, bgColor: COLOR_Clear)
        let inviteLab = fc_labelInit(text: "邀请好友", textColor: COLOR_RichBtnTitleColor, textFont: 15, bgColor: COLOR_Clear)
        
        
        /// 下面是三个按钮
        securityView.addSubview(self.inviteFriendBtn!)
        securityView.addSubview(self.safeCenterBtn!)
        securityView.addSubview(self.identityBtn!)
        securityView.addSubview(safeLab)
        securityView.addSubview(identityLab)
        securityView.addSubview(inviteLab)
        
        /**
        self.portraitBtn?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        })
         */
        
        self.accountLab?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            //make.top.equalTo(self.portraitBtn!.snp.top).offset(10)
            make.top.equalToSuperview().offset(20)
            make.width.greaterThanOrEqualTo(100)
        })
        
        self.verifyBtn?.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        self.verifyBtn?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.accountLab!.snp.centerY)
            make.left.equalTo(self.accountLab!.snp.right).offset(10)
            make.height.equalTo(20)
            make.width.equalTo(70)
        })
        
        self.uidLab?.snp.makeConstraints({ (make) in
            //make.left.equalTo(self.portraitBtn!.snp.right).offset(10)
            make.left.equalToSuperview().offset(20)
            make.top.equalTo(self.accountLab!.snp.bottom)
        })
        
        ///
        let gapSpace = (kSCREENWIDTH - 30 - 32 * 3)/3.0
        self.safeCenterBtn?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.identityBtn!.snp_left).offset(-gapSpace)
            make.centerY.equalTo(self.identityBtn!.snp_centerY)
            make.size.equalTo(CGSize(width: 32, height: 32))
        })
        
        self.identityBtn?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 32, height: 32))
        })
        
        self.inviteFriendBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.identityBtn!.snp_right).offset(gapSpace)
            make.centerY.equalTo(self.identityBtn!.snp_centerY)
            make.size.equalTo(CGSize(width: 32, height: 32))
        })
        
        safeLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.safeCenterBtn!)
            make.top.equalTo(self.safeCenterBtn!.snp.bottom).offset(8)
        }
        
        identityLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.identityBtn!)
            make.top.equalTo(self.identityBtn!.snp.bottom).offset(8)
        }
        
        inviteLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.inviteFriendBtn!)
            make.top.equalTo(self.inviteFriendBtn!.snp.bottom).offset(8)
        }
        
        self.layoutIfNeeded()
        self.verifyBtn?.layer.cornerRadius = 10
    }
    
    @objc func loginAction() {
        
        FCUserInfoManager.sharedInstance.loginState { (model) in
            
        }
    }

}
