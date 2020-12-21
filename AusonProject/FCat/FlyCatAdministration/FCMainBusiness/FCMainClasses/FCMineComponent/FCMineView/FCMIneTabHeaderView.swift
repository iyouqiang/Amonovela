
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
    var inviteBtn: UIButton?
    var inviteTitleL: UILabel?
    var loginBtn: UIButton?
    
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
        
        self.clipsToBounds = true
        loadsubViews()
        self.refreshAfterLoginOrLogOut()
    }
    
    func refreshAfterLoginOrLogOut() {
        
        self.userData = FCUserInfoManager.sharedInstance.userInfo
        
        if(FCUserInfoManager.sharedInstance.isLogin && self.userData != nil) {
            self.accountLab?.text = self.userData?.userName
            self.uidLab?.text =  "UID: \(self.userData?.userId ?? "---")"
            
            guard let state = Int(FCUserInfoManager.sharedInstance.userInfo?.kycLevel ?? "0") else { return  }
        
            if state > 0 {
               
                //.verifyBtn?.setImage(UIImage(named: "mine_verified"), for: .normal)
                self.verifyBtn?.isUserInteractionEnabled = false
                self.verifyBtn?.setTitle("已认证", for: .normal)
            }else {
                
                //self.verifyBtn?.setImage(UIImage(named: "mine_unverify"), for: .normal)
                self.verifyBtn?.isUserInteractionEnabled = true
                 self.verifyBtn?.setTitle("待认证", for: .normal)
            }
        } else {
            
            self.verifyBtn?.isUserInteractionEnabled = true
            self.accountLab?.text = "未登录/注册"
            self.uidLab?.text = "UID: ---"
            self.verifyBtn?.setImage(UIImage(named: "authIcon"), for: .normal)
            self.verifyBtn?.setTitle("未认证", for: .normal)
        }
    }
    
    private func loadsubViews () {
        
        /// 渐变背景
        let layer = CAGradientLayer()
        layer.frame = self.bounds
        layer.startPoint = CGPoint(x: 0, y: 0)
        layer.endPoint = CGPoint(x: 1, y: 1)
        let endColor = COLOR_HexColorAlpha(0x2A2F3A, alpha: 0.06)
        let starColor = COLOR_HexColorAlpha(0x626A77, alpha: 1.0)
        layer.colors = [starColor.cgColor, endColor.cgColor]
        layer.locations = [0, 1]
        self.layer.insertSublayer(layer, at: 0)
        
        let imgView = UIImageView()//fc_imageViewInit(imageName: "mine_header")
        imgView.backgroundColor = COLOR_HexColor(0x20262F)
        imgView.clipsToBounds = true
        imgView.layer.cornerRadius = 8
        self.addSubview(imgView)
        imgView.isUserInteractionEnabled = true
        imgView.snp.makeConstraints { (make) in
            make.height.equalTo(90)
            make.bottom.equalToSuperview().offset(15)
            make.left.equalTo(15)
            make.right.equalTo(-15)
        }
        
        /// 头像
        self.portraitBtn = fc_buttonInit(imgName: "mine_portrait")
        
        /// 用户名
        self.accountLab = fc_labelInit(text: "未登录/注册", textColor: UIColor.white, textFont: 20, bgColor: UIColor.clear)
        self.accountLab?.isUserInteractionEnabled = true
        
        self.loginBtn = UIButton(type: .custom)
        self.accountLab?.addSubview(loginBtn!)
        self.loginBtn?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        /// 用户id
        self.uidLab = fc_labelInit(text: "UID: ---", textColor: COLOR_MinorTextColor, textFont: 15, bgColor: UIColor.clear)
        
        /// 认证id
        self.verifyBtn = fc_buttonInit(imgName: "authIcon", title: "未认证", fontSize: 14, titleColor: UIColor.white, bgColor: UIColor.clear)
        self.verifyBtn?.layer.cornerRadius = 10.0
        self.verifyBtn?.semanticContentAttribute = .forceRightToLeft;
        
        self.verifyBtn?.layer.borderWidth = 12.5
        self.verifyBtn?.layer.borderColor = COLOR_HexColor(0xA9A9A9).cgColor
        self.verifyBtn?.layer.borderWidth = 1.0
        self.safeCenterBtn = fc_buttonInit(imgName: "mine_safeCenter", bgColor: UIColor.clear)
        self.identityBtn = fc_buttonInit(imgName: "mine_identity", bgColor: UIColor.clear)
        
        self.inviteTitleL = fc_labelInit(text: "邀请有奖", textColor: UIColor.white, textFont: 25, bgColor: UIColor.clear)
        self.inviteTitleL?.textAlignment = .left
        
        self.inviteBtn = fc_buttonInit(imgName: "", title: "邀请", fontSize: 15, titleColor: UIColor.white, bgColor: .clear)
        self.inviteBtn?.layer.cornerRadius = 15.0
        self.inviteBtn?.layer.borderWidth = 1
        self.inviteBtn?.layer.borderColor = COLOR_MainThemeColor.cgColor
        self.inviteBtn?.setTitleColor(UIColor.white, for: .normal)
        //self.inviteBtn?.addTarget(self, action: #selector(invitepresentGiftAction), for: .touchUpInside)
        
        imgView.addSubview(self.inviteTitleL!)
        imgView.addSubview(self.inviteBtn!)
        
        self.inviteTitleL?.snp_makeConstraints({ (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview().offset(-8)
        })
        
        self.inviteBtn?.snp_makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(self.inviteTitleL!.snp_centerY)
            make.height.equalTo(30)
            make.width.equalTo(85)
        })
        
        self.addSubview(self.portraitBtn!)
        self.addSubview(self.accountLab!)
        self.addSubview(self.uidLab!)
        self.addSubview(self.verifyBtn!)
        self.addSubview(self.safeCenterBtn!)
        self.addSubview(self.identityBtn!)
        //self.addSubview(safeLab)
        //self.addSubview(identityLab)
        
        self.portraitBtn?.snp.makeConstraints({ (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(self.uidLab!.snp_centerY)
            make.size.equalTo(CGSize(width: 60, height: 60))
        })
        
        self.accountLab?.snp.makeConstraints({ (make) in
            make.left.equalTo(15)
            make.top.equalTo(kNAVIGATIONHEIGHT)
        })
        
        self.verifyBtn?.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -10)
        self.verifyBtn?.snp.makeConstraints({ (make) in
            
            make.top.equalTo(self.uidLab!.snp_bottom).offset(12)
            make.left.equalTo(self.accountLab!.snp.left)
            make.height.equalTo(20)
            make.width.equalTo(80)
        })
        
        self.uidLab?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.accountLab!.snp_left)
            make.top.equalTo(self.accountLab!.snp.bottom)
        })
        
        /**
        self.safeCenterBtn?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview().multipliedBy(0.6)
            make.size.equalTo(CGSize(width: 32, height: 32))
        })
        
        self.identityBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.accountLab!.snp_left)
            make.size.equalTo(CGSize(width: 32, height: 32))
        })
        
        safeLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.safeCenterBtn!)
            make.top.equalTo(self.safeCenterBtn!.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-30)
        }
        
        identityLab.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.identityBtn!)
            make.top.equalTo(self.identityBtn!.snp.bottom).offset(8)
            make.bottom.equalToSuperview().offset(-30)
        }
         */
        
        self.layoutIfNeeded()
    }
    
    @objc func invitepresentGiftAction() {
        
        print("邀请有礼")
    }
    

}
