//
//  FCTotalAssetsView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

typealias HideMicroBlock = (_ isHiden: Bool) -> Void

class FCTotalAssetsView: UIView {

    @IBOutlet weak var assetTitleL: UILabel!
    
    @IBOutlet weak var assetAcountL: UILabel!
    
    @IBOutlet weak var tradeCheckBtn: UIButton!
    
    @IBOutlet weak var explainBtn: UIButton!
    var hideMicroBlock: HideMicroBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        assetAcountL.text = "0.00≈0.00 CNY"
        self.assetAcountL.setAttributeFont(UIFont.systemFont(ofSize: 27), range: NSRange(location: 0, length: 4))
        self.assetAcountL.setAttributeColor(COLOR_TabBarTintColor, range: NSRange(location: 0, length: 4))
    }
    
    var assetSummaryModel: FCSummaryModel? {
        
        didSet {
            guard let assetSummaryModel = assetSummaryModel else {
                return
            }
            
            assetTitleL.text = "币币总资产折合 （\(assetSummaryModel.estimatedAsset!)）"
            assetAcountL.text = "\(assetSummaryModel.estimatedValue ?? "0.00")≈\(assetSummaryModel.estimatedFiatValue ?? "0.00") \(assetSummaryModel.estimatedFiatAsset ?? "")"
            
            let estimatedValueStr = assetSummaryModel.estimatedValue
            
            self.assetAcountL.setAttributeFont(UIFont.systemFont(ofSize: 27), range: NSRange(location: 0, length: estimatedValueStr?.count ?? 0))
            self.assetAcountL.setAttributeColor(COLOR_TabBarTintColor, range: NSRange(location: 0, length: estimatedValueStr?.count ?? 0))
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    
    @IBAction func tradeCheckBoxActoin(_ sender: UIButton) {
        
        self.tradeCheckBtn.isSelected = !self.tradeCheckBtn.isSelected
        if let hideMicroBlock = hideMicroBlock {
            hideMicroBlock(sender.isSelected)
        }
    }
    
    @IBAction func tradeAssetAcountQAActin(_ sender: UIButton) {
        
        let popTip = PopTip()
        
        popTip.bubbleColor = COLOR_HexColor(0xFFCE18)
        popTip.textColor = COLOR_BGColor
        popTip.bubbleOffset = 123
        popTip.arrowOffset = 123
        popTip.arrowSize = CGSize.zero
        
        popTip.show(text: "折合成CNY的价值低于50的币种，叫小额币种。", direction: .down, maxWidth: kSCREENWIDTH - 123, in: self.explainBtn, from: CGRect(x: 0, y: 30, width: 0, height: 0))
  
    }
}
