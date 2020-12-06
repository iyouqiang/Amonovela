//
//  FCHomeAgreementView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

typealias FCClickInviteFriendBlcok = () -> Void
typealias FCClickTradingSkillBlcok = () -> Void

class FCHomeAgreementView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    @IBOutlet weak var tendencyView: UIView!
    @IBOutlet weak var tradingSkillBtn: UIButton!
    @IBOutlet weak var inviteFriendBtn: UIButton!
    @IBOutlet weak var inviteFriendView: UIView!
    @IBOutlet weak var tradingSkillView: UIView!
    var inviteFriendBlock: FCClickInviteFriendBlcok?
    var tradingSkillBlock: FCClickTradingSkillBlcok?
    
    @IBAction func inviteFriendAction(_ sender: Any) {
        
        if let inviteFriendBlock = self.inviteFriendBlock {
            inviteFriendBlock()
        }
    }
    @IBAction func tradingSkillAction(_ sender: Any) {
        
        if let tradingSkillBlock = self.tradingSkillBlock {
            tradingSkillBlock()
        }
    }
    
     
    @IBAction func gotoContractAction(_ sender: Any) {
        
        kAPPDELEGATE?.tabBarViewController.showContractAccount()
    }
    
    override func awakeFromNib() {
        
        self.tradingSkillView.layer.cornerRadius = 5.0
        self.tradingSkillView.backgroundColor = COLOR_HexColor(0x232A3F)
        self.inviteFriendView.layer.cornerRadius = 5.0
        self.inviteFriendView.backgroundColor = COLOR_HexColor(0x232A3F)
        self.tendencyView.layer.cornerRadius = 5.0
        self.tendencyView.backgroundColor = COLOR_HexColor(0x232A3F)
        
        self.backgroundColor = COLOR_BGColor
        
        /// 加入渐变
        let layer = CAGradientLayer()
        layer.frame = self.tendencyView.bounds
        self.tendencyView.clipsToBounds = true
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 0)
        let endColor = COLOR_HexColorAlpha(0x515F7D, alpha: 0.06)
        let starColor = COLOR_HexColorAlpha(0x283147, alpha: 1.0)
        layer.colors = [starColor.cgColor, endColor.cgColor]
        layer.locations = [0, 1]
        self.tendencyView.layer.insertSublayer(layer, at: 0)
        
        let layer1 = CAGradientLayer()
        layer1.frame = self.tradingSkillView.bounds
        self.tradingSkillView.clipsToBounds = true
        layer1.startPoint = CGPoint(x: 0, y: 1)
        layer1.endPoint = CGPoint(x: 1, y: 0)
        layer1.colors = [starColor.cgColor, endColor.cgColor]
        layer1.locations = [0, 1]
        self.tradingSkillView.layer.insertSublayer(layer1, at: 0)
        
        let layer2 = CAGradientLayer()
        layer2.frame = self.inviteFriendView.bounds
        self.inviteFriendView.clipsToBounds = true
        layer2.startPoint = CGPoint(x: 0, y: 1)
        layer2.endPoint = CGPoint(x: 1, y: 0)
        layer2.colors = [starColor.cgColor, endColor.cgColor]
        layer2.locations = [0, 1]
        self.inviteFriendView.layer.insertSublayer(layer2, at: 0)
    }
}
