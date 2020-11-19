//
//  FCKLineRestingHeader.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCKLineRestingHeader: UIView {

    
    @IBOutlet weak var buyAccountLab: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var sellAccountLab: UILabel!
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    static func restingView() -> FCKLineRestingHeader {
        let view = Bundle.main.loadNibNamed("FCKLineRestingHeader", owner: self, options: nil)?.last as! FCKLineRestingHeader
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        return view
    }
    
    func reloadLabels(symbol:String) {
        let arrayStrings: [String] = symbol.split(separator: "-").compactMap { "\($0)" } 
        self.buyAccountLab.text = "数量(\(arrayStrings.first ?? ""))"
        self.sellAccountLab.text = "数量(\(arrayStrings.first ?? ""))"
        self.priceLab.text = "价格(\(arrayStrings.last ?? ""))"
    }
    

}
