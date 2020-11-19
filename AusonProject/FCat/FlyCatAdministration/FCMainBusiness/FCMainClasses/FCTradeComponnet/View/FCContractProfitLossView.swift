//
//  FCContractProfitLossView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/10/12.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractProfitLossView: UIView {
     
    /// 止盈
    lazy var stopLossView: FCProfitLossInputView = {
        let stopLossView = FCProfitLossInputView()
        stopLossView.priceTxd.placeholder = "止损价"
        return stopLossView
    }()
    
    /// 止损
    lazy var stopProfitView : FCProfitLossInputView = {
        let stopProfitView = FCProfitLossInputView()
        stopProfitView.priceTxd.placeholder = "止盈价"
        return stopProfitView
    }()
         
    /// 止盈止损
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        setUp()
    }
    
    func setUp() {
        
        self.backgroundColor = COLOR_BGColor
        self.addSubview(self.stopProfitView)
        self.addSubview(self.stopLossView)
        
        /// 75
        self.stopLossView.snp.makeConstraints { (make) in
            
            make.left.top.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        self.stopProfitView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(self.stopLossView.snp_bottom).offset(10)
            make.height.equalTo(44)
        }
    }
    
    required init?(coder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
