//
//  FCKLineRestingCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import KLineXP

class FCKLineRestingCell: UITableViewCell {

    @IBOutlet weak var buyRankLab: UILabel!
    
    @IBOutlet weak var buyAmountLab: UILabel!
    
    @IBOutlet weak var buyPriceLab: UILabel!
    
    @IBOutlet weak var sellPriceLab: UILabel!
    
    @IBOutlet weak var sellAmountLab: UILabel!
    
    @IBOutlet weak var sellRankLab: UILabel!
    
    @IBOutlet weak var buyDepth: NSLayoutConstraint!
    
    @IBOutlet weak var sellDepth: NSLayoutConstraint!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.contentView.backgroundColor = COLOR_BGColor
        self.backgroundColor = COLOR_BGColor
        self.buyRankLab.font = UIFont(_DINProBoldTypeSize: 12)
        self.buyAmountLab.font = UIFont(_DINProBoldTypeSize: 12)
        self.buyPriceLab.font = UIFont(_DINProBoldTypeSize: 12)
        self.sellPriceLab.font = UIFont(_DINProBoldTypeSize: 12)
        self.sellAmountLab.font = UIFont(_DINProBoldTypeSize: 12)
        self.sellRankLab.font = UIFont(_DINProBoldTypeSize: 12)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(index: Int, bidModel: FCKLineDepthModel?, askModel:FCKLineDepthModel?) {
        self.buyRankLab.text = "\(index + 1)"
        self.sellRankLab.text = "\(index + 1)"
        
        //买
        let bidvolume = ((bidModel?.volume ?? "0.00") as NSString).floatValue
        
        let priceValue = ((bidModel?.price ?? "0.00") as NSString).floatValue
        self.buyAmountLab.text = bidModel?.volume
            //KLineStateManger.manager.precisionSpecification(value: CGFloat(bidvolume))
        self.buyPriceLab.text = KLineStateManger.manager.precisionSpecification(value: CGFloat(priceValue))
            // bidModel?.price
        self.buyDepth.constant = CGFloat(Double(kSCREENWIDTH - 30) * 0.5 * (bidModel?.barPercent ?? 0.0))
        
        //卖
        let askValue = ((askModel?.price ?? "0.00") as NSString).floatValue
        let askvolume = ((askModel?.volume ?? "0.00") as NSString).floatValue
        self.sellAmountLab.text = askModel?.volume
            //KLineStateManger.manager.precisionSpecification(value: CGFloat(askvolume))
        self.sellPriceLab.text = KLineStateManger.manager.precisionSpecification(value: CGFloat(askValue))
        let askWidth = CGFloat(Double(kSCREENWIDTH - 30) * 0.5 * (askModel?.barPercent ?? 0.0))
        self.sellDepth.constant = askWidth
        //CGFloat((Double(kSCREENWIDTH - 30) * 0.5)) - buyWidth
    }
}
