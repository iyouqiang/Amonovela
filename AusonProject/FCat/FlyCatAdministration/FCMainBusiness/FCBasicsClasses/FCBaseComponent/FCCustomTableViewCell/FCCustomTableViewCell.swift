//
//  FCCustomTableViewCell.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/17.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

typealias SwitchChangeValueBlock = (_ sender: UISwitch, _ title:String?) -> Void

class FCCustomCellModel: NSObject {
    var leftIcon: String?
    var title: String?
    var message: String?
    var rightIcon: String?
    var rightView: UIView?
    var showSwitch: Bool?
    var showSwitchIsOn: Bool?

    init( leftIcon: String? = nil, title: String?, message: String? = nil, rightIcon: String? = nil, rightView: UIView? = nil, showSwitch:Bool? = false, showSwitchIsOn:Bool? = false) {
        super.init()
        self.title = title
        self.leftIcon = leftIcon
        self.message = message
        self.rightIcon = rightIcon
        self.rightView = rightView
        self.showSwitch = showSwitch
        self.showSwitchIsOn = showSwitchIsOn
    }
}

let FCCustomTableViewCellIdentifier = "FCCustomTableViewCellIdentifier"

class FCCustomTableViewCell: UITableViewCell {
    
    var switchChangeValueBlock: SwitchChangeValueBlock?
    var cellTitleStr:String?
    private lazy var cellSwitch: UISwitch? = {
        
         let cellSwitch = UISwitch()
        cellSwitch.tintColor = COLOR_TabBarTintColor
        cellSwitch.onTintColor = COLOR_TabBarTintColor
         cellSwitch.addTarget(self, action: #selector(switchEventChange(_:)), for: .valueChanged)
         return cellSwitch
     }()
    
    @objc func switchEventChange(_ sender: UISwitch) {
        
        if let switchChangeValueBlock = switchChangeValueBlock {
            switchChangeValueBlock(sender, self.cellTitleStr ?? "")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(style: UITableViewCell.CellStyle, reuseIdentifier: String?, leftIcon: String?, title: String?, message: String?, rightIcon: String?, showSwitch:Bool? = false, showSwitchIsOn: Bool? = false) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.cellTitleStr = title
        self.contentView.backgroundColor = COLOR_CellBgColor
        self.selectionStyle = .none
        var leftIconView: UIImageView?
        if (leftIcon != nil) {
            leftIconView = UIImageView.init(image: UIImage.init(named: leftIcon ?? ""))
        }
        let titleLab = fc_labelInit(text: title, textColor: COLOR_CellTitleColor, textFont: 16, bgColor: COLOR_Clear)
        var messageLab: UILabel?
        let arrowImageView = UIImageView.init(image: UIImage.init(named: "cell_arrow_right"))
        
        if (leftIconView != nil) {
            self.contentView.addSubview(leftIconView!)
        }
        self.contentView.addSubview(titleLab)
        if showSwitch == true {
            
            self.contentView.addSubview(self.cellSwitch!)
            self.cellSwitch?.isOn = showSwitchIsOn ?? false
            self.cellSwitch?.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kMarginScreenLR - 15)
                make.size.equalTo(CGSize(width: 30, height: 30))
            }
        }else {
        
            self.contentView.addSubview(arrowImageView)
            arrowImageView.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().offset(-kMarginScreenLR)
                make.size.equalTo(CGSize(width: 16, height: 16))
            }
        }
        
        
        self.contentView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        if let validMsg = message {
            messageLab = fc_labelInit(text: validMsg, textColor: COLOR_CellMessageColor, textFont: 16, bgColor: COLOR_Clear)
            self.contentView.addSubview(messageLab!)
        }

        leftIconView?.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.size.equalTo(CGSize(width: 18, height: 18))
        }
        
        titleLab.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            if (leftIconView != nil) {
                make.left.equalTo(leftIconView!.snp.right).offset(10)
            } else {
                make.left.equalToSuperview().offset(kMarginScreenLR)
            }
            
            make.right.lessThanOrEqualToSuperview()
            make.height.equalToSuperview()
        }

        if let validMsgLab = messageLab {
            self.contentView.addSubview(validMsgLab)
            validMsgLab.snp.makeConstraints { (make) in
                make.centerY.equalToSuperview()
                make.right.equalTo(arrowImageView.snp.left).offset(-15)
                make.left.greaterThanOrEqualTo(titleLab.snp.right).offset(20)
                make.height.equalToSuperview()
            }
        }
    }
    
}
