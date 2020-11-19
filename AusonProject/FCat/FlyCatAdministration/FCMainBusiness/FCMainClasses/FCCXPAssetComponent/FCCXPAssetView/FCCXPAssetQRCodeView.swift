//
//  FCCXPAssetQRCodeView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

typealias DigitalSymbolEPCBlock = (_ index: Int) -> Void

class FCCXPAssetQRCodeView: UIView {
    
    @IBOutlet weak var chainsTitleL: UILabel!
    @IBOutlet weak var EPCBtn: UIButton!
    @IBOutlet weak var CMNIBtn: UIButton!
    @IBOutlet weak var qrcodeImgView: UIImageView!
    @IBOutlet weak var chargeAddressL: UILabel!
    @IBOutlet weak var topGapConstrainsts: NSLayoutConstraint!
    var digitalSymbolEPCBlock:DigitalSymbolEPCBlock?
    let qrcode = FCQRCodeTool()
    
    @IBAction func cmniAction(_ sender: UIButton) {
        
        EPCBtn.isSelected = false
        CMNIBtn.isSelected = true
        CMNIBtn.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        EPCBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        
        if let digitalSymbolEPCBlock = digitalSymbolEPCBlock {
            digitalSymbolEPCBlock(sender.tag - 100)
        }
    }
    
    @IBAction func epcAction(_ sender: UIButton) {
        
        EPCBtn.isSelected = true
        CMNIBtn.isSelected = false
        EPCBtn.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        CMNIBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        
        if let digitalSymbolEPCBlock = digitalSymbolEPCBlock {
            digitalSymbolEPCBlock(sender.tag - 100)
        }
    }
    @IBAction func saveToAlbumAction(_ sender: Any) {
        if let img = self.qrcodeImgView.image {
            
            qrcode.saveImage(image: img)
            return
        }
        self.makeToast("未获取到二维码图片")
    }
    @IBAction func copyChargeAddressL(_ sender: Any) {
        
        /// 字符串复制
        let past = UIPasteboard.general
        past.string = chargeAddressL.text
        self.makeToast("复制完成")
    }
    
    override func awakeFromNib() {
        
        self.EPCBtn.layer.cornerRadius = 2
        self.EPCBtn.layer.borderWidth = 0.8
        self.EPCBtn.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        
        self.CMNIBtn.layer.cornerRadius = 2
        self.CMNIBtn.layer.borderWidth = 0.8
        self.CMNIBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        
        self.chargeAddressL.adjustsFontSizeToFitWidth = true
    }
    
    var digitalSymbolModel: FCCXPAssetDepositModel?{
           
           didSet {
               
               guard let digitalSymbolModel = digitalSymbolModel else {
                   return
               }
            
            self.chargeAddressL.text = digitalSymbolModel.digitalAddress
            
            let image = qrcode.setupQRCodeImage(self.chargeAddressL.text ?? "", image: nil, successBlock: {
                 self.makeToast("二维码保存成功")
             }) {
                 self.makeToast("二维码保存失败")
             }
             
             qrcodeImgView.image = image
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
