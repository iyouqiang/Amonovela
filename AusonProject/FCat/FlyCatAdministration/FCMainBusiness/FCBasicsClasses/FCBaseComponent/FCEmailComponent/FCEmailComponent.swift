//
//  FCEmailComponent.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa

class FCEmailComponent: FCTextFieldComponent {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    let disposeBag = DisposeBag()
    var dropDown: DropDown?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(placeholder: String? = "", holderColor: UIColor? = COLOR_MinorTextColor, textColor: UIColor? = COLOR_White, fontSize: CGFloat? = 15, leftImg: String?, keyboardType: UIKeyboardType? = .emailAddress) {
        super.init(placeholder: placeholder!, leftImg: leftImg!)
        
        //设置正则
        //self.regularExpression =  "([a-zA-Z0-9_\\.-]{0,30}+)@{0,1}([\\da-z\\.-]{0,10}+)\\.{0,1}([a-z\\.]{0,6})$"
        
        //设置
        //self.setupDropDrown()
    }
    
    private func setupDropDrown () {
        
        self.dropDown = DropDown()
        //        self.dropDown.dataSource = getDropDownDataSource()
        self.dropDown?.anchorView = self
        self.dropDown?.bottomOffset = CGPoint(x: 0, y: 40)
        self.dropDown?.textFont = UIFont.init(_customTypeSize: 12)
        self.dropDown?.textColor = COLOR_PrimeTextColor
        self.dropDown?.cellHeight = 40
        self.dropDown?.backgroundColor = COLOR_HexColor(0x232529)
        self.dropDown?.selectionBackgroundColor = COLOR_LineColor
        self.dropDown?.separatorColor = .clear
        //self.dropDown?.separatorInsetLeft = true //分割线左对齐
        self.updateDropDownDataSource()
        
        self.textFiled.rx.text.distinctUntilChanged().subscribe { [unowned self] (tex) in
            self.updateDropDownDataSource()
        }.disposed(by: disposeBag)
        
        self.dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.textFiled.text = item
        }
    }
    
    private func updateDropDownDataSource () {
        
        let array = self.textFiled.text?.components(separatedBy: "@")
        if array?.count ?? 0 > 0 && array?[0].count ?? 0 > 6 {  //大于6个字符才线束辅助视图
            
            let prefix = array?[0] ?? ""
            let dataSource: [String] = [ prefix + "@163.com",
                                         prefix + "@126.com",
                                         prefix + "@qq.com",
                                         prefix + "@gmail.com"
            ]
            self.dropDown?.dataSource = dataSource
            if DropDown.VisibleDropDown == nil {
                self.dropDown?.show()
            }
        } else {
            self.dropDown?.hide()
        }
    }
}
