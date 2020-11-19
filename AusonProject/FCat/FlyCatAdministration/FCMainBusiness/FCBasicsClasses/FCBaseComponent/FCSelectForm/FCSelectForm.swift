
//
//  FCSelectForm.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/17.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCSelectForm: UIView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    init(frame: CGRect, leftIcon: String?, title: String?, message: String?, rightIcon: String? ) {
        super.init(frame: frame)
        
        self.backgroundColor = COLOR_CellBgColor

        let leftIconView = UIImageView.init(image: UIImage.init(named: leftIcon ?? ""))
        let titleLab = fc_labelInit(text: title, textColor: COLOR_BGColor, textFont: 16, bgColor: COLOR_Clear)
        titleLab.numberOfLines = 1
        var messageLab: UILabel?
        let arrowImageView = UIImageView.init(image: UIImage.init(named: "cell_arrow_right"))
        
        self.addSubview(leftIconView)
        self.addSubview(titleLab)
        self.addSubview(arrowImageView)
        
        if let validMsg = message {
            messageLab = fc_labelInit(text: validMsg, textColor: COLOR_BGColor, textFont: 16, bgColor: COLOR_Clear)
            self.addSubview(messageLab!)
            messageLab?.numberOfLines = 1
        }
        //           self.accessoryView = arrowImageView
        
        leftIconView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(leftIconView.snp.left).offset(-kMarginScreenLR)
            make.right.lessThanOrEqualToSuperview()
        }
        
        if let validMsgLab = messageLab {
            validMsgLab.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(arrowImageView.snp.left).offset(-kMarginScreenLR)
                make.left.greaterThanOrEqualTo(titleLab.snp.right).offset(20)
            }
        }
        
        arrowImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 16, height: 16))
            make.right.equalToSuperview()
        }
    }
    
    
}
