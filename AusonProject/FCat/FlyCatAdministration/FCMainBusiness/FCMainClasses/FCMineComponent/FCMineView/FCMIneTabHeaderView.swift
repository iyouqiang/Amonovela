
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
        let imgView = fc_imageViewInit(imageName: "mine_header")
        self.addSubview(imgView)
        imgView.isUserInteractionEnabled = true
        imgView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(kMarginScreenLR)
            make.bottom.equalToSuperview().offset(-kMarginScreenLR)
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.right.equalToSuperview().offset(-kMarginScreenLR)
        }
        
        
        self.portraitBtn = fc_buttonInit(imgName: "mine_portrait")
        self.accountLab = fc_labelInit(text: "未登录/注册", textColor: COLOR_White, textFont: 17, bgColor: COLOR_Clear)
        self.accountLab?.isUserInteractionEnabled = true
        self.uidLab = fc_labelInit(text: "UID: ---", textColor: COLOR_MinorTextColor, textFont: 15, bgColor: COLOR_Clear)
        self.verifyBtn = fc_buttonInit(imgName: "mine_unverify", title: "未认证", fontSize: 15, titleColor: COLOR_MinorTextColor, bgColor: COLOR_SectionFooterBgColor)
        self.verifyBtn?.isUserInteractionEnabled = false
        //        self.verifyBtn?.layer.borderWidth = 10
        self.safeCenterBtn = fc_buttonInit(imgName: "mine_safeCenter", bgColor: COLOR_Clear)
        self.identityBtn = fc_buttonInit(imgName: "mine_identity", bgColor: COLOR_Clear)
        
        let safeLab = fc_labelInit(text: "安全中心", textColor: COLOR_RichBtnTitleColor, textFont: 15, bgColor: COLOR_Clear)
        let identityLab = fc_labelInit(text: "身份认证", textColor: COLOR_RichBtnTitleColor, textFont: 15, bgColor: COLOR_Clear)
        
        imgView.addSubview(self.portraitBtn!)
        imgView.addSubview(self.accountLab!)
        imgView.addSubview(self.uidLab!)
        imgView.addSubview(self.verifyBtn!)
        imgView.addSubview(self.safeCenterBtn!)
        imgView.addSubview(self.identityBtn!)
        imgView.addSubview(safeLab)
        imgView.addSubview(identityLab)
        
        self.portraitBtn?.snp.makeConstraints({ (make) in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 60, height: 60))
        })
        
        self.accountLab?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.portraitBtn!.snp.right).offset(10)
            make.top.equalTo(self.portraitBtn!.snp.top).offset(10)
            make.width.greaterThanOrEqualTo(100)
        })
        
        self.verifyBtn?.contentEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        self.verifyBtn?.snp.makeConstraints({ (make) in
            make.centerY.equalTo(self.accountLab!.snp.centerY)
            make.left.equalTo(self.accountLab!.snp.right).offset(10)
            make.height.equalTo(20)
            make.right.lessThanOrEqualToSuperview().offset(20)
        })
        
        self.uidLab?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.portraitBtn!.snp.right).offset(10)
            make.top.equalTo(self.accountLab!.snp.bottom).offset(10)
        })
        
        self.safeCenterBtn?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview().multipliedBy(0.6)
            make.size.equalTo(CGSize(width: 32, height: 32))
        })
        
        self.identityBtn?.snp.makeConstraints({ (make) in
            make.centerX.equalToSuperview().multipliedBy(1.4)
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
        
        self.layoutIfNeeded()
        self.verifyBtn?.layer.cornerRadius = 10
    }
    

}
