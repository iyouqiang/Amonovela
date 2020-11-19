//
//  FCCXPAssetMentionView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCCXPAssetMentionView: UIView {

    var assetConfigModel: FCCXPAssetConfigModel?
    var mentionCoinView: FCCXPMentionCoinSubView?
    var accountNumberL: UILabel!
    var explainView: FCCXPMentionInstruView?
    var accountNumL: UILabel!
    var firstChainsModel: FCChainsModel?
    var seciondChainsModel: FCChainsModel?
    
    var configModel: FCAllAssetsConfigModel? {
        
        didSet {
            
            guard let configModel = configModel else {
                return
            }
            
            /// 界面配置
            if configModel.chains?.count ?? 0 > 1 {
                /// 只有一个链接币，不展示选择按钮
                
                mentionCoinView?.EPCBtn.isHidden = false
                mentionCoinView?.CMNIBtn.isHidden = false
                mentionCoinView?.chainsTitleL.isHidden = false
                
                UIView.animate(withDuration: 0.3) {
                    self.mentionCoinView?.topGapConstraint.constant = 30
                    self.mentionCoinView?.snp.updateConstraints({ (make) in
                        make.height.equalTo(467)
                    })
                    
                    self.layoutIfNeeded()
                }
                /// 左边的 20 右边 mini
                
                guard let chains = configModel.chains else {
                    return
                }
                for (index, model) in chains.enumerated() {
                    
                    if index == 0 {
                        
                        self.firstChainsModel = model
                        mentionCoinView?.EPCBtn.setTitle(model.chainNetwork, for: .normal)
                    }else if (index == 1) {
                        
                        self.seciondChainsModel = model
                        mentionCoinView?.CMNIBtn.setTitle(model.chainNetwork, for: .normal)
                    }
                }
                
            }else {
                
                /// 默认选择第一个
                 
                mentionCoinView?.EPCBtn.isHidden = true
                mentionCoinView?.CMNIBtn.isHidden = true
                mentionCoinView?.chainsTitleL.isHidden = true
                
                UIView.animate(withDuration: 0.3) {
                    self.mentionCoinView?.topGapConstraint.constant = -70
                    self.mentionCoinView?.snp.updateConstraints({ (make) in
                        make.height.equalTo(380)
                    })
                    
                    self.layoutIfNeeded()
                }
            }
            
            let chainsModel = configModel.chains?.first
            self.firstChainsModel = chainsModel
            /// 到账数量
            self.accountNumL.text = "0.0000 \(configModel.asset ?? "")"
             let attrStr = NSMutableAttributedString.init(string: accountNumL.text ?? "")
             attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_HexColor(0xdadada), range:NSRange.init(location:0, length: "0.0000".count ))
             accountNumL.attributedText = attrStr
            
            self.resetinfo()
            
            /// 初始化加载数据
            loadWalletConfigInfo(symbol: chainsModel?.symbol ?? "")
            
            loadUserSingleAsset(asset: configModel.asset ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        mentionCoinView = Bundle.main.loadNibNamed("FCCXPMentionCoinSubView", owner: nil, options: nil)?.first as? FCCXPMentionCoinSubView
        addSubview(mentionCoinView!)
        mentionCoinView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(380)
        })
        
        let lineView = UIView()
        lineView.backgroundColor = COLOR_TabBarBgColor
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            
            make.top.equalTo(mentionCoinView!.snp_bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        explainView = Bundle.main.loadNibNamed("FCCXPMentionInstruView", owner: nil, options: nil)?.first as? FCCXPMentionInstruView
        addSubview(explainView!)
        explainView!.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(160)
        }
        
        // 到账数据
        let accountL = UILabel.init()
        accountL.text = "到账数量"
        accountL.font = UIFont.systemFont(ofSize: 14)
        accountL.textColor = COLOR_HexColor(0x6A6A6E)
        accountL.textAlignment = .left
        addSubview(accountL)
        
        accountL.snp.makeConstraints { (make) in
            
            make.top.equalTo(explainView!.snp_bottom).offset(40)
            make.left.equalTo(15)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        // 提币
        let accountNumL = UILabel.init()
        accountNumL.font = UIFont.systemFont(ofSize: 14)
        accountNumL.textAlignment = .right
        accountNumL.textColor = COLOR_HexColor(0x6A6A6E)
        accountNumL.text = "0.000000 USDT"
        addSubview(accountNumL)
        self.accountNumL = accountNumL
        
         let attrStr = NSMutableAttributedString.init(string: accountNumL.text ?? "")
         attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_HexColor(0xdadada), range:NSRange.init(location:0, length: "0.000000".count ))
         accountNumL.attributedText = attrStr
        
        accountNumL.snp.makeConstraints { (make) in
            make.centerY.equalTo(accountL.snp_centerY)
            make.right.equalTo(-15)
            make.height.equalTo(30)
            make.left.equalTo(accountL.snp_right)
        }
        
        // 渲染按钮
        let configurBtn = FCThemeButton()
        configurBtn.layer.cornerRadius = 5
        configurBtn.clipsToBounds = true
        configurBtn.setTitle("提币", for: .normal)
        configurBtn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        configurBtn.addTarget(self, action: #selector(mentionCoinAffirmAction), for: .touchUpInside)
        configurBtn.setTitleColor(COLOR_HexColor(0x141419), for: .normal)
        addSubview(configurBtn)
        configurBtn.snp.makeConstraints { (make) in
            
            make.top.equalTo(accountNumL.snp_bottom).offset(20)
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.height.equalTo(50)
        }
        
        mentionCoinView?.digitalSymbolEPCBlock = {
            index in
            
            if index >= self.configModel?.chains?.count ?? 0 {
                return
            }
            
            /// 切换输入框清空
            self.resetinfo()
            
            let model = self.configModel?.chains?[index]
            self.loadWalletConfigInfo(symbol: model?.symbol ?? "")
            self.loadUserSingleAsset(asset: self.configModel?.asset ?? "")
        }
        
        mentionCoinView?.digitalWithdrawalRealNumBlock = {
            
            (accountNum) in
            
            let accountStr = "\(accountNum)"
            accountNumL.text = "\(accountNum) \(self.configModel?.asset ?? "")"
            
            let attrStr = NSMutableAttributedString.init(string: accountNumL.text ?? "")
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_HexColor(0xdadada), range:NSRange.init(location:0, length: accountStr.count ))
            accountNumL.attributedText = attrStr
        }
        
        /// 初始化加载数据
        // self.loadWalletConfigInfo(symbol: "USDT_ERC20")
    }
    
    func resetinfo() {
        
        self.mentionCoinView?.mentionAddressTextfield.text = ""
        self.mentionCoinView?.mentionNumTextfield.text = ""
        self.accountNumL.text = "0.0000 \(self.configModel?.asset ?? "")"
         let attrStr = NSMutableAttributedString.init(string: accountNumL.text ?? "")
         attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_HexColor(0xdadada), range:NSRange.init(location:0, length: "0.0000".count ))
         accountNumL.attributedText = attrStr
    }
    
    @objc func mentionCoinAffirmAction()
    {
        // 资产符号，注意USDT类型，如果是OMNI的，资产符号为USDT_OMNI，如果是ERC20的，资产符号为USDT_ERC20
        
        //if let digitalAddress = self.mentionCoinView?.mentionAddressTextfield.text {
          
        guard let digitalAddress = self.mentionCoinView?.mentionAddressTextfield.text else {
            self.makeToast("请输入提币地址")
            return
        }
        
        guard let digitalSymbol = self.assetConfigModel?.symbol else {
             return
         }
        
        guard let volume = self.mentionCoinView?.mentionNumTextfield.text else {
            self.makeToast("请输入提币数量")
             return
         }
        
        let userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
        let affirApi = FCApi_withdrawal.init(userId: userId, digitalSymbol: digitalSymbol, digitalAddress: digitalAddress, volume: volume)
        affirApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                 
                self?.makeToast("提现成功")
                /**
                if let data = responseData?["data"] as? [String : AnyObject] {

                }
                 */
                self?.loadUserSingleAsset(asset: self?.configModel?.asset ?? "")
                return
            }
            
            let errMsg = responseData?["err"]?["msg"] as? String
            self?.makeToast(errMsg ?? "", position: .center)
            
        }) { (response) in
            
            ///错误提示
            let responseData = response.responseObject as?  [String : AnyObject]
            let errMsg = responseData?["err"]?["msg"] as? String
            self.makeToast(errMsg ?? "", position: .center)
        }
    }
    
    func loadUserSingleAsset(asset: String){
        
        //let singleApi = FCApi_single_asset
        
        let singleApi = FCApi_single_asset.init(asset: asset)
        singleApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                if let data = responseData?["data"] as? [String : AnyObject] {

                    /// 资产数据更新
                    guard let assetDic = data["asset"] else {
                        return
                    }
                    
                    let availableStr = assetDic["available"] as? String
                
                    let availableBalanceStr = "可用 \(availableStr ?? "0.00") \(self?.configModel?.asset ?? "")"
                    let attrStr = NSMutableAttributedString.init(string: availableBalanceStr)
                    attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value:COLOR_tabbarNormalColor, range:NSRange.init(location:3, length: availableStr?.count ?? 4 ))
                    self?.mentionCoinView?.availableBalanceL.attributedText = attrStr
                }
                 
                return
            }
            
            let errMsg = responseData?["err"]?["msg"] as? String
            self?.makeToast(errMsg ?? "", position: .center)
            
        }) { (response) in
           
            ///错误提示
            let responseData = response.responseObject as?  [String : AnyObject]
            let errMsg = responseData?["err"]?["msg"] as? String
            self.makeToast(errMsg ?? "", position: .center)
        }
    }
    
    func loadWalletConfigInfo(symbol: String) {
        //BTC, ETH, USDT_OMNI, USDT_ERC20
        let configApi = FCApi_wallet_config.init(symbol: symbol)
        configApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                                        
                if let data = responseData?["data"] as? [String : AnyObject] {
                          
                    if let configdata = data["config"] as? [String : AnyObject] {
                        
                        let model = FCCXPAssetConfigModel.init(dict: configdata)
                        self?.assetConfigModel = model
                        self?.mentionCoinView?.assetConfigModel = model
                        let withdrawalMinor = "最小提币数量 \(self?.firstChainsModel?.withdrawalMinor ?? "0")"
                        self?.explainView?.minConfirmationL.text = withdrawalMinor
                        self?.mentionCoinView?.mentionNumTextfield.placeholder = withdrawalMinor
                    }
                }
            }
                      
        }) { (response) in
                  
            ///错误提示
            let responseData = response.responseObject as?  [String : AnyObject]
            let errMsg = responseData?["err"]?["msg"] as? String
            self.makeToast(errMsg ?? "", position: .center)
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
