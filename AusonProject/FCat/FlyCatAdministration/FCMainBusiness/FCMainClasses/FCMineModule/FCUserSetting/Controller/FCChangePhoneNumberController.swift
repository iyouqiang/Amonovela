//
//  FCChangePhoneNumberController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/21.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class FCChangePhoneNumberController: UIViewController {
        var changeBtn: FCThemeButton!
        var phoneNumTitleL: UILabel!
        var phoneNumL: UILabel!
        var arrowImgView: UIImageView!
        var lineView: UIView!
        var bottomLabel: UILabel!
        let disposebag = DisposeBag()
        
        override func viewDidLoad() {
            super.viewDidLoad()

            self.edgesForExtendedLayout = .all
            
            self.view.backgroundColor = COLOR_BGColor
            self.title = "手机号码"
            self.setupView()
            
            self.changeBtn?.rx.tap.subscribe({ [weak self] (event) in

                let changeInfoVC = FCChangePhoneInvoController()
                self?.navigationController?.pushViewController(changeInfoVC, animated: true)
                
            }).disposed(by: disposebag)
        }
        
        func setupView() {
            
            var titleStr = FCUserInfoManager.sharedInstance.userInfo?.phoneNumber ?? ""
        
            titleStr = titleStr.count == 0 ? "" : titleStr
            
            /// 标题
            phoneNumTitleL = fc_labelInit(text: titleStr, textColor: COLOR_CellTitleColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
            phoneNumTitleL.text = "手机号码"
            self.view.addSubview(phoneNumTitleL)

            /// 手机号码
            phoneNumL = fc_labelInit(text: titleStr, textColor: COLOR_CellTitleColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
            phoneNumL.textAlignment = .right
            phoneNumL.text = self.replacePhone(str: titleStr)
            self.view.addSubview(phoneNumL)
            
            /// 箭头
            arrowImgView = UIImageView(image: UIImage(named: "cell_arrow_right"))
            self.view.addSubview(arrowImgView)
            
            /// 布局
            phoneNumTitleL.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.width.equalTo(100)
                make.top.equalTo(kNAVIGATIONHEIGHT + 30)
                make.height.equalTo(50)
            }
            
            arrowImgView.snp.makeConstraints { (make) in
                make.right.equalTo(-15)
                make.centerY.equalTo(phoneNumL.snp_centerY)
                make.height.width.equalTo(16)
            }
            
            phoneNumL.snp.makeConstraints { (make) in
                make.left.equalTo(phoneNumTitleL.snp_right)
                make.right.equalTo(arrowImgView.snp_left).offset(-10)
                make.top.equalTo(phoneNumTitleL.snp_top)
                make.height.equalTo(50)
            }
            
            lineView = UIView()
            lineView.backgroundColor = COLOR_TabBarBgColor
            self.view.addSubview(lineView)
            lineView.snp.makeConstraints { (make) in
                make.left.right.equalTo(0)
                make.top.equalTo(phoneNumL.snp_bottom)
                make.height.equalTo(1)
            }
            
            changeBtn = FCThemeButton.init(title: "更换手机号码", frame:CGRect(x: 0, y: 0, width: kSCREENWIDTH - CGFloat(2 * kMarginScreenLR), height: 50) , cornerRadius: 4)
            self.view.addSubview(changeBtn)
            changeBtn.snp.makeConstraints { (make) in
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.top.equalTo(lineView.snp_bottom).offset(30)
                make.height.equalTo(50)
            }
            
            bottomLabel =  fc_labelInit(text: "一个手机号码只能作为一个账号的登录名，绑定手机号码需要通过短信验证码", textColor: COLOR_FooterTextColor, textFont: 15, bgColor: COLOR_Clear)
            self.view.addSubview(bottomLabel)
            bottomLabel.snp.makeConstraints { (make) in
                
                make.top.equalTo(changeBtn.snp_bottom).offset(30)
                make.left.equalTo(15)
                make.right.equalTo(-15)
                make.height.equalTo(44)
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
    
    func replacePhone(str: String) -> String {
        if str.count < 11 {
            return ""
        }
           let start = str.index(str.startIndex, offsetBy: 3)
           let end = str.index(str.startIndex, offsetBy: 7)
           let range = Range(uncheckedBounds: (lower: start, upper: end))
           return str.replacingCharacters(in: range, with: "****")
    }

 }
