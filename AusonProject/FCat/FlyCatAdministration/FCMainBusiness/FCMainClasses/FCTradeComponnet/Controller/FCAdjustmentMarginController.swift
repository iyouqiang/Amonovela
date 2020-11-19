//
//  FCAdjustmentMarginController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/28.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

public enum AdjustmentMarginType: Int{
    case addMargin
    case reduceMargin
}

class FCAdjustmentMarginController: UIViewController, UIGestureRecognizerDelegate {

    /// 调整多空头按钮
    var addMarginBtn: UIButton!
    var reduceMarginBtn: UIButton!
    var selectedView: UIView!
    
    /// 最多追加
    var maximumL: UILabel!
    var closePositionL: UILabel!
    
    /// 多空头方向
    var longShortDirectL: UILabel!
    var numberL: UILabel!
    var numTextfield:UITextField?
    var sliderView: UISlider!

    /// 起始值 终值
    var startValueL: UILabel!
    var endValueL: UILabel!
    
    var topMenContainerView: UIView!
    
    /// 确认按钮
    var confirBtn: FCThemeButton!
    
    var positionModel: FCPositionInfoModel?
    var accountInfoModel: FCPositionSingleAccountModel?
    var marginSide: String?
    var increaseValue: Float?
    var decreaseValue: Float?
    var availableMarginValue: Double?
    var marginValue: Double?
    
    init(positionModel: FCPositionInfoModel, accountInfoModel: FCPositionSingleAccountModel) {
        super.init(nibName: nil, bundle: nil)
        self.positionModel = positionModel
        self.accountInfoModel = accountInfoModel
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if gestureRecognizer.isEqual(self.navigationController?.interactivePopGestureRecognizer)  {
            return false
        }
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "调整保证金"
        self.marginSide = "Increase"
        self.setUpView()
        self.view.backgroundColor = COLOR_TabBarBgColor
    }
    
    func setUpView() {
        
        /// 增加减少保证金按钮
        topMenContainerView = UIView(frame: CGRect(x: 0, y: kNAVIGATIONHEIGHT, width: kSCREENWIDTH, height: 50))
        topMenContainerView.backgroundColor = COLOR_BGColor
        self.view.addSubview(topMenContainerView)
        
        addMarginBtn = fc_buttonInit(imgName: "", title: "增加保证金", fontSize: 16, titleColor: COLOR_TabBarTintColor, bgColor: .clear)
        addMarginBtn.tag = 100
        addMarginBtn.addTarget(self, action: #selector(adjuestmentMarginAction(sender:)), for: .touchUpInside)
        addMarginBtn.setTitleColor(COLOR_TabBarTintColor, for: .selected)
        addMarginBtn.isSelected = true
        addMarginBtn.setTitleColor(COLOR_InputText, for: .normal)
        topMenContainerView.addSubview(addMarginBtn)
        
        reduceMarginBtn = fc_buttonInit(imgName: "", title: "减少保证金", fontSize: 16, titleColor: COLOR_InputText, bgColor: .clear)
        reduceMarginBtn.setTitleColor(COLOR_TabBarTintColor, for: .selected)
        reduceMarginBtn.setTitleColor(COLOR_InputText, for: .normal)
        reduceMarginBtn.tag = 101
        reduceMarginBtn.addTarget(self, action: #selector(adjuestmentMarginAction(sender:)), for: .touchUpInside)
        topMenContainerView.addSubview(reduceMarginBtn)
        
        let btnWidth = addMarginBtn.titleLabel?.labelWidthMaxHeight(50) ?? 0.0
        addMarginBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(((kSCREENWIDTH/2.0) - btnWidth)/2.0)
            make.width.equalTo(btnWidth)
        }
        
        reduceMarginBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.right.equalTo((-(kSCREENWIDTH/2.0) + btnWidth)/2.0)
            make.width.equalTo(btnWidth)
        }
        
        /// 按钮底部选择条
        selectedView = UIView(frame: CGRect(x: 0, y: 0, width: btnWidth, height: 2))
        selectedView.backgroundColor = COLOR_TabBarTintColor
        topMenContainerView.addSubview(selectedView)
        
        selectedView.snp.makeConstraints { (make) in
            
            make.left.equalTo(addMarginBtn.snp_left)
            make.bottom.equalToSuperview()
            make.height.equalTo(2)
            make.width.equalTo(btnWidth)
        }
        
        /// 增加额 平仓额
        maximumL = fc_labelInit(text: "最多增加：0.00", textColor: COLOR_TabBarTintColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        self.view.addSubview(maximumL)
        
        maximumL.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(25)
            make.top.equalTo(topMenContainerView.snp_bottom).offset(20)
        }
        
        closePositionL = fc_labelInit(text: "追加后强平价格为：0.00", textColor: COLOR_TabBarTintColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        self.view.addSubview(closePositionL)
        
        closePositionL.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(25)
            make.top.equalTo(maximumL.snp_bottom)
        }

        /// 滑竿
        let sliderContainerView = UIView()
        sliderContainerView.backgroundColor = COLOR_BGColor
        view.addSubview(sliderContainerView)
        sliderContainerView.snp.makeConstraints { (make) in
            make.left.right.equalTo(0)
            make.top.equalTo(closePositionL.snp_bottom).offset(20)
            make.height.equalTo(190)
        }
        
        sliderContainerView.backgroundColor = COLOR_BGColor
        longShortDirectL = fc_labelInit(text: "BTCUSDT永续 多头方向", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        longShortDirectL.textAlignment = .center
        sliderContainerView.addSubview(longShortDirectL)
        
        numberL = fc_labelInit(text: "0.00", textColor: COLOR_InputText, textFont:UIFont(name: "Helvetica Neue", size: 26)!, bgColor: .clear)
        numberL.textAlignment = .center
        sliderContainerView.addSubview(numberL)
        numberL.isHidden = true
        
        numTextfield = UITextField()
        numTextfield?.delegate = self
        numTextfield?.text = numberL.text
        numTextfield?.keyboardType = .decimalPad
        numTextfield?.textAlignment = .center
        numTextfield?.font = UIFont(name: "Helvetica Neue", size: 26)!
        numTextfield?.textColor = COLOR_InputText
        numTextfield?.borderStyle = .none
        sliderContainerView.addSubview(numTextfield!)
        
        sliderView = UISlider()
        
        sliderView?.tintColor = COLOR_TabBarTintColor
        sliderView?.backgroundColor = .clear
        sliderView?.thumbTintColor = COLOR_TabBarTintColor
        sliderView?.minimumTrackTintColor = COLOR_TabBarTintColor
        sliderView?.maximumTrackTintColor = COLOR_CharTipsColor
        sliderContainerView.addSubview(sliderView)
        sliderView.addTarget(self, action: #selector(sliderChangeValue), for: .valueChanged)
        
        /// 杠杆水平
        startValueL = fc_labelInit(text: "0", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        sliderContainerView.addSubview(startValueL)
        
        endValueL = fc_labelInit(text: "100", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        endValueL.textAlignment = .right
        sliderContainerView.addSubview(endValueL)
        
        /// 界面布局
        longShortDirectL.snp_makeConstraints { (make) in
            
            make.top.equalTo(30)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
        }
        
        numberL.snp.makeConstraints { (make) in
            
            make.top.equalTo(longShortDirectL.snp_bottom)
            //make.left.right.equalTo(0)
            make.width.equalTo(kSCREENWIDTH - 30)
            make.centerX.equalToSuperview()
        }
        
        numTextfield?.snp.makeConstraints({ (make) in
            make.edges.equalTo(numberL)
        })
        
        sliderView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(numberL.snp_bottom).offset(20)
            
        }
        
        startValueL.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.equalTo(sliderView.snp_bottom)
            make.height.equalTo(30)
            make.width.equalTo(kSCREENWIDTH/2.0)
        }
        
        endValueL.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.top.equalTo(sliderView.snp_bottom)
            make.height.equalTo(30)
            make.width.equalTo(kSCREENWIDTH/2.0)
        }
        
        /// 确认按钮
        confirBtn = FCThemeButton.init(title: "确定", frame:CGRect.zero , cornerRadius: 4)
        view.addSubview(confirBtn)
        confirBtn.addTarget(self, action: #selector(confirmLevelAction), for: .touchUpInside)
        confirBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(sliderContainerView.snp_bottom).offset(30)
            make.height.equalTo(50)
        }
        
        /// 配置数据
        self.configureData()
    }
    
    func configureData() {
        
        /// position 里面的availableMargin可以减少
        /// AccountInfo 里面的availblemargin可以增加
        /// 追加保证金的最大值 accountInfo 里面的 availableMargin
        /// 减少保证金的最大值 position 里的 availableMargin
         // Increase: 增加保证金，Decrease: 减少保证金
        
        var availableMargin:String = "0.00"
        //var margin: String = "0.00"
        if self.marginSide == "Increase" {
    
            /// 增加保证金方向
            maximumL.text = "最多增加：₮\(self.accountInfoModel?.availableMargin ?? "0.0000")"
            //print("第一次进：", self.accountInfoModel?.availableMargin)
            closePositionL.text = "追加后强平价格：₮\(self.positionModel?.liquidatedPrice ?? "0.0000")"
            endValueL.text = self.accountInfoModel?.availableMargin
            availableMargin = (self.accountInfoModel?.availableMargin ?? "0.0") as String
            //margin = self.accountInfoModel?.usedMargin ?? ""
            self.sliderView.setValue(self.increaseValue ?? 0, animated: true)
        }else {
            
            /// 减少保证金方向
            availableMargin = (self.positionModel?.availableMargin ?? "0.0") as String
            //margin = self.positionModel?.margin ?? ""
            maximumL.text = "最多减少：₮\(self.positionModel?.availableMargin ?? "0.0")"
            closePositionL.text = "追加后强平价格：₮\(self.positionModel?.liquidatedPrice ?? "0.00")"
            endValueL.text = self.positionModel?.availableMargin
            self.sliderView.setValue(self.decreaseValue ?? 00, animated: true)
        }
        
        maximumL.setAttributeColor(COLOR_RichBtnTitleColor, range: NSRange(location: 0, length: 5))
        closePositionL.setAttributeColor(COLOR_RichBtnTitleColor, range: NSRange(location: 0, length: 7))
        
        let availableMarginValue = Double(availableMargin)
        self.availableMarginValue = availableMarginValue
        
        numberL.text = String(format: "%.4f", Double(sliderView.value) * (availableMarginValue ?? 0.0))
        numTextfield?.text = numberL.text
        /**
        if sliderView.value == 0 {
            
            let marginValue = Double(margin)
            self.marginValue = marginValue
            //let availableMarginValue = Float(availableMargin)
            //self.availableMarginValue = availableMarginValue
            
            numberL.text = margin
            
            let value =  (marginValue ?? 0)/(availableMarginValue ?? 0)
            self.sliderView.setValue(Float(value), animated: true)
        }
         */
        
        if self.positionModel?.positionSide == "Long" {
            
            /// 多头方向
            longShortDirectL.text = "\(self.positionModel?.symbol ?? "") 多头方向"
            
        }else {
            
            /// 空头方向
            longShortDirectL.text = "\(self.positionModel?.symbol ?? "") 空头方向"
        }
    }
    
   @objc func sliderChangeValue()
   {

    self.numTextfield?.resignFirstResponder()
    let value = sliderView.value
    let realvalue =  Double(value) * availableMarginValue!
    
    self.numberL.text =  String(format: "%.4f", realvalue)
    numTextfield?.text = numberL.text
    if self.marginSide == "Increase" {
        
        /// 增加保证金方向
        self.increaseValue = sliderView.value
    }else {
        
        /// 减少保证金方向
        self.decreaseValue = sliderView.value
    }
        
        calculateliquidatePrice()
    }
    
    @objc func adjuestmentMarginAction(sender: UIButton) {
        
        if sender.tag == 100 {
            
            self.marginSide = "Increase"
            self.addMarginBtn.isSelected = true
            self.reduceMarginBtn.isSelected = false
            //self.sliderView.setValue(self.increaseValue ?? 0.0, animated: true)
            configureData()
            
            UIView.animate(withDuration: 0.2) {
              
                self.selectedView.snp.remakeConstraints { (make) in
                    
                    make.left.equalTo(self.addMarginBtn.snp_left)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(2)
                    make.width.equalTo(self.addMarginBtn.snp.width)
                }
                
                self.topMenContainerView.layoutIfNeeded()
            }
            
        }else {
            
            self.marginSide = "Decrease"
            self.addMarginBtn.isSelected = false
            self.reduceMarginBtn.isSelected = true
            //self.sliderView.setValue(self.decreaseValue ?? 0.0, animated: true)
            configureData()
            UIView.animate(withDuration: 0.2) {
              
                self.selectedView.snp.remakeConstraints { (make) in
                    
                    make.left.equalTo(self.reduceMarginBtn.snp_left)
                    make.bottom.equalToSuperview()
                    make.height.equalTo(2)
                    make.width.equalTo(self.addMarginBtn.snp.width)
                }
                
                self.topMenContainerView.layoutIfNeeded()
            }
        }
    }
    
    func calculateliquidatePrice() {
        
        let liquidatedPrice = Double(self.positionModel?.liquidatedPrice ?? "0.0000")
        var newLiquidatedPrice: Double = 0.0000
        let volumen = Double(numberL.text ?? "0.0000") ?? 0.00
        let commissionRate = Double(positionModel?.commissionRate ?? "0.0000") ?? 0.00
        let positionVolume = Double(positionModel?.volume ?? "0.0000") ?? 0.00
        let contractSize = Double(positionModel?.contractSize ?? "0.0000") ?? 0.00
        
        if self.positionModel?.positionSide == "Long" {
            
            /// 按币计算
            let rate = (positionVolume * (1.0 - commissionRate))
            let rateCONT = ((positionVolume * contractSize ) * (1.0 - commissionRate))
            var diffPrice = volumen / rate
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
                diffPrice = volumen / rateCONT
            }
            if self.marginSide == "Decrease" {
                /// 减少保证金方向
                newLiquidatedPrice = liquidatedPrice! + diffPrice
            }else {
                /// 增加保证金方向
                newLiquidatedPrice = liquidatedPrice! - diffPrice
            }
        }else {
            
            /// 按币计算
            let rate = (positionVolume * (1.0 + commissionRate))
            let rateCONT = ((positionVolume * contractSize ) * (1.0 + commissionRate))
            var diffPrice = volumen / rate
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
                diffPrice = volumen / rateCONT
            }
            if self.marginSide == "Decrease" {
                /// 减少保证金方向
                newLiquidatedPrice = liquidatedPrice! - diffPrice
                
            }else {
                /// 增加保证金方向
                newLiquidatedPrice = liquidatedPrice! + diffPrice
            }
        }
        
        closePositionL.text = String(format: "追加后强平价格：₮%.4f", newLiquidatedPrice)
        closePositionL.setAttributeColor(COLOR_RichBtnTitleColor, range: NSRange(location: 0, length: 7))
    }
    
    func requestAdjustmentMarginData() {
        
        let position_margin = FCApi_position_margin(positionId: self.positionModel?.positionId ?? "", volume: numTextfield?.text ?? "0.00", symbol: self.positionModel?.symbol ?? "", marginSide: self.marginSide ?? "")
        position_margin.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                 self?.view.makeToast("调整成功", position: .center)
                self?.navigationController?.popViewController(animated: true)
                
            }else {
                
                let errMsg = responseData?["err"]?["msg"] as? String
                self?.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (response) in
            
        }
    }
   
    @objc func confirmLevelAction() {
       
       print("杠杆确认：", Int(sliderView.value * 100))
        
        /// 确认修改改保证金
        requestAdjustmentMarginData()
   }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FCAdjustmentMarginController:UITextFieldDelegate {
    
    func calculateDiffPrice(_ textStr: String) {
        
        /// 书籍计算
        let currentValueStr = textStr
        let endValueStr = endValueL.text ?? "0"
        
        let currentValue = Double(currentValueStr)
        let endValue = Double(endValueStr)
        
        let slidervalue =  (currentValue ?? 0)/(endValue ?? 0)
        self.sliderView.setValue(Float(slidervalue), animated: true)
        
        /// 输入控制
        let value = sliderView.value
        let realvalue =  Double(value) * availableMarginValue!
        
        self.numberL.text =  String(format: "%.4f", realvalue)
        
        if self.marginSide == "Increase" {
            
            /// 增加保证金方向
            self.increaseValue = sliderView.value
        }else {
            
            /// 减少保证金方向
            self.decreaseValue = sliderView.value
        }
            
        calculateliquidatePrice()

    }
    
       /// 只能输入数字和小数点
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            let  currentValueStr =
            
                        ((textField.text ?? "") as NSString).replacingCharacters(in: range, with: string)

            self.calculateDiffPrice(currentValueStr)
            
            if string.count == 0 {
                
                return true
            }
            
            // 前面的判断都是正确滴  不需要改动 在最后面加位数限制
            var Digits = 16
            if textField == numTextfield {
                Digits = 15
            }
            if textField.text?.contains(".") == false && string != "" && string != "."{
                if (textField.text?.count)! > Digits{
                    return false
                }
            }

            let scanner = Scanner(string: string)
            let numbers : NSCharacterSet
            let pointRange = (textField.text! as NSString).range(of: ".")

            if (pointRange.length > 0) && pointRange.length < range.location || pointRange.location > range.location + range.length {
                numbers = NSCharacterSet(charactersIn: "0123456789.")
            }else{
                numbers = NSCharacterSet(charactersIn: "0123456789.")
            }

            if textField.text == "" && string == "." {
                return false
            }

            let remain = 8

            let tempStr = textField.text!.appending(string)

            /***************/
           /// 计算输入是的保证金
           //self.calculateDiffPrice(tempStr)
            
            
            let strlen = tempStr.count

            if pointRange.length > 0 && pointRange.location > 0{//判断输入框内是否含有“.”。
                if string == "." {
                    return false
                }

                if strlen > 0 && (strlen - pointRange.location) > remain + 1 {//当输入框内已经含有“.”，当字符串长度减去小数点前面的字符串长度大于需要要保留的小数点位数，则视当次输入无效。
                    return false
                }
            }

            let zeroRange = (textField.text! as NSString).range(of: "0")
            if zeroRange.length == 1 && zeroRange.location == 0 { //判断输入框第一个字符是否为“0”
                if !(string == "0") && !(string == ".") && textField.text?.count == 1 {//当输入框只有一个字符并且字符为“0”时，再输入不为“0”或者“.”的字符时，则将此输入替换输入框的这唯一字符。
                    textField.text = string
                    return false
                }else {
                    if pointRange.length == 0 && pointRange.location > 0 {//当输入框第一个字符为“0”时，并且没有“.”字符时，如果当此输入的字符为“0”，则视当此输入无效。
                        if string == "0" {
                            return false
                        }
                    }
                }
            }
            // let buffer : NSString!
            if !scanner.scanCharacters(from: numbers as CharacterSet, into: nil) && string.count != 0 {
                return false
            }
            return true
        }
}
