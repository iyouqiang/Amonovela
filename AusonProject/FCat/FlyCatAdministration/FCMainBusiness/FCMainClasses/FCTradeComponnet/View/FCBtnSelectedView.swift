//
//  FCBtnSelectedView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCBtnSelectedView: UIView {
    
    var cornerRadius:CGFloat = 5
    var borderColor = COLOR_InputText
    var borderWidth:CGFloat = 0.8
    var titleColor = COLOR_CellTitleColor
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var clickItemBlock: ((_ index: Int,_ title: String) -> Void)?
    var selectedBtn: UIButton?
    var titleArray: [String]? {
        
        didSet {
            
            guard let titleArray = titleArray else {
                return
            }
            
            /// 移除所有界面
            for view in self.subviews {
                view .removeFromSuperview()
            }
            
            let viewWidth = self.frame.width > 0 ? self.frame.width : kSCREENWIDTH
            let gap: CGFloat = 8.0
            let totoalGap = CGFloat((titleArray.count - 1)) * gap
            let btnWidth = (viewWidth - totoalGap)/CGFloat(titleArray.count)
            
            let btnHeight = self.frame.height > 0 ? self.frame.height : 30
            
            for (index, str) in titleArray.enumerated() {
                
                let btn = UIButton(type: .custom)
                btn.layer.cornerRadius = cornerRadius
                btn.titleLabel?.font = UIFont(_DINProBoldTypeSize: 13)
                btn.clipsToBounds = true
                addSubview(btn)
                btn.tag = 1000 + index
                btn.layer.borderColor = borderColor.cgColor
                btn.layer.borderWidth = borderWidth
                
                btn.setTitle(str, for: .normal)
                btn.setTitleColor(titleColor, for: .normal)
                btn.setTitleColor(COLOR_MainThemeColor, for: .selected)
                btn.addTarget(self, action: #selector(clickItem(sender:)), for: .touchUpInside)
                btn.frame = CGRect(x: CGFloat(index)*(btnWidth + gap), y: 0, width: btnWidth, height: btnHeight)
                
                btn.snp_makeConstraints { (make) in
                    make.left.equalTo(CGFloat(index)*(btnWidth + gap))
                    make.top.equalToSuperview()
                    make.width.equalTo(btnWidth)
                    make.height.equalTo(btnHeight)
                }
                
                /**
                if index == 0 {
                    selectedBtn = btn
                    selectedBtn?.isSelected = true
                    selectedBtn?.layer.borderColor = COLOR_TabBarTintColor.cgColor
                }
                 */
            }
        }
    }
    
    @objc func clickItem(sender: UIButton) {
        
        
        if self.selectedBtn == sender && self.selectedBtn?.isSelected == true {
            return
        }
        
        selectedBtn?.isSelected = false
        sender.isSelected = true
        
        //selectedBtn?.layer.borderColor = borderColor.cgColor
        //sender.layer.borderColor = COLOR_TabBarTintColor.cgColor
        
        selectedBtn = sender
        
        let index = sender.tag - 1000
        
        if let clickItemBlock = self.clickItemBlock {
            
            clickItemBlock(index, self.titleArray?[index] ?? "")
        }
    }
    
}
