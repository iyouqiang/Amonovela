
//
//  FCKLineDealHeader.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCKLineDealHeader: UIView {

    
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var accountLab: UILabel!
    

    static func dealingView() -> FCKLineDealHeader {
        let view = Bundle.main.loadNibNamed("FCKLineDealHeader", owner: self, options: nil)?.last as! FCKLineDealHeader
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 40)
        return view
    }
    
    func reloadLabels(symbol:String) {
        let arrayStrings: [String] = symbol.split(separator: "-").compactMap { "\($0)" }
        self.accountLab.text = "数量(\(arrayStrings.first ?? ""))"
        self.priceLab.text = "价格(\(arrayStrings.last ?? ""))"
    }

}
