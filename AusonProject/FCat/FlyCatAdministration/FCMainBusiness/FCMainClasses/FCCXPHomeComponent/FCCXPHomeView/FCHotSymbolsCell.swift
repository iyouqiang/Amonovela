//
//  FCHotSymbolsCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCHotSymbolsCell: UITableViewCell {

    @IBOutlet weak var hotBgView: UIView!
    @IBOutlet weak var tradeSymbolL:UILabel!
    @IBOutlet weak var tradeNumL: UILabel!
    @IBOutlet weak var symbolIconImgView: UIImageView!
    @IBOutlet weak var tradeLatesPriceL: UILabel!
    @IBOutlet weak var trademeasureL: UILabel!
    @IBOutlet weak var tradeBtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        tradeBtn.layer.cornerRadius = 5.0
        tradeNumL.font = UIFont(_DINProBoldTypeSize: 13)
        tradeLatesPriceL.font = UIFont(_DINProBoldTypeSize: 15)
        trademeasureL.font = UIFont(_DINProBoldTypeSize: 13)
        tradeBtn.titleLabel?.font = UIFont(_DINProBoldTypeSize: 14)
        tradeNumL.adjustsFontSizeToFitWidth = true
        tradeLatesPriceL.adjustsFontSizeToFitWidth = true
        trademeasureL.adjustsFontSizeToFitWidth = true
        self.backgroundColor = COLOR_CellBgColor
        self.contentView.backgroundColor = COLOR_CellBgColor
        self.hotBgView.layer.cornerRadius = 8;
        self.hotBgView.clipsToBounds = true
        self.hotBgView.backgroundColor = COLOR_HexColor(0x1D2439)
        self.symbolIconImgView.layer.cornerRadius = 17.5
        self.symbolIconImgView.clipsToBounds = true
        tradeSymbolL.adjustsFontSizeToFitWidth = true
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
            
            self.symbolIconImgView.sd_setImage(with: URL(string: (symbolModel.iconUrl ?? "")), placeholderImage: UIImage(named: "trade_BTC"), options: .retryFailed, completed: nil)
            
            let array : Array = symbolModel.symbol?.components(separatedBy: "-") ?? []
            
            var symbolStr = array.first
            
            var tradeSymbolStr = symbolModel.symbol?.replacingOccurrences(of: "-", with: "/") //symbolModel.name
            
            if (symbolModel.name?.count ?? 0) > 0 {
                tradeSymbolStr = symbolModel.name
                symbolStr = symbolModel.name
            }
            
            let attrStr = NSMutableAttributedString.init(string: tradeSymbolStr ?? "")
            
            // 富文本修改位置大小
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:UIColor.white, range:NSMakeRange(0,  symbolStr?.count ?? 0))
            attrStr.addAttribute(NSAttributedString.Key.font, value:UIFont(_DINProBoldTypeSize: 16), range:NSMakeRange(0, symbolStr?.count ?? 0))
            
            tradeSymbolL.attributedText = attrStr
            
            tradeNumL.text = "24h量 \(symbolModel.tradingAmount ?? "")"
            tradeLatesPriceL.text = "$ \(symbolModel.latestPrice ?? "")"
            tradeLatesPriceL.setAttributeColor(COLOR_MinorTextColor, range: NSMakeRange(0, 1))
            trademeasureL.text = "\(symbolModel.fiatPrice ?? "")\(symbolModel.fiatCurrency ?? "")"
            
            if symbolModel.priceTrend == "Up" {
                
                tradeLatesPriceL.textColor = COLOR_RiseColor
                
            }else if symbolModel.priceTrend == "Down" {
                
                tradeLatesPriceL.textColor = COLOR_FailColor
                
            }else {
                
                tradeLatesPriceL.textColor = .white
            }
            
            tradeLatesPriceL.setAttributeColor(COLOR_MinorTextColor, range: NSMakeRange(0, 1))
             
            if (symbolModel.changePercent! as NSString).floatValue >= 0 {
                tradeBtn.setTitle("+\(symbolModel.changePercent ?? "--")%", for: .normal)
                //tradeBtn.backgroundColor = COLOR_BGRiseColor
                tradeBtn.setTitleColor(COLOR_RiseColor, for: .normal)
            }else {
                tradeBtn.setTitle("\(symbolModel.changePercent ?? "--")%", for: .normal)
                //tradeBtn.backgroundColor = COLOR_BGFailColor
                tradeBtn.setTitleColor(COLOR_FailColor, for: .normal)
            }
             
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
