//
//  FCDigitalCurrencyCell.swift
//  Auson
//
//  Created by Yochi on 2021/1/14.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit

class FCDigitalCurrencyCell: UITableViewCell {

    var labNmae: UILabel!
    var imgHead: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        
        imgHead = UIImageView(frame: CGRect(x: 15, y: 6, width: 48, height: 48))
        imgHead.layer.cornerRadius = 24
        imgHead.layer.masksToBounds = true
        imgHead.backgroundColor = UIColor.red
        self.addSubview(imgHead)
        
        labNmae = fc_labelInit(text: "小可爱", textColor: COLOR_CellTitleColor, textFont: UIFont(_DINProBoldTypeSize: 14), bgColor: .clear)
        self.addSubview(labNmae)
        
        labNmae.snp_makeConstraints { (make) in
            make.left.equalTo(imgHead.snp_right).offset(5)
            make.centerY.equalTo(imgHead.snp_centerY)
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
