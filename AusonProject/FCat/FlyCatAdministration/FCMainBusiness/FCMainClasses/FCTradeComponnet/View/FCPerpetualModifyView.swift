//
//  FCPerpetualModifyView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/9/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class FCPerpetualModifyView: UIView {
    
    /*
       // Only override draw() if you perform custom drawing.
       // An empty implementation adversely affects performance during animation.
       override func draw(_ rect: CGRect) {
           // Drawing code
       }
       */
       
//       var symbolTitleL: UILabel!
//       var leverageL: UILabel!
    var titleLab: UILabel!
       var limitPriceBtn: UIButton!
       var marketPriceBtn: UIButton!
       var selectedView: UIView!
       var bottomLine: UIView!
       var limitInputView: FCContractInputView!
       var numberInputView: FCContractInputView!
       var persentArray: [UIButton]?
       var availableVolumeL: UILabel!
       var limitConfirBtn: FCThemeButton!
       var marketConfirBtn: UIButton!
       var closeBtn: UIButton!
       var ratioView: FCBtnSelectedView!
       let disposeBag = DisposeBag()
       var availableNum: Float = 0.0
       var tradeType = "Limit"
       var percentageStr = "0.1"
       
       var positionModel: FCPositionInfoModel? {
           
           didSet {
               
               guard let positionModel = positionModel else {
                   return
               }
               
               
               /// 可平量
               let contractSizeFloat = ((positionModel.contractSize ?? "") as NSString).floatValue
               let availableVolumeFloat = ((positionModel.availableVolume ?? "") as NSString).floatValue
               //let volumeFloat = ((positionModel.volume ?? "") as NSString).floatValue
               
               /// 持仓均价
               let symbolArray = positionModel.symbol?.split(separator: "-")
               //let symbolStr = symbolArray?.last ?? ""
               let sheetStr = symbolArray?.first ?? ""

               if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {

                   self.availableNum = contractSizeFloat * availableVolumeFloat
                   self.availableVolumeL.text = ("\(contractSizeFloat * availableVolumeFloat) ") + sheetStr
               }else {
                   
                   self.availableNum = ((positionModel.availableVolume ?? "" ) as NSString).floatValue
                   self.availableVolumeL.text = (positionModel.availableVolume ?? "") + " 张"
               }
               
           }
       }
       
       var closeAlertBlock: (() -> Void)?

       override init(frame: CGRect) {
           super.init(frame: frame)
           // 平仓界面
           self.backgroundColor = .white
           self.setupView()
           self.layoutPositionSubView()
           self.loadClickEvnet()
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       func setupView() {

//        titleLab = fc_labelInit(text: "修改", textColor: COLOR_BGColor, textFont: 16, bgColor: .clear)
//        addSubview(titleLab)
        
             titleLab = fc_labelInit(text: "修改", textColor: COLOR_BGColor, textFont: UIFont.boldSystemFont(ofSize: 16), bgColor: .clear)
          addSubview(titleLab)
        
           //trade_close
           closeBtn = fc_buttonInit(imgName: "trade_close", title: "", fontSize: 16, titleColor: .clear, bgColor: .clear)
           addSubview(closeBtn)
           
           /// 限价平仓按钮
           limitPriceBtn = fc_buttonInit(imgName: "", title: "限价平仓", fontSize: 16, titleColor: .clear, bgColor: .clear)
           addSubview(limitPriceBtn)
           
           /// 市价平仓按钮
           marketPriceBtn = fc_buttonInit(imgName: "", title: "市价平仓", fontSize: 16, titleColor: COLOR_RichBtnTitleColor, bgColor: .clear)
           addSubview(marketPriceBtn)
           
           /// 选择按钮
           selectedView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 2))
           selectedView.backgroundColor = COLOR_TabBarTintColor
           addSubview(selectedView)
           
           bottomLine = UIView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 0.8))
           bottomLine.backgroundColor = COLOR_HexColorAlpha(0xdadadd, alpha: 0.2)
           addSubview(bottomLine)
           
           
           /// 限价输入框
           limitInputView = FCContractInputView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
           limitInputView.layer.cornerRadius = 8
           limitInputView.clipsToBounds = true
           limitInputView.preTitle = "限价"
           addSubview(limitInputView)
           
           /// 数量输入框
           numberInputView = FCContractInputView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
           numberInputView.preTitle = "数量"
           numberInputView.suffixTitle = FCTradeSettingconfig.sharedInstance.tradingUnitStr
           numberInputView.layer.cornerRadius = 8
           numberInputView.clipsToBounds = true
           addSubview(numberInputView)
           
           /// 比例按钮
           ratioView = FCBtnSelectedView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH - 30, height: 30))
           ratioView.layer.cornerRadius = 15
           ratioView.clipsToBounds = true
           ratioView.titleArray = ["10%", "20%", "50%", "100%"]
           //ratioView.backgroundColor = COLOR_TabBarTintColor
           addSubview(ratioView)
           ratioView.clickItemBlock = {
               [weak self] (index, str) in
                   
                   if index == 0 {
     
                       self?.percentageStr = "0.1"
                       self?.numberInputView.textField.text = "\((self?.availableNum ?? 0.0) * 0.1)"
                       
                   }else if (index == 1) {
                       self?.percentageStr = "0.2"
                       self?.numberInputView.textField.text = "\((self?.availableNum ?? 0.0) * 0.2)"
                   }else if (index == 2) {
                       self?.percentageStr = "0.5"
                       self?.numberInputView.textField.text = "\((self?.availableNum ?? 0.0) * 0.5)"
                   }else {
                       
                       self?.percentageStr = "1.0"
                       self?.numberInputView.textField.text = "\((self?.availableNum ?? 0.0) * 1)"
                   }
           }
           
           
           /// 可平量
           availableVolumeL = fc_labelInit(text: "可平量 10BTC", textColor: COLOR_RichBtnTitleColor, textFont: UIFont.systemFont(ofSize: 12), bgColor: .clear)
           addSubview(availableVolumeL)
           
           /// 市价平仓 平仓去人按钮
           marketConfirBtn = fc_buttonInit(imgName: "", title: "市价平仓", fontSize: 16, titleColor: COLOR_TabBarTintColor, bgColor: .clear)
           marketConfirBtn.layer.cornerRadius = 25
           marketConfirBtn.clipsToBounds = true
           marketConfirBtn.layer.borderWidth = 1
           marketConfirBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
           addSubview(marketConfirBtn)
           
           
           /// 平仓
           limitConfirBtn = FCThemeButton(title: "平仓", titleColor: COLOR_TabBarBgColor, fontSize: 16, frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 50)/2.0, height: 50), cornerRadius: 25)
           addSubview(limitConfirBtn)
       }
       
       func layoutPositionSubView()
       {
               /// 界面布局

        titleLab.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(28)
        }
        
        
               closeBtn.snp.makeConstraints { (make) in
                   
                   make.right.equalTo(-15)
                   make.centerY.equalTo(titleLab.snp_top)
                   make.height.width.equalTo(30)
               }
               
               ///
               let btnWidth = limitPriceBtn.titleLabel?.labelWidthMaxHeight(30) ?? 0
               
               marketPriceBtn.snp.makeConstraints { (make) in
                   make.left.equalTo(15)
                   make.top.equalTo(titleLab.snp_bottom).offset(32)
                   make.width.equalTo(btnWidth)
                   make.height.equalTo(30)
               }
               
               limitPriceBtn.snp.makeConstraints { (make) in
                   make.left.equalTo(marketPriceBtn.snp_right).offset(30)
                   make.width.equalTo(btnWidth)
                   make.height.equalTo(30)
                   make.top.equalTo(marketPriceBtn.snp_top)
               }
               
               limitPriceBtn.setTitleColor(COLOR_TabBarTintColor, for: .normal)
               
               bottomLine.snp.makeConstraints { (make) in
                   make.left.equalTo(15)
                   make.right.equalTo(-15)
                   make.height.equalTo(1)
                   make.top.equalTo(limitPriceBtn.snp_bottom)
               }
               
               selectedView.snp.makeConstraints { (make) in
                   
                   make.left.equalTo(marketPriceBtn.snp_right).offset(30)
                   make.top.equalTo(bottomLine.snp_top).offset(-1.2)
                   make.width.equalTo(limitPriceBtn.snp.width)
                   make.height.equalTo(2)
               }
           
               
               ///
               limitInputView.snp.makeConstraints { (make) in
                   
                   make.left.equalTo(15)
                   make.top.equalTo(bottomLine.snp_bottom).offset(20)
                   make.right.equalTo(-15)
                   make.height.equalTo(50)
               }
               
               numberInputView.snp.makeConstraints { (make) in
                   
                   make.left.equalTo(15)
                   make.top.equalTo(bottomLine.snp_bottom).offset(90)
                   make.right.equalTo(-15)
                   make.height.equalTo(50)
               }
               
               ratioView.snp.makeConstraints { (make) in
                   
                   make.top.equalTo(numberInputView.snp_bottom).offset(10)
                   make.left.equalTo(15)
                   make.right.equalTo(-15)
                   make.height.equalTo(30)
               }
               
               
               availableVolumeL.snp.makeConstraints { (make) in
                   
                   make.left.equalTo(15)
                   make.top.equalTo(ratioView.snp_bottom).offset(10)
                   make.right.equalTo(-15)
                   make.height.equalTo(30)
               }
               
               ///
               marketConfirBtn.snp.makeConstraints { (make) in
                   make.top.equalTo(availableVolumeL.snp_bottom).offset(15)
                   make.left.equalTo(15)
                   make.height.equalTo(50)
                   make.width.equalTo(limitConfirBtn.snp_width)
               }
               
               limitConfirBtn.snp.makeConstraints { (make) in
                   make.top.equalTo(marketConfirBtn.snp_top)
                   make.left.equalTo(marketConfirBtn.snp_right).offset(20)
                   make.right.equalTo(-15)
                   make.height.equalTo(50)
                   make.width.equalTo(marketConfirBtn.snp_width)
               }
       }
       
       func loadClickEvnet() {
           
           marketPriceBtn.rx.tap.subscribe { [weak self] (event) in
           
               print("市价平仓")
               self?.changeBtnState(isLimit: false)
           }.disposed(by: self.disposeBag)
           
           limitPriceBtn.rx.tap.subscribe {[weak self] (event) in
                      
               print("限价平仓")
               self?.changeBtnState(isLimit: true)
           }.disposed(by: self.disposeBag)
           
           marketConfirBtn.rx.tap.subscribe { (event) in
              
               self.confirmOrderEvent(isMarket: true)
               
           }.disposed(by: self.disposeBag)
           
           limitConfirBtn.rx.tap.subscribe { (event) in
                      
               self.confirmOrderEvent(isMarket: false)
               
           }.disposed(by: self.disposeBag)
           
           closeBtn.rx.tap.subscribe { (event) in

               print("关闭界面")
               if let closeAlertBlock = self.closeAlertBlock {
                   
                   closeAlertBlock()
               }
               
           }.disposed(by: self.disposeBag)
       }
       
       func confirmOrderEvent(isMarket: Bool) {
           
           /// 合约下单单位
           var tradingUnit = "CONT"
           /// 下单量，计算方式
           var volumeType = "Cont"
           /// 买卖方向
           var side = "Ask"
           /// 平仓
           let action = "Close"
           /// 价格和数量
           var EntrustVolume = self.numberInputView.textField.text ?? "0.00"
           let EntrustPrice = self.limitInputView.textField.text ?? "0.00"
           
           if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {
                          
               tradingUnit = FCTradeSettingconfig.sharedInstance.tradingUnitStr
           }
                      
           if self.positionModel?.positionSide == "Long" {
               
               side = "Ask"
           }else {
               
               side = "Bid"
           }
           
           if self.tradeType == "Market" {
               
               /// 市价平仓选择 百分比
               volumeType = "Percentage"
               EntrustVolume = self.percentageStr
               
           }else {
               
               /// 市价平仓需要 几个和数量
               if self.limitInputView.textField.text?.count == 0 {
                   PCAlertManager.showAlertMessage("请输入平仓数量")
                   return
               }
           }
           
           if self.numberInputView.textField.text?.count == 0 {
               PCAlertManager.showAlertMessage("请输入平仓价格")
               return
           }
                      
           let positionApi = FCApi_trade_order_place(symbol: self.positionModel?.symbol ?? "", tradingUnit: tradingUnit, entrustVolume: EntrustVolume, entrustPrice: EntrustPrice, side: side, action: action, tradeType: self.tradeType, volumeType: volumeType)
           
           /// 平仓
           positionApi.startWithCompletionBlock(success: { [weak self] (response) in
               
               let responseData = response.responseObject as?  [String : AnyObject]
               if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                   
                   if let closeAlertBlock = self?.closeAlertBlock {
                       
                       closeAlertBlock()
                   }
                   
               }else {
                   
                   let errMsg = responseData?["err"]?["msg"] as? String
                   PCAlertManager.showAlertMessage(errMsg)
               }
               
           }) { (response) in
               
           }
       }
       
       func changeBtnState(isLimit: Bool) {
           
           if isLimit {
               
               self.tradeType = "Limit"
               self.marketPriceBtn.setTitleColor(COLOR_RichBtnTitleColor, for: .normal)
               self.limitPriceBtn.setTitleColor(COLOR_TabBarTintColor, for: .normal)
               
               UIView.animate(withDuration: 0.3) {
                 
                   self.frame = CGRect(x: 0, y: kSCREENHEIGHT - self.frame.height + 10, width: kSCREENWIDTH, height: self.frame.height)
                   
                   self.numberInputView.snp.remakeConstraints { (make) in
                       
                       make.left.equalTo(15)
                       make.top.equalTo(self.bottomLine.snp_bottom).offset(90)
                       make.right.equalTo(-15)
                       make.height.equalTo(50)
                   }
                   
                   self.layoutIfNeeded()
               }
               
               UIView.animate(withDuration: 0.3) {
                 
                   self.numberInputView.isHidden = false
                   self.selectedView.snp.remakeConstraints { (make) in
                                  
                       make.left.equalTo(self.marketPriceBtn.snp_right).offset(30)
                       make.top.equalTo(self.bottomLine.snp_top).offset(-1.2)
                       make.width.equalTo(self.limitPriceBtn.snp.width)
                       make.height.equalTo(2)
                   }
                   self.layoutIfNeeded()
               }
               
           }else {

               self.tradeType = "Market"
               self.marketPriceBtn.setTitleColor(COLOR_TabBarTintColor, for: .normal)
               self.limitPriceBtn.setTitleColor(COLOR_RichBtnTitleColor, for: .normal)
               
               UIView.animate(withDuration: 0.3) {
                 
                   self.frame = CGRect(x: 0, y: kSCREENHEIGHT - self.frame.height + 80, width: kSCREENWIDTH, height: self.frame.height)
                   
                   self.selectedView.snp.remakeConstraints { (make) in
                                          
                       make.left.equalTo(15)
                       make.top.equalTo(self.bottomLine.snp_top).offset(-1.2)
                       make.width.equalTo(self.limitPriceBtn.snp.width)
                       make.height.equalTo(2)
                   }
                   self.layoutIfNeeded()
               }
               
               UIView.animate(withDuration: 0.3) {
                 
                   self.numberInputView.isHidden = true
                   self.numberInputView.snp_remakeConstraints { (make) in
                       
                       make.left.equalTo(15)
                       make.top.equalTo(self.bottomLine.snp_bottom).offset(20)
                       make.right.equalTo(-15)
                       make.height.equalTo(50)
                   }
                   self.layoutIfNeeded()
               }
               
           }
       }

}
