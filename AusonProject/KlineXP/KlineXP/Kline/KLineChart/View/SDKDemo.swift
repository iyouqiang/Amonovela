//
//  SDKDemo.swift
//  KLineXP
//
//  Created by Yochi on 2020/11/8.
//

import Foundation
import UIKit

open class SDKDemoView: UIView {
    
    @IBAction func click(_ sender: Any) {
        
        //print("我被点击了")
    }
    @IBOutlet weak var clickBtn: UIButton!
    
    public static func getDemoView() -> SDKDemoView {
        
        //print("KLineBundle : ", KLineBundle, Bundle.main.path(forResource:"KLineBundle", ofType:"bundle") ?? "");
        
        guard let bundle = KLineBundle else {
            return SDKDemoView()
        }
        
        //let view = bundle.loadNibNamed("SDKDemoView", owner: nil, options: nil)?.last as! SDKDemoView
        let view = bundle.loadNibNamed("SDKDemo", owner: nil, options: nil)?.last as! SDKDemoView
        
        //bundle.loadNibNamed("SDKDemoView", owner: self, options: nil)
        
        //print("KLineBundle KLineBundle : ", view);
        
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        view.backgroundColor = ChartColors.bgColor
        view.layer.shadowColor =  UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        return view
    }
}
