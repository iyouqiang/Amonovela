//
//  FCPositionHeaderView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit 

class FCPositionHeaderView: UIView {

    @IBOutlet weak var currencyNameL: UILabel!
    
    @IBOutlet weak var currencyL: UILabel!
    
    @IBOutlet weak var IntegratedAssetL: UILabel!
    
    @IBOutlet weak var marginRatioL: UILabel!
    
    @IBOutlet weak var realisedPNLL: UILabel!
    
    @IBOutlet weak var unrealisedPNLL: UILabel!
    
    @IBOutlet weak var marginModeBtn: UIButton!
    
    @IBOutlet weak var holdMarginRatioL: UILabel!
    
    var marginModeBlock: (() -> Void)?
    
    override func awakeFromNib() {
        
        self.IntegratedAssetL.adjustsFontSizeToFitWidth = true
        
        if onlyCross == true {
            
            marginModeBtn.setTitle("全仓模式", for: .normal)
            marginModeBtn.isEnabled = false
            return;
        }
        
        marginModeBtn.isEnabled = true
        if (FCTradeSettingconfig.sharedInstance.marginMode == .marginMode_Isolated) {
            
            marginModeBtn.setTitle("逐仓模式 >", for: .normal)
        }else {
            
            marginModeBtn.setTitle("全仓模式 >", for: .normal)
        }
    }
    
    @IBAction func marginMode(_ sender: Any) {
        
        if let marginModeBlock = self.marginModeBlock {
            marginModeBlock()
        }
    }
    
    var accountInfoModel: FCPositionAccountInfoModel? {
        
        didSet {
            
            guard let accountInfoModel = accountInfoModel else {
                return
            }
            
            if onlyCross != true {
                
                if (FCTradeSettingconfig.sharedInstance.marginMode == .marginMode_Isolated) {
                    
                    marginModeBtn.setTitle("逐仓模式 >", for: .normal)
                }else {
                    
                    marginModeBtn.setTitle("全仓模式 >", for: .normal)
                }
            }
            
            self.currencyNameL.text = "账户权益（\(accountInfoModel.account?.currency ?? "")）"
            self.currencyL.text = "$\(accountInfoModel.account?.equity ?? "0.00")"
            
            let usedMargin = accountInfoModel.account?.usedMargin ?? "0.00"
            let availableMargin = accountInfoModel.account?.availableMargin ?? "0.00"
            let freezedMarginStr = accountInfoModel.account?.freezedMargin ?? "0.00"
            
            self.IntegratedAssetL.text = "=已用\(usedMargin) + 可用\(availableMargin) + 冻结\(freezedMarginStr)"
            
            self.IntegratedAssetL.setAttributeColor(COLOR_MinorTextColor, range: NSRange(location: 0, length: 3))
            self.IntegratedAssetL.setAttributeColor(COLOR_MinorTextColor, range: NSRange(location: 3+usedMargin.count, length: 5))
            
            self.IntegratedAssetL.setAttributeColor(COLOR_MinorTextColor, range: NSRange(location: 3+usedMargin.count + 5 + availableMargin.count, length: 5))
            
            self.marginRatioL.text = (accountInfoModel.account?.marginRatio ?? "0.00") + "%"
            
            let realisedPNL = accountInfoModel.account?.realisedPNL ?? "0.00"
            let unrealisedPNL = accountInfoModel.account?.unrealisedPNL ?? "0.00"
                
            self.realisedPNLL.text = realisedPNL
            self.unrealisedPNLL.text = unrealisedPNL
            if (realisedPNL as NSString).floatValue > 0 {
                
                self.realisedPNLL.textColor = COLOR_RiseColor
            }else if (realisedPNL as NSString).floatValue < 0 {
                self.realisedPNLL.textColor = COLOR_FailColor
            }else {
                
                self.realisedPNLL.textColor = COLOR_InputText
            }
            
            if (unrealisedPNL as NSString).floatValue > 0 {
                
                self.unrealisedPNLL.textColor = COLOR_RiseColor
            }else if (unrealisedPNL as NSString).floatValue < 0 {
                self.unrealisedPNLL.textColor = COLOR_FailColor
            }else {
                
                self.unrealisedPNLL.textColor = COLOR_InputText
            }
            
            let holdMarginRatio = ((accountInfoModel.account?.holdMarginRatio! ?? "0") as NSString).floatValue
            self.holdMarginRatioL.text = "* 保证金率达到\(holdMarginRatio)%时发生强平"
            self.holdMarginRatioL.setAttributeColor(COLOR_TabBarTintColor, range: NSRange(location: 0, length: 1))
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
