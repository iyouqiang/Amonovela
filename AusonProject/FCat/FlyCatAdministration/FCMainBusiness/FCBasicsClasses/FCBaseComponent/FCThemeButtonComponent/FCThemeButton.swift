
//
//  FCThemeButton.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCThemeButton: UIButton {
    
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
    
    init(title: String? = "", titleColor: UIColor? = COLOR_ThemeBtnTextColor, fontSize: CGFloat? = 16, frame: CGRect? = CGRect.zero,cornerRadius: CGFloat? = 0 ) {
        super.init(frame: frame!)
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.init(_customTypeSize: fontSize!)
        self.setTitleColor(titleColor, for: .normal)
        self.layer.cornerRadius = cornerRadius!
        self.backgroundColor = COLOR_ThemeBtnBgColor

        let layer = CAGradientLayer()
        layer.cornerRadius = cornerRadius!
        layer.frame = self.frame
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 1)
        let starColor = COLOR_ThemeBtnStartColor
        let endColor = COLOR_ThemeBtnEndColor
        layer.colors = [starColor.cgColor, endColor.cgColor]
        layer.locations = [0, 1]
        self.layer.insertSublayer(layer, at: 0)

    }
    
    
}
