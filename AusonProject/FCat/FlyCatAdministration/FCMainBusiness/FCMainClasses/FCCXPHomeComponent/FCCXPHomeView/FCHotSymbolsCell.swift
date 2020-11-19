//
//  FCHotSymbolsCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCHotSymbolsCell: UITableViewCell {

    @IBOutlet weak var tradeSymbolL:UILabel!
    @IBOutlet weak var tradeNumL: UILabel!
    @IBOutlet weak var tradeLatesPriceL: UILabel!
    @IBOutlet weak var trademeasureL: UILabel!
    @IBOutlet weak var tradeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tradeBtn.layer.cornerRadius = 5.0
        tradeNumL.adjustsFontSizeToFitWidth = true
        tradeLatesPriceL.adjustsFontSizeToFitWidth = true
        trademeasureL.adjustsFontSizeToFitWidth = true
        self.backgroundColor = COLOR_CellBgColor
        self.contentView.backgroundColor = COLOR_CellBgColor
    }
    
    var symbolModel:FCHomeSymbolsModel? {
        
        didSet{
            
            guard let symbolModel = symbolModel else {
                return
            }
            
            /**
             changePercent = "2.25";
             close = "0.0";
             fiatCurrency = CNY;
             fiatPrice = "\Uffe5413.43";
             high = "58.45";
             isOptional = 0;
             latestPrice = "58.23";
             low = "56.95";
             marketType = Spot;
             name = "LTC/USDT";
             open = "0.0";
             symbol = "LTC-USDT";
             tradingAmount = "585.98";
             */
            
            tradeSymbolL.text = symbolModel.name
            
            let array : Array = tradeSymbolL.text?.components(separatedBy: "/") ?? []
            let symbolStr = array.first
            
            let attrStr = NSMutableAttributedString.init(string: tradeSymbolL.text ?? "")
    
            // 富文本修改位置大小
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_HexColor(0xdadada), range:NSRange.init(location:0, length: symbolStr?.count ?? 0))
            attrStr.addAttribute(NSAttributedString.Key.font, value:UIFont.systemFont(ofSize: 16), range:NSRange.init(location:0, length: symbolStr?.count ?? 0))
            tradeSymbolL.attributedText = attrStr
            
            tradeNumL.text = "24H量 \(symbolModel.tradingAmount ?? "")"
            tradeLatesPriceL.text = symbolModel.latestPrice
            trademeasureL.text = "\(symbolModel.fiatPrice ?? "")\(symbolModel.fiatCurrency ?? "")"
            
            
            if (symbolModel.changePercent! as NSString).floatValue >= 0 {
                tradeBtn.setTitle("+\(symbolModel.changePercent ?? "--")%", for: .normal)
                tradeBtn.backgroundColor = COLOR_BGRiseColor
                tradeBtn.setTitleColor(COLOR_RiseColor, for: .normal)
            }else {
                tradeBtn.setTitle("\(symbolModel.changePercent ?? "--")%", for: .normal)
                tradeBtn.backgroundColor = COLOR_BGFailColor
                tradeBtn.setTitleColor(COLOR_FailColor, for: .normal)
            }
            
            #if BS_TARGETCXP
          
            tradeBtn.setTitleColor(.white, for: .normal)
            
            #endif
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
