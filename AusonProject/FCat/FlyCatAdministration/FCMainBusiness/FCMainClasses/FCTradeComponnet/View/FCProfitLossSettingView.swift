//
//  FCProfitLossSettingView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FCProfitLossSettingView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var symbolTitleL: UILabel!
    var leverageL: UILabel!
    var persentArray: [UIButton]?
    var availableVolumeL: UILabel!
    var triggerConfirBtn: FCThemeButton!
    var closeProfitLossBtn: UIButton!
    var closeBtn: UIButton!
    let disposeBag = DisposeBag()
    var availableNum: Float = 0.0
    var tradeType = "Limit"
    var percentageStr = "0.1"
    
    ///止盈 止损输入框
    var takeProfitView: FCContractInputView!
    var stopLossView: FCContractInputView!
    var numberInputView: FCContractInputView!
    var ratioView: FCBtnSelectedView!
    
    var triggerModel: FCTriggerModel? {
        didSet {
            
            guard let triggerModel = triggerModel else {
                return
            }
            
            self.symbolTitleL.text = triggerModel.symbol
            
            self.stopLossView.textField.text = triggerModel.stopLossPrice ?? ""
            self.takeProfitView.textField.text = triggerModel.takeProfitPrice ?? ""
            self.numberInputView.textField.text = triggerModel.entrustVolume ?? ""

            /// 多仓 空仓
            let positionSide = triggerModel.positionSide ?? ""
            let leverage = triggerModel.leverage ?? ""
            //Long表示多仓，Short表示空仓
            if positionSide == "Long" {
                self.leverageL.text = "多头 \(leverage)"
                self.leverageL.textColor = COLOR_RiseColor
            }else if (positionSide == "Short") {
                self.leverageL.text = "空头 \(leverage)"
                self.leverageL.textColor = COLOR_FailColor
            }else {
                self.leverageL.text = ""
            }
            
            /// 可平量
            
            /// 持仓均价
            // let symbolArray = triggerModel.symbol?.split(separator: "-")
            //let symbolStr = symbolArray?.last ?? ""
            var sheetStr = triggerModel.contractAsset ?? ""
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {

                sheetStr = "张"
            }
            
            self.availableNum = ((triggerModel.positionAvailableVolume ?? "" ) as NSString).floatValue
            self.availableVolumeL.text = ("可平量 \(triggerModel.positionAvailableVolume ?? "") ") + sheetStr
        }
    }
    
    var positionModel: FCPositionInfoModel? {
        
        didSet {
            
            guard let positionModel = positionModel else {
                return
            }
            
            self.symbolTitleL.text = positionModel.symbolName
            
            /// 多仓 空仓
            let positionSide = positionModel.positionSide ?? ""
            let leverage = positionModel.leverage ?? ""
            //Long表示多仓，Short表示空仓
            if positionSide == "Long" {
                self.leverageL.text = "多头 \(leverage)"
                self.leverageL.textColor = COLOR_RiseColor
            }else if (positionSide == "Short") {
                self.leverageL.text = "空头 \(leverage)"
                self.leverageL.textColor = COLOR_FailColor
            }else {
                self.leverageL.text = ""
            }
            
            /// 可平量
            let contractSizeFloat = ((positionModel.contractSize ?? "") as NSString).floatValue
            let availableVolumeFloat = ((positionModel.availableVolume ?? "") as NSString).floatValue
            
            //let volumeFloat = ((positionModel.volume ?? "") as NSString).floatValue
            
            /// 持仓均价
            let symbolArray = positionModel.symbol?.split(separator: "-")
            //let symbolStr = symbolArray?.last ?? ""
            let sheetStr = symbolArray?.first ?? ""
            self.availableNum = ((positionModel.availableVolume ?? "" ) as NSString).floatValue
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {

                //self.availableNum = contractSizeFloat * availableVolumeFloat
                
                //self.availableVolumeL.text = ("可平量 \(contractSizeFloat * availableVolumeFloat) ") + sheetStr
                
                self.availableVolumeL.text = ("可平量 \(availableVolumeFloat) ") + sheetStr
                
            }else {
                
                self.availableVolumeL.text = "可平量 \((positionModel.availableVolume ?? ""))" + " 张"
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
         
        /// 第一栏 平仓永续 多头
        symbolTitleL = fc_labelInit(text: "平仓BTCUSDT永续", textColor: COLOR_RichBtnTitleColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        addSubview(symbolTitleL)
        
        leverageL = fc_labelInit(text: "多头100.00X", textColor: COLOR_RiseColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        addSubview(leverageL)
        
        //trade_close
        closeBtn = fc_buttonInit(imgName: "trade_close", title: "", fontSize: 16, titleColor: .clear, bgColor: .clear)
        addSubview(closeBtn)
        
        /// 止盈止损
        /**
        takeProfitView = FCAddSubtractView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
        takeProfitView?.textField.placeholder = "止盈价"
        takeProfitView?.layer.cornerRadius = 5
        takeProfitView?.clipsToBounds = true
        takeProfitView?.layer.borderWidth = 0.5
        takeProfitView?.layer.borderColor = COLOR_InputText.cgColor
        takeProfitView?.clipsToBounds = true
        addSubview(takeProfitView!)
         */
        takeProfitView = FCContractInputView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
        takeProfitView.preTitle = "止盈价"
        takeProfitView.textField.textAlignment = .left
        takeProfitView.layer.cornerRadius = 8
        takeProfitView.clipsToBounds = true
        addSubview(takeProfitView)

        /**
        stopLossView = FCAddSubtractView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
        stopLossView.textField.placeholder = "止损价"
        stopLossView.layer.cornerRadius = 5
        stopLossView.clipsToBounds = true
        stopLossView.layer.borderWidth = 0.5
        stopLossView.layer.borderColor = COLOR_InputText.cgColor
        stopLossView.clipsToBounds = true
        addSubview(stopLossView!)
         */
        stopLossView = FCContractInputView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
        stopLossView.preTitle = "止损价"
        stopLossView.textField.textAlignment = .left
        stopLossView.layer.cornerRadius = 8
        stopLossView.clipsToBounds = true
        addSubview(stopLossView)
        
        /// 数量输入框
        numberInputView = FCContractInputView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
        numberInputView.preTitle = "数量"
        numberInputView.textField.textAlignment = .left
        //numberInputView.suffixTitle = FCTradeSettingconfig.sharedInstance.tradingUnitStr
        numberInputView.layer.cornerRadius = 8
        numberInputView.clipsToBounds = true
        addSubview(numberInputView)
        /**
        numberInputView = FCContractInputView(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH - 30, height: 44))
        numberInputView.textField.textAlignment = .left
        numberInputView.textField.placeholder = "数量"
        numberInputView.layer.borderWidth = 0.5
        numberInputView.layer.borderColor = COLOR_InputText.cgColor
        numberInputView.suffixTitle =  FCTradeSettingconfig.sharedInstance.tradingUnitStr
        numberInputView.backgroundColor = .clear
        numberInputView.layer.cornerRadius = 5
        numberInputView.clipsToBounds = true
        addSubview(numberInputView)
         */
        
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
        closeProfitLossBtn = fc_buttonInit(imgName: "", title: "取消", fontSize: 16, titleColor: COLOR_TabBarTintColor, bgColor: .clear)
        closeProfitLossBtn.layer.cornerRadius = 25
        closeProfitLossBtn.clipsToBounds = true
        closeProfitLossBtn.layer.borderWidth = 1
        closeProfitLossBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        addSubview(closeProfitLossBtn)
        
        /// 平仓
        triggerConfirBtn = FCThemeButton(title: "确认设置", titleColor: COLOR_TabBarBgColor, fontSize: 16, frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 50)/2.0, height: 50), cornerRadius: 25)
        addSubview(triggerConfirBtn)
    }
    
    func layoutPositionSubView()
    {
            /// 界面布局
            //let symbolWidth = symbolTitleL.labelWidthMaxHeight(30)
            symbolTitleL.snp.makeConstraints { (make) in
                
                make.left.equalTo(15)
                make.top.equalTo(20)
                make.height.equalTo(30)
            }
            
            leverageL.snp.makeConstraints { (make) in
                make.left.equalTo(symbolTitleL.snp_right).offset(15)
                make.bottom.equalTo(symbolTitleL.snp_bottom)
                make.right.equalTo(closeBtn.snp_left)
                make.height.equalTo(30)
            }
            
            closeBtn.snp.makeConstraints { (make) in
                
                make.right.equalTo(-15)
                make.centerY.equalTo(leverageL.snp_centerY)
                make.height.width.equalTo(30)
            }
        
            ///
            takeProfitView!.snp.makeConstraints { (make) in
                
                make.left.equalTo(15)
                make.top.equalTo(symbolTitleL.snp_bottom).offset(20)
                make.right.equalTo(-15)
                make.height.equalTo(50)
            }
            
            stopLossView.snp.makeConstraints { (make) in
                
                make.left.equalTo(15)
                make.top.equalTo(takeProfitView.snp_bottom).offset(20)
                make.right.equalTo(-15)
                make.height.equalTo(50)
            }
        
            numberInputView.snp.makeConstraints { (make) in
            
                make.left.equalTo(15)
                make.top.equalTo(stopLossView.snp_bottom).offset(20)
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
            closeProfitLossBtn.snp.makeConstraints { (make) in
                make.top.equalTo(availableVolumeL.snp_bottom).offset(15)
                make.left.equalTo(15)
                make.height.equalTo(50)
                make.width.equalTo(triggerConfirBtn.snp_width)
            }
            
            triggerConfirBtn.snp.makeConstraints { (make) in
                make.top.equalTo(closeProfitLossBtn.snp_top)
                make.left.equalTo(closeProfitLossBtn.snp_right).offset(20)
                make.right.equalTo(-15)
                make.height.equalTo(50)
                make.width.equalTo(closeProfitLossBtn.snp_width)
            }
    }
    
    func loadClickEvnet() {
        
        closeProfitLossBtn.rx.tap.subscribe { (event) in
           
            if let closeAlertBlock = self.closeAlertBlock {
                
                closeAlertBlock()
            }
            
        }.disposed(by: self.disposeBag)
        
        triggerConfirBtn.rx.tap.subscribe { (event) in
                   
            self.confirmOrderEvent(isMarket: false)
            
        }.disposed(by: self.disposeBag)
        
        closeBtn.rx.tap.subscribe { (event) in

            if let closeAlertBlock = self.closeAlertBlock {
                
                closeAlertBlock()
            }
            
        }.disposed(by: self.disposeBag)
    }
    
    func confirmOrderEvent(isMarket: Bool) {
        
        /// 合约下单单位
        var tradingUnit = "CONT"
        /// 下单量，计算方式
        let volumeType = "Cont"
        /// 价格和数量
        let EntrustVolume = self.numberInputView.textField.text ?? "0.00"
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {
                       
            tradingUnit = "COIN"
        }

        if stopLossView.textField.text?.count == 0 && takeProfitView.textField.text?.count == 0 {
            PCAlertManager.showAlertMessage("请输入止盈/止损价")
            return
        }
        
        if Float(numberInputView.textField.text ?? "") ?? 0.0 <= 0 {
            PCAlertManager.showAlertMessage("请设置止盈止损量")
            return
        }
        
        let triggerSetApi = FCApi_trigger_close_set(symbol:positionModel?.symbol ?? "",triggerSource: "TradePrice", stopLossPrice: stopLossView.textField.text ?? "", takeProfitPrice: takeProfitView.textField.text ?? "", orderId: self.triggerModel?.orderId ?? "", entrustVolume: EntrustVolume, volumeType: volumeType, tradingUnit: tradingUnit, positionId: positionModel?.positionId ?? "", entrustTradeType: "Limit")
        triggerSetApi.startWithCompletionBlock { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                self?.makeToast("设置成功")
                
                if let closeAlertBlock = self?.closeAlertBlock {
                    
                    closeAlertBlock()
                }
                
            }else {
                
                let errMsg = responseData?["err"]?["msg"] as? String
                PCAlertManager.showAlertMessage(errMsg)
            }
            
        } failure: { (response) in
            
        }
    }
}
