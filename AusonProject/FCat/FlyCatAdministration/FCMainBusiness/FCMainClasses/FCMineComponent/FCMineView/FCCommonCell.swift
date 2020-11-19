//
//  FCCommonCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/11.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCCommonCell: UITableViewCell {

    @IBOutlet weak var leftIcon: UIImageView!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var describeL: UILabel!
    
    @IBOutlet weak var leftIconWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var arrowsIcon: UIImageView!
    
    @IBOutlet weak var switchBtn: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func switchAction(_ sender: UISwitch) {
        FCUserDefaults.setBool(sender.isOn, ForKey: kSMALLASSETS, synchronize: true)
        
        /**
        if let switchChangeValueBlock = switchChangeValueBlock{
            switchChangeValueBlock(sender)
        }
         */
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
