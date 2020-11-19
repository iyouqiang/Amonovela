
//
//  FCSortComponent.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/29.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum FCMarketSortType: String {
    case Default = ""
    case Name = "Name"
    case Price = "Price"
    case Change = "Change"
}

enum FCMarketOrderType: String {
    case Default = ""
    case Desc = "Desc"
    case Asc = "Asc"
}


class FCSortComponent: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    let disposeBag = DisposeBag()
    var nameBtn: UIButton!
    var priceBtn: UIButton!
    var changeBtn: UIButton!
    var sortType: FCMarketSortType = .Default
    var orderType: FCMarketOrderType = .Default
     typealias OrderBlock = (_ sortType: FCMarketSortType, _ orderType: FCMarketOrderType) -> Void
    var orderCallback: OrderBlock?
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = COLOR_BGColor
        self.loadSubviews()
        self.handleBtnActions()
    }
    
    private func loadSubviews () {
        self.nameBtn = fc_buttonInit(imgName: "sortNone", title: "名称", fontSize: 13, titleColor: COLOR_MinorTextColor, bgColor: COLOR_Clear)
        self.priceBtn = fc_buttonInit(imgName: "sortNone", title: "最新价", fontSize: 13, titleColor: COLOR_MinorTextColor, bgColor: COLOR_Clear)
        self.changeBtn = fc_buttonInit(imgName: "sortNone", title: "涨跌幅", fontSize: 13, titleColor: COLOR_MinorTextColor, bgColor: COLOR_Clear)
        
        self.nameBtn.setTitleAndImageInset(insetType: .FCBtnInsetTypeImgRight, imgLabInset: 5, imgWidth: 10)
        self.priceBtn.setTitleAndImageInset(insetType: .FCBtnInsetTypeImgRight, imgLabInset: 5, imgWidth: 10)
        self.changeBtn.setTitleAndImageInset(insetType: .FCBtnInsetTypeImgRight, imgLabInset: 5, imgWidth: 10)
        
        self.addSubview(self.nameBtn)
        self.addSubview(self.priceBtn)
        self.addSubview(self.changeBtn)
        
        self.nameBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        self.priceBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
        
        self.changeBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-kMarginScreenLR)
            make.height.equalToSuperview()
            make.width.equalTo(70)
        }
    }
    
    private func handleBtnActions () {
        self.nameBtn.rx.tap.subscribe { (event) in
            if (self.sortType == .Name && self.orderType == .Desc) {
                self.configBtnsStyle(buttons: [self.nameBtn, self.priceBtn, self.changeBtn], allDefault: true, orderType: .Default)
            } else if (self.sortType == .Name && self.orderType == .Asc) {
                self.configBtnsStyle(buttons: [self.nameBtn, self.priceBtn, self.changeBtn], allDefault: false, orderType: .Desc, sortType: .Name)
            } else {
                self.configBtnsStyle(buttons: [self.nameBtn, self.priceBtn, self.changeBtn], allDefault: false, orderType: .Asc, sortType: .Name)
            }
            
            
        }.disposed(by: self.disposeBag)
        
        self.priceBtn.rx.tap.subscribe {(event) in
            if (self.sortType == .Price && self.orderType == .Desc) {
                self.configBtnsStyle(buttons: [self.nameBtn, self.priceBtn, self.changeBtn], allDefault: true, orderType: .Default)
            } else if (self.sortType == .Price && self.orderType == .Asc) {
                self.configBtnsStyle(buttons: [self.priceBtn, self.nameBtn, self.changeBtn], allDefault: false, orderType: .Desc, sortType: .Price)
            } else {
                self.configBtnsStyle(buttons: [self.priceBtn, self.nameBtn, self.changeBtn], allDefault: false, orderType: .Asc, sortType: .Price)
            }
        }.disposed(by: self.disposeBag)
        
        
        self.changeBtn.rx.tap.subscribe {(event) in
            if (self.sortType == .Change && self.orderType == .Desc) {
                self.configBtnsStyle(buttons: [self.nameBtn, self.priceBtn, self.changeBtn], allDefault: true, orderType: .Default)
            } else if (self.sortType == .Change && self.orderType == .Asc) {
                self.configBtnsStyle(buttons: [self.changeBtn, self.priceBtn, self.nameBtn], allDefault: false, orderType: .Desc, sortType: .Change)
            } else {
                self.configBtnsStyle(buttons: [self.changeBtn, self.priceBtn, self.nameBtn], allDefault: false, orderType: .Asc, sortType: .Change)
            }
        }.disposed(by: self.disposeBag)
    }
    
    func orderBtnClick (callback: @escaping OrderBlock) {
        self.orderCallback = callback
    }
    
    
    private func configBtnsStyle(buttons: [UIButton],allDefault: Bool, orderType: FCMarketOrderType, sortType: FCMarketSortType? = .Default) {
        if (allDefault) {
            self.configDefaultStyle(button: buttons[0])
            self.configDefaultStyle(button: buttons[1])
            self.configDefaultStyle(button: buttons[2])
    
        } else if(orderType == .Asc){
            self.configAscStyle(button: buttons[0])
            self.configDefaultStyle(button: buttons[1])
            self.configDefaultStyle(button: buttons[2])
        } else {
            self.configDescStyle(button: buttons[0])
            self.configDefaultStyle(button: buttons[1])
            self.configDefaultStyle(button: buttons[2])
        }
        
        self.sortType = sortType ?? .Default
        self.orderType = orderType
        self.orderCallback?(sortType ?? .Default, orderType)
        
    }
    
    private func configDefaultStyle(button: UIButton) {
        button.setTitleColor(COLOR_MinorTextColor, for: .normal)
        button.setImage(UIImage(named: "sortNone"), for: .normal)
    }
    
    private func configAscStyle(button: UIButton) {
        button.setTitleColor(COLOR_White, for: .normal)
        button.setImage(UIImage(named: "sortAsc"), for: .normal)
    }
    
    private func configDescStyle(button: UIButton) {
        button.setTitleColor(COLOR_White, for: .normal)
        button.setImage(UIImage(named: "sortDesc"), for: .normal)
    }
    

}
