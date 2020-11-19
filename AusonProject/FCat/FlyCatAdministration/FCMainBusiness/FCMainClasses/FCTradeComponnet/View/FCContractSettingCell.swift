//
//  FCContractSettingCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/26.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractSettingCell: UITableViewCell {

    var arrowImgView:UIImageView!
    var titleL:UILabel!
    var describeL: UILabel!
    var goingLongL: UILabel!
    var shortSellingL: UILabel!
    var longBtn: UIButton!
    var shortBTn: UIButton!
    
    var longLeverageBlock: ((_ leverageType: LeverageType) -> Void)?
    var shortLeverageBlock: ((_ leverageType: LeverageType) -> Void)?
    
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
        
        self.setupView()
        self.backgroundColor = COLOR_BGColor
        self.contentView.backgroundColor = COLOR_BGColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        
        titleL = fc_labelInit(text: "", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        contentView.addSubview(titleL)

        describeL = fc_labelInit(text: "", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        describeL.textAlignment = .right
        contentView.addSubview(describeL)
        
        arrowImgView = fc_imageViewInit(imageName: "cell_arrow_right")
        contentView.addSubview(arrowImgView)
        
        let longLeverage = "\(FCTradeSettingconfig.sharedInstance.longLeverage ?? "0")X 多"
        goingLongL = fc_labelInit(text: longLeverage, textColor: COLOR_tabbarNormalColor, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        goingLongL.textAlignment = .center
        contentView.addSubview(goingLongL)
        goingLongL.layer.cornerRadius = 15
        goingLongL.clipsToBounds = true
        goingLongL.layer.borderWidth = 0.5
        goingLongL.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        longBtn = fc_buttonInit(imgName: "", title: "", fontSize: 16, titleColor: .clear, bgColor: .clear)
        self.contentView.addSubview(longBtn)
        longBtn.addTarget(self, action: #selector(longLeverageAction), for: .touchUpInside)
        longBtn.snp.makeConstraints { (make) in
            
            make.edges.equalTo(goingLongL)
        }
        
        let shortLeverage = "\(FCTradeSettingconfig.sharedInstance.shortLeverage ?? "0")X 空"
        shortSellingL = fc_labelInit(text: shortLeverage, textColor: COLOR_tabbarNormalColor, textFont: UIFont.systemFont(ofSize: 16), bgColor: .clear)
        shortSellingL.textAlignment = .center
        contentView.addSubview(shortSellingL)
        shortSellingL.layer.cornerRadius = 15
        shortSellingL.clipsToBounds = true
        shortSellingL.layer.borderWidth = 0.5
        shortSellingL.layer.borderColor = COLOR_tabbarNormalColor.cgColor
        
        shortBTn = fc_buttonInit(imgName: "", title: "", fontSize: 16, titleColor: .clear, bgColor: .clear)
        shortBTn.addTarget(self, action: #selector(shortLeverageAction), for: .touchUpInside)
        self.contentView.addSubview(shortBTn)
        shortBTn.snp.makeConstraints { (make) in
              
              make.edges.equalTo(shortSellingL)
          }
        
        titleL.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(describeL.snp_left)
            make.top.bottom.equalToSuperview()
        }
        
        arrowImgView.snp.makeConstraints { (make) in
            make.width.height.equalTo(16)
            make.right.equalTo(-15)
            make.centerY.equalToSuperview()
        }
        
        describeL.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImgView.snp_left).offset(-10)
            make.top.bottom.equalTo(0)
            make.width.equalTo(100)
        }
        
        shortSellingL.snp.makeConstraints { (make) in
            
            make.right.equalTo(arrowImgView.snp_left).offset(-5)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        
        goingLongL.snp.makeConstraints { (make) in
            
            make.right.equalTo(arrowImgView.snp_left).offset(-80)
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
    }
    
    var model: FCContractSetModel? {
        
        didSet {
            
            guard let model = model else {
                return
            }
            
            titleL.text = model.title
            describeL.text = model.descriStr
            
            if model.type == 0 {
                
                shortBTn.isEnabled = false
                longBtn.isEnabled = false
                self.describeL.isHidden = false
                self.shortSellingL.isHidden = true
                self.goingLongL.isHidden = true
            }else {
                
                shortBTn.isEnabled = true
                longBtn.isEnabled = true
                self.describeL.isHidden = true
                self.shortSellingL.isHidden = false
                self.goingLongL.isHidden = false
            }
            
            let longLeverage = "\(FCTradeSettingconfig.sharedInstance.longLeverage ?? "0")X 多"
            goingLongL.text = longLeverage
            let shortLeverage = "\(FCTradeSettingconfig.sharedInstance.shortLeverage ?? "0")X 空"
            shortSellingL.text = shortLeverage
        }
    }
    
    @objc func longLeverageAction() {
        
        if let longLeverageBlock = self.longLeverageBlock {
            longLeverageBlock(.LeverageType_long)
        }
    }
    
    @objc func shortLeverageAction() {
        
        if let shortLeverageBlock = self.shortLeverageBlock {
            shortLeverageBlock(.LeverageType_short)
         }
    }
    
}
