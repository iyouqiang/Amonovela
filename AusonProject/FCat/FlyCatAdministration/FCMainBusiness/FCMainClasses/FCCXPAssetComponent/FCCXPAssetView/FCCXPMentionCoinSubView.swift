//
//  FCCXPMentionCoinSubView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

typealias DigitalWithdrawalEPCBlock = (_ index: Int) -> Void
typealias DigitalWithdrawalRealNumBlock = (_ accountNum : Double) -> Void

class FCCXPMentionCoinSubView: UIView {

    @IBOutlet weak var chainsTitleL: UILabel!
    @IBOutlet weak var topGapConstraint: NSLayoutConstraint!
    @IBOutlet weak var EPCBtn: UIButton!
    @IBOutlet weak var CMNIBtn: UIButton!
    @IBOutlet weak var mentionAddressTextfield: UITextField!
    @IBOutlet weak var mentionNumTextfield: UITextField!
    @IBOutlet weak var serviceChargeUnitL: UILabel!
    @IBOutlet weak var numberUnitL: UILabel!
    @IBOutlet weak var availableBalanceL: UILabel!
    @IBOutlet weak var serviceChargeL: UILabel!
    
    @IBOutlet weak var availableBalanceWidth: NSLayoutConstraint!
    var digitalSymbolEPCBlock:DigitalWithdrawalEPCBlock?
    var digitalWithdrawalRealNumBlock:DigitalWithdrawalRealNumBlock?

    override func awakeFromNib() {
        
        self.EPCBtn.layer.cornerRadius = 2
        self.EPCBtn.layer.borderWidth = 0.8
        self.EPCBtn.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        
        self.CMNIBtn.layer.cornerRadius = 2
        self.CMNIBtn.layer.borderWidth = 0.8
        self.CMNIBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        
        //mentionAddressTextfield.setValue(COLOR_YELLOWColor, forKey: "_placeholderLabel.textColor")
        
        mentionAddressTextfield.attributedPlaceholder = NSAttributedString.init(string: "输入或长按张贴地址", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:COLOR_HexColor(0x6A6A6E)])
        mentionNumTextfield.attributedPlaceholder = NSAttributedString.init(string: "最小提币数量2", attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: 14),NSAttributedString.Key.foregroundColor:COLOR_HexColor(0x6A6A6E)])
        mentionNumTextfield.delegate = self
        
        self.availableBalanceL.text = "可用 0.00 USDT"
        let attrStr = NSMutableAttributedString.init(string: self.availableBalanceL.text ?? "0.00")
        attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_tabbarNormalColor, range:NSRange.init(location:3, length: "0.00".count ))
        self.availableBalanceL.attributedText = attrStr
    }
    
    @IBAction func queryAction(_ sender: Any) {
        
        print("可用QA")
    }
    
    @IBAction func EPCAction(_ sender: UIButton) {
        
        EPCBtn.isSelected = true
        CMNIBtn.isSelected = false
        EPCBtn.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        CMNIBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        
        if let digitalSymbolEPCBlock = digitalSymbolEPCBlock {
            digitalSymbolEPCBlock(sender.tag - 100)
        }
    }
    
    @IBAction func CMNIAction(_ sender: UIButton) {
        
        EPCBtn.isSelected = false
        CMNIBtn.isSelected = true
        EPCBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        CMNIBtn.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        
        if let digitalSymbolEPCBlock = digitalSymbolEPCBlock {
            digitalSymbolEPCBlock(sender.tag - 100)
        }
    }
    
    var assetConfigModel: FCCXPAssetConfigModel? {
        
        didSet {
            guard let assetConfigModel = assetConfigModel else {
                return
            }
            
            let symbolArray = assetConfigModel.symbol?.split(separator: "_")
            
            let unitStr = "\(symbolArray?.first ?? "")"
            
            self.mentionNumTextfield.placeholder = "最小提币数量 \(assetConfigModel.minConfirmation ?? "0")"
            self.serviceChargeL.text = assetConfigModel.commission
            self.numberUnitL.text = unitStr
            self.serviceChargeUnitL.text = unitStr
            
            /// 余额高亮
            let balance = "\(assetConfigModel.balance ?? "0.00")"
            self.availableBalanceL.text = "可用 \(balance) \(unitStr)"
            let attrStr = NSMutableAttributedString.init(string: self.availableBalanceL.text ?? "0.00")
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_tabbarNormalColor, range:NSRange.init(location:3, length: balance.count ))
            self.availableBalanceL.attributedText = attrStr
            
            //let minConfirmation = (assetConfigModel.minConfirmation as! NSString).floatValue
            //let commission = (assetConfigModel.commission as! NSString).floatValue
            
            /// 高亮显示
            
            /// 计算文本宽度
        }
    }
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}

extension FCCXPMentionCoinSubView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if !string.isVerifyLegalNumber() && string.count > 0 {
            return false;
        }
        
        let toBeStr = textField.text
        let rag = toBeStr?.toRange(range)
        let tempStr = textField.text?.replacingCharacters(in:rag!, with: string)
        
        let numValue = (tempStr! as NSString).doubleValue
        
        /// 资产计算
        //let minConfirmation = ((self.assetConfigModel?.minConfirmation ?? "") as NSString).floatValue
        let commission = ((self.assetConfigModel?.commission ?? "") as NSString).doubleValue
        
        let accountNum = numValue - commission
        
        if self.digitalWithdrawalRealNumBlock != nil {
            self.digitalWithdrawalRealNumBlock!(accountNum)
        }
        
        return true
    }
}
