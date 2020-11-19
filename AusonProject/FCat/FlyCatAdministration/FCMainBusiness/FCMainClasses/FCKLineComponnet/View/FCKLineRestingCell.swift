//
//  FCKLineRestingCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

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
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configCell(index: Int, bidModel: FCKLineDepthModel?, askModel:FCKLineDepthModel?) {
        self.buyRankLab.text = "\(index + 1)"
        self.sellRankLab.text = "\(index + 1)"
        
        //买
        self.buyAmountLab.text = bidModel?.volume
        self.buyPriceLab.text = bidModel?.price
        self.buyDepth.constant = CGFloat(Double(kSCREENWIDTH - 30) * 0.5 * (bidModel?.barPercent ?? 0.0))
        
        //卖
        self.sellAmountLab.text = askModel?.volume
        self.sellPriceLab.text = askModel?.price
        let askWidth = CGFloat(Double(kSCREENWIDTH - 30) * 0.5 * (askModel?.barPercent ?? 0.0))
        self.sellDepth.constant = askWidth
        //CGFloat((Double(kSCREENWIDTH - 30) * 0.5)) - buyWidth
    }
}
