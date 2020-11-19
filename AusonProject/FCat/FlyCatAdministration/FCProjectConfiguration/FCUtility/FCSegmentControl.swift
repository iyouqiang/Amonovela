//
//  FCSegmentControl.swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/12.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCSegmentControl: UIView {
    
    typealias selectedBlock = (_ Index : Int) -> Void
    
    var items : NSMutableArray!
    var underLine : UIView!
    var selectItemBlock : selectedBlock?
    var itemSpace: Double!
    var isMarket:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.itemSpace = 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func setSelected(_ index: Int) {
        
        if index < self.items.count {
            
            let selectedBtn = self.items[index] as? UIButton
            
            if isMarket {
                
                selectedBtn?.titleLabel?.font = UIFont.systemFont(ofSize: 22)
            }

            
            if self.underLine != nil {
                
                self.underLine.snp.remakeConstraints { (make) in
                    make.bottom.equalToSuperview()
                    make.height.equalTo(2)
                    make.left.equalTo((selectedBtn?.titleLabel?.snp.left)!)
                    make.right.equalTo((selectedBtn?.titleLabel?.snp.right)!)
                }
                
            }
            
            for i in 0..<items.count {
                
                let button = self.items[i] as? UIButton
                button?.isSelected = index == i ? true : false
                
                if isMarket && index != i {
                    
                    button?.titleLabel?.font = UIFont.systemFont(ofSize: 15)
                }
            }
        }
    }
    
    func setTitles(titles: [String], fontSize: CGFloat, normalColor: UIColor, tintColor: UIColor, showUnderLine: Bool) {
        
        self.items = NSMutableArray.init()
        
        var lastView : UIView!
        for i in 0..<titles.count {
            
            let button: UIButton = UIButton.init(type: .custom)
            button.setTitle(titles[i], for: .normal)
            button.titleLabel?.font = UIFont.init(_customTypeSize: fontSize)
            button.setTitleColor(normalColor, for: .normal)
            button.setTitleColor(tintColor, for: .selected)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(itemClicked(sender:)), for: .touchUpInside)
            
            self.addSubview(button)
            self.items.add(button)
                    
            button.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()
                
                if i == 0 {
                    make.left.equalToSuperview()
                    
                }else{
                    make.left.equalTo(lastView.snp.right).offset(self.itemSpace)
                }
                
                if i == titles.count - 1 {
                    make.right.lessThanOrEqualToSuperview()
                }
                
                //                if (lastView != nil) {
                //
                //                    make.width.equalTo(lastView)
                //                }
            }
            
            lastView = button
        }
        
        if showUnderLine {
            
            self.underLine = fc_UIViewInit(bgColor: tintColor)
            if isMarket {
                self.underLine.backgroundColor = COLOR_ThemeBtnEndColor
            }
            self.addSubview(self.underLine)
            
            let firstBtn = self.items[0] as? UIButton
            
            self.underLine.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(2)
                make.left.equalTo((firstBtn?.titleLabel?.snp.left)!)
                make.right.equalTo((firstBtn?.titleLabel?.snp.right)!)
            }
            
        }
        
        //默认选中
        setSelected(0)
    }
    
    
    func setFixedWidth(titles: [String], fontSize: CGFloat, normalColor: UIColor, tintColor: UIColor, showUnderLine: Bool) {
        
        self.items = NSMutableArray.init()
        for i in 0..<titles.count {
            
            let button: UIButton = UIButton.init(type: .custom)
            button.setTitle(titles[i], for: .normal)
            button.titleLabel?.font = UIFont.init(_customTypeSize: fontSize)
            button.setTitleColor(normalColor, for: .normal)
            button.setTitleColor(tintColor, for: .selected)
            button.tag = 1000 + i
            button.addTarget(self, action: #selector(itemClicked(sender:)), for: .touchUpInside)
            
            self.addSubview(button)
            self.items.add(button)
            
            
            button.snp.makeConstraints { (make) in
                make.top.equalToSuperview()
                make.bottom.equalToSuperview()

                if i == 0 {
                    make.left.equalToSuperview()

                }else if (titles.count > 2 ){
                    make.centerX.equalToSuperview().multipliedBy(Float(i)/Float(titles.count - 2))
                } else if i == titles.count - 1 {
                     make.right.equalToSuperview()
                }
            }
        }
        
        if showUnderLine {
            
            self.underLine = fc_UIViewInit(bgColor: tintColor)
            self.addSubview(self.underLine)
            
            let firstBtn = self.items[0] as? UIButton
            
            self.underLine.snp.makeConstraints { (make) in
                make.bottom.equalToSuperview()
                make.height.equalTo(2)
                make.left.equalTo((firstBtn?.titleLabel?.snp.left)!)
                make.right.equalTo((firstBtn?.titleLabel?.snp.right)!)
            }
            
        }
        
        //默认选中
        setSelected(0)
    }
    
    
    
    
    @objc private func itemClicked(sender: UIButton) {
        
        setSelected(sender.tag - 1000)
        if self.selectItemBlock != nil {
            
            self.selectItemBlock!(sender.tag - 1000)
        }
    }
    
    func didSelectedItem(_ selectBlock: @escaping selectedBlock) {
        
        self.selectItemBlock = selectBlock
    }
    
    
}
