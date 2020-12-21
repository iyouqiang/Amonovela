
//
//  FCEntrustListCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FCEntrustListCell: UITableViewCell {
    
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var symbolL: UILabel!
    @IBOutlet weak var markerSideLab: UILabel!
    
    @IBOutlet weak var timeLab: UILabel!
    
    @IBOutlet weak var priceTitleLab: UILabel!
    
    @IBOutlet weak var amountTitleLab: UILabel!
    
    @IBOutlet weak var dealTitleLab: UILabel!
    
    @IBOutlet weak var priceLab: UILabel!
    
    @IBOutlet weak var amountLab: UILabel!
    
    @IBOutlet weak var dealLab: UILabel!
    
    @IBOutlet weak var cancleBtn: UIButton!
    
    var cancelAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        //self.cancleBtn.layer.borderColor = COLOR_BtnTitleColor.cgColor
        //self.cancleBtn.layer.borderWidth = 0.5
        
        markerSideLab.font = UIFont(_PingFangSCTypeSize: 15)
        symbolL.font = UIFont(_DINProBoldTypeSize: 15)
        timeLab.font = UIFont(_DINProBoldTypeSize: 14)
        priceLab.font = UIFont(_DINProBoldTypeSize: 14)
        amountLab.font = UIFont(_DINProBoldTypeSize: 14)
        dealLab.font = UIFont(_DINProBoldTypeSize: 14)
        
        self.cancleBtn.layer.cornerRadius = 2
        cancleBtn.layer.shadowColor = UIColor.black.cgColor
        cancleBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        cancleBtn.layer.shadowRadius = 2;
        cancleBtn.layer.shadowOpacity = 0.3;
        
        var imageIcon = UIImage(named: "revokeOrder")
        imageIcon = imageIcon?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 15)
        cancleBtn.setBackgroundImage(imageIcon, for: .normal)
        
        cancleBtn.rx.tap.subscribe { [weak self](event) in
            self?.cancelAction?()
        }.disposed(by: self.disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func loadData(model: FCTradeHistroyListModel) {
        let arrayStrings: [String] = model.symbol.split(separator: "-").compactMap { "\($0)" }
        //self.markerSideLab.text = model.side == "Bid" ? "买入\(arrayStrings.first ?? "")" : "卖出\(arrayStrings.last ?? "")"
         
        var marketSideStr = model.side == "Bid" ? "买入" : "卖出"
        marketSideStr = model.tradeType == "Limit" ? ("限价" + marketSideStr) : ("市价" + marketSideStr)
        self.markerSideLab.text = marketSideStr
        self.symbolL.text = model.symbol
        self.markerSideLab.textColor = model.side == "Bid" ? COLOR_RiseColor : COLOR_FailColor
        self.timeLab.text = model.entrustTm
        self.priceLab.text = model.entrustPrice
        self.amountLab.text = model.entrustVolume
        self.dealLab.text = model.cumFilledVolume
    }
    
}
