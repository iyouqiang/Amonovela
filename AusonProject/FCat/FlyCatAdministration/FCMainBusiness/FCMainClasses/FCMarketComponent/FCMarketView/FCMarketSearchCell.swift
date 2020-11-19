//
//  FCMarketSearchCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/13.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCMarketSearchCell: UITableViewCell {

    var titleL: UILabel!
    var imageIcon: UIImageView!
    var optionalBtn: UIButton!
    
    typealias OptionalBlock = () -> Void
    
    var optionalBlock: OptionalBlock?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
     
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    
        self.titleL = UILabel.init(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH-60, height: 44))
        self.titleL.textColor = COLOR_PrimeTextColor
        self.titleL.text = "BT -Btcdo Token"
        self.titleL.font = UIFont.systemFont(ofSize: 14)
        self.contentView.addSubview(self.titleL)
    
        self.imageIcon = UIImageView.init(frame: CGRect(x: kSCREENWIDTH-35, y: 12, width: 20, height: 20))
        self.imageIcon.image = UIImage(named: "market_optionalSelected")
        self.contentView.addSubview(self.imageIcon)
    
        self.optionalBtn = UIButton(type: .custom)
        self.optionalBtn.frame = CGRect(x: kSCREENWIDTH-50, y: 0, width: 40, height: 40)
        self.optionalBtn.addTarget(self, action: #selector(changeOptionalState), for: .touchUpInside)
        self.contentView.addSubview(self.optionalBtn)
    }
    
    @objc func changeOptionalState() {
        
        if self.optionalBlock != nil {
            self.optionalBlock!()
        }
    }
    
    func configureCell(_ model: FCMarketModel) {
        
//        self.titleL.text = model.symbol! + " - " + model.name!
//
//        if model.fav! {
//
//            self.imageIcon.image = UIImage(named: "hasOptional")
//        }else {
//
//            self.imageIcon.image = UIImage(named: "market_optionalSelected")
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


