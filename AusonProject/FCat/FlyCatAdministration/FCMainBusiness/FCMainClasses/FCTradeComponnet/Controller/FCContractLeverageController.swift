//
//  FCContractLeverageController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/26.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractLeverageController: UIViewController {

    var titlebullBearL: UILabel!
    var levelL: UILabel!
    var sliderView: UISlider!
    var levelNumView: UIView!
    var warmL: UILabel!
    var confirmBtn: FCThemeButton!
    var leverType: LeverageType?
    var maxLeverage: String?
    var xunitL: UILabel!
    var numTextfield: UITextField?
    var leveragestrategyBlock: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = COLOR_BGColor
        self.title = "杠杆倍数"
        
        self.setUpView()
    }
    
    func setUpView() {
        
        let leverStr = self.leverType == .LeverageType_long ? "开多杠杆倍数" : "开空杠杆倍数"
        
        let leverNum: String = (self.leverType == .LeverageType_long ? FCTradeSettingconfig.sharedInstance.longLeverage : FCTradeSettingconfig.sharedInstance.shortLeverage) ?? "0"
        
        titlebullBearL = fc_labelInit(text: leverStr, textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        titlebullBearL.textAlignment = .center
        view.addSubview(titlebullBearL)
        
        levelL = fc_labelInit(text: "\(leverNum)", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 30), bgColor: .clear)
        levelL.textAlignment = .right
        view.addSubview(levelL)
        levelL.isHidden = true
        
        numTextfield = UITextField()
        numTextfield?.delegate = self
        numTextfield?.text = levelL.text
        numTextfield?.keyboardType = .numberPad
        numTextfield?.textAlignment = .center
        numTextfield?.font = UIFont(name: "Helvetica Neue", size: 30)!
        numTextfield?.textColor = COLOR_InputText
        numTextfield?.borderStyle = .none
        view.addSubview(numTextfield!)
        
        xunitL = fc_labelInit(text: "X", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 30), bgColor: .clear)
        xunitL.textAlignment = .left
        view.addSubview(xunitL)
        
        sliderView = UISlider()
        sliderView?.tintColor = COLOR_TabBarTintColor
        sliderView?.backgroundColor = .clear
        sliderView?.thumbTintColor = COLOR_TabBarTintColor
        sliderView?.minimumTrackTintColor = COLOR_TabBarTintColor
        sliderView?.maximumTrackTintColor = COLOR_CharTipsColor
        view.addSubview(sliderView)
        sliderView.addTarget(self, action: #selector(sliderChangeValue), for: .valueChanged)
        //sliderView.setValue((leverNum as NSString).floatValue/100.0, animated: true)
        
        /// 杠杆水平
        levelNumView = UIView()
        view.addSubview(levelNumView)
        let maxLongLeverage = FCTradeSettingconfig.sharedInstance.tradeSettingInfoModel?.maxLongLeverage
         let maxShortLeverage = FCTradeSettingconfig.sharedInstance.tradeSettingInfoModel?.maxShortLeverage
         maxLeverage = self.leverType == .LeverageType_long ? maxLongLeverage : maxShortLeverage
        let stepSize: String = maxLeverage ?? "0"
        let itemWidth = (kSCREENWIDTH - 30)/4.0
        for num in 0...4 {
        
            let itemL = fc_labelInit(text: "\((num) * ((Int(stepSize) ?? 0)/4))", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
            levelNumView.addSubview(itemL)
            
            itemL.frame = CGRect(x: CGFloat(num)*itemWidth, y: 0, width: itemWidth, height: 30)
            
            if num == 0 {
                
                itemL.textAlignment = .left
                itemL.text = "1"
            }
            
            if num == 4 {
                
                itemL.textAlignment = .right
                itemL.text = maxLeverage
                itemL.frame = CGRect(x: CGFloat(num - 1)*itemWidth, y: 0, width: itemWidth, height: 30)
            }
        }
        
        let maxNum = Float(maxLeverage ?? "0")
        let currentNum = Int(((leverNum as NSString).floatValue)*(100.0/(maxNum ?? 0.0)))
        sliderView.setValue(Float(currentNum)/100
            , animated: true)
        
        /// 风险提示
        warmL = fc_labelInit(text: "* 当前杠杆倍数较高，请注意风险", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        warmL.setAttributeColor(COLOR_TabBarTintColor, range: NSRange(location: 0, length: 1))
        view.addSubview(warmL)
        //warmL.isHidden = true
        sliderView.setValue(Float(currentNum)/100
            , animated: true)
        
        confirmBtn = FCThemeButton.init(title: "确定", frame:CGRect.zero , cornerRadius: 4)
        view.addSubview(confirmBtn)
        confirmBtn.addTarget(self, action: #selector(confirmLevelAction), for: .touchUpInside)
        
        /// 界面布局
        titlebullBearL.snp_makeConstraints { (make) in
            
            make.top.equalTo(kNAVIGATIONHEIGHT + 30)
            make.left.right.equalTo(0)
            make.height.equalTo(30)
        }
        
        levelL.snp.makeConstraints { (make) in
            
            make.top.equalTo(titlebullBearL.snp_bottom)
            //make.left.right.equalTo(0)
            make.centerX.equalToSuperview()
        }
        
        numTextfield?.snp.makeConstraints({ (make) in
            make.edges.equalTo(levelL)
        })
        
        xunitL.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(levelL.snp_centerY)
            make.left.equalTo(levelL.snp_right)
        }
        
        sliderView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(levelL.snp_bottom).offset(20)
        }
        
        levelNumView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(sliderView.snp_bottom).offset(20)
            make.height.equalTo(30)
        }
        
        warmL.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(levelNumView.snp_bottom).offset(20)
        }
        
        confirmBtn.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo(warmL.snp_bottom).offset(30)
            make.height.equalTo(50)
        }
    }
    
    @objc func sliderChangeValue()
    {
        let value = sliderView.value * 100
        
        let maxNum = Float(maxLeverage ?? "0")
    
        let currentNum = Int(value*((maxNum ?? 0.0)/100.0))
        
        self.levelL.text = "\(currentNum)"
        self.numTextfield?.text = self.levelL.text
        
        if currentNum >= 20 {
            warmL.isHidden = false
        }else {
            warmL.isHidden = true
        }
        
    }
    
    @objc func confirmLevelAction() {
        
        let value = sliderView.value * 100
        let maxNum = (maxLeverage! as NSString).floatValue
        let currentNum = Int(value*(maxNum/100.0))
        
        var strategyApi:FCApi_trading_strategy_set
        
        if self.leverType == .LeverageType_long {
            
            //FCTradeSettingconfig.sharedInstance.longLeverage = "\(currentNum)"
            strategyApi = FCApi_trading_strategy_set(longLeverage:"\(currentNum)")
            
        }else {
           
           // FCTradeSettingconfig.sharedInstance.shortLeverage = "\(currentNum)"
            
            strategyApi = FCApi_trading_strategy_set(shortLeverage:"\(currentNum)")
        }
        
        strategyApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
                       if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                         
                        if self?.leverType == .LeverageType_long {
                            
                            FCTradeSettingconfig.sharedInstance.longLeverage = "\(currentNum)"
                            //strategyApi = FCApi_trading_strategy_set(longLeverage:"\(currentNum)")
                            
                        }else {
                           
                            FCTradeSettingconfig.sharedInstance.shortLeverage = "\(currentNum)"
                            
                            //strategyApi = FCApi_trading_strategy_set(shortLeverage:"\(currentNum)")
                        }
                        
                        if let leveragestrategyBlock = self?.leveragestrategyBlock {
                            leveragestrategyBlock()
                        }
                        
                        self?.navigationController?.popViewController(animated: true)
                          
                       } else{
                           let errMsg = responseData?["err"]?["msg"] as? String
                           PCAlertManager.showAlertMessage(errMsg)
                       }
            
        }) { (response) in
            
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

}

extension FCContractLeverageController:UITextFieldDelegate {
    
       /// 只能输入数字和小数点
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            
            var tempStr = textField.text!.appending(string)
            
            if string.count == 0 {
               tempStr = tempStr.subString(to: tempStr.count - 1)
            }

            let currentNumber = (tempStr as NSString).floatValue
            let maxNumber = ((maxLeverage ?? "") as NSString).floatValue
            
            if currentNumber > maxNumber {
                return false
            }
            
            if tempStr.count == 0 {
                textField.text = "0"
            }
          
            self.sliderView.setValue(currentNumber/maxNumber, animated: true)
            
            return true
        }
}

extension String {
    /// 截取到任意位置
    func subString(to: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: to)
        return String(self[..<index])
    }
    /// 从任意位置开始截取
    func subString(from: Int) -> String {
        let index: String.Index = self.index(startIndex, offsetBy: from)
        return String(self[index ..< endIndex])
    }
    /// 从任意位置开始截取到任意位置
    func subString(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
    //使用下标截取到任意位置
    subscript(to: Int) -> String {
        let index = self.index(self.startIndex, offsetBy: to)
        return String(self[..<index])
    }
    //使用下标从任意位置开始截取到任意位置
    subscript(from: Int, to: Int) -> String {
        let beginIndex = self.index(self.startIndex, offsetBy: from)
        let endIndex = self.index(self.startIndex, offsetBy: to)
        return String(self[beginIndex...endIndex])
    }
}
