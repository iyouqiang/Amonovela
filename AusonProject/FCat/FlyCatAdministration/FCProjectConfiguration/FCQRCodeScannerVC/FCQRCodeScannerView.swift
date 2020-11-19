
//
//  FCQRCodeScannerView.swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

private let pickingWidth : CGFloat = 260
private let pickingHeight : CGFloat = 260

class FCQRCodeScannerView: UIView {
   
    var scan_lineLayer : CALayer!
    var scan_frameLayer : CALayer!
    var bgLayer : CAShapeLayer!
    var popBlock: (() -> Void)?
    var openAlbumBlock: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .black
        self.scan_lineLayer = CALayer(layer:layer)
        self.scan_lineLayer.contents = UIImage(named:"scan_line")?.cgImage
        self.scan_lineLayer.frame = CGRect(x: (self.frame.size.width - pickingWidth)/2, y: (self.frame.size.height - pickingHeight)/2, width:pickingWidth, height:4)
        self.layer.addSublayer(self.scan_lineLayer)
        
        self.scan_frameLayer = CALayer(layer:layer)
        self.scan_frameLayer.contents = UIImage(named:"scan_frame")?.cgImage
        self.scan_frameLayer.frame = CGRect(x: (self.frame.size.width - pickingWidth)/2 , y: (self.frame.size.height - pickingHeight)/2, width:pickingWidth, height:pickingHeight)
        self.layer.addSublayer(self.scan_frameLayer)
        
        hollowOutRect()
        self.resumeAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func hollowOutRect() {//镂空
        let path = UIBezierPath.init(rect: self.bounds)
        path.append(UIBezierPath.init(rect: self.scan_frameLayer.frame))
        path.usesEvenOddFillRule = true
        
        if self.bgLayer == nil {
            
            self.bgLayer = CAShapeLayer.init()
            self.bgLayer.fillRule = CAShapeLayerFillRule.evenOdd
            self.bgLayer.path = path.cgPath
            self.bgLayer.fillColor = COLOR_HexColorAlpha(0x000000, alpha: 0.4).cgColor
        }
        
        self.layer .addSublayer(self.bgLayer)
    }
    
    
    @objc func stopAnimation(){
        
        self.scan_lineLayer?.removeAnimation(forKey:"translationY")
    }
    
    @objc func resumeAnimation(){
        let basic = CABasicAnimation(keyPath:"transform.translation.y")
        basic.fromValue = (0)
        basic.toValue = (pickingHeight - 4)
        basic.duration = 1.5
        basic.repeatCount = Float(NSIntegerMax)
        self.scan_lineLayer?.add(basic, forKey:"translationY")
    }
}
