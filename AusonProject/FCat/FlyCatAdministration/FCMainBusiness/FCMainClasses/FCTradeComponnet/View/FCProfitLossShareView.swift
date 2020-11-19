//
//  FCProfitLossShareView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/25.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCProfitLossShareView: UIView {

    @IBOutlet weak var themeImgView: UIImageView!
    @IBOutlet weak var themeSloganL: UILabel!
    @IBOutlet weak var yieldL: UILabel!
    @IBOutlet weak var symbolTitleL: UILabel!
    @IBOutlet weak var longShortLeverL: UILabel!
    @IBOutlet weak var openPriceL: UILabel!
    @IBOutlet weak var currentPriceL: UILabel!
    @IBOutlet weak var QRCodeImgView: UIImageView!
    @IBOutlet weak var productNameL: UILabel!
    @IBOutlet weak var productDesL: UILabel!
    var qrUrl = ""
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var shareModel: FCPnlShareModel? {
        
        didSet {
            
            guard let shareModel = shareModel else {
                return
            }
            
            themeSloganL.text = shareModel.descriptionStr
            symbolTitleL.text = shareModel.symbolName
            let pnlRateFloat = Float(shareModel.pnlRate ?? "0") ?? 0
            yieldL.text = String(format: "%.2f%%", pnlRateFloat*100)
            
            let leverage = shareModel.leverage ?? ""
            
            if shareModel.makeSide == "Long" {
                
                longShortLeverL.text = " 做多 \(leverage) "
                longShortLeverL.backgroundColor = COLOR_RiseColor
            }else {
                
                longShortLeverL.backgroundColor = COLOR_FailColor
                longShortLeverL.text = " 做空 \(leverage) "
            }
                        
            if pnlRateFloat >= 0 {
                
                themeImgView.image = UIImage(named: "shareProfitIcon")
                yieldL.textColor = COLOR_RiseColor
                longShortLeverL.backgroundColor = COLOR_RiseColor
            }else {
                
                yieldL.textColor = COLOR_FailColor
                themeImgView.image = UIImage(named: "shareLossIcon")
                longShortLeverL.backgroundColor = COLOR_FailColor
            }
            
            currentPriceL.text = shareModel.closePrice
            openPriceL.text = shareModel.openPrice
            
            let qrcodeUrl = shareModel.qrcodeUrl ?? "https://testflight.apple.com/join/k0eHFEwv"
            
            if (qrUrl != qrcodeUrl) {
                
                qrUrl = qrcodeUrl
                
                let qrcode = FCQRCodeTool()
                let image = qrcode.setupQRCodeImage(qrUrl, image: nil, successBlock: {
                     
                    print("二维码生成成功")
                 }) {
                    
                    print("二维码生成失败")
                 }
                
                self.QRCodeImgView.image = image
            }
        }
    }
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.productDesL.adjustsFontSizeToFitWidth = true
        self.longShortLeverL.layer.cornerRadius = 3
        self.longShortLeverL.clipsToBounds = true
        
        productNameL.text = NSString.getAppName()
        /**
        let qrcode = FCQRCodeTool()
        let image = qrcode.setupQRCodeImage("https://testflight.apple.com/join/k0eHFEwv", image: nil, successBlock: {
             
            print("二维码生成成功")
         }) {
            
            print("二维码生成失败")
         }
        
        self.QRCodeImgView.image = image
         */
    }
}
