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
        self.inviteFriendView.layer.cornerRadius = 5.0
        self.tendencyView.layer.cornerRadius = 5.0
        self.tendencyView.clipsToBounds = true
        self.backgroundColor = COLOR_BGColor
    }
}
