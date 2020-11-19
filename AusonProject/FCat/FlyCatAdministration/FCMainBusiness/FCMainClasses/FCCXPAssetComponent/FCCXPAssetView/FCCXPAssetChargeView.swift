//
//  FCCXPAssetChargeView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

public enum DigitalSymbolType: Int {
    case DigitalSymbolType_epc
    case DigitalSymbolType_cmni
}

class FCCXPAssetChargeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
        
    var assetQRCodeView: FCCXPAssetQRCodeView?
    var digitalSymbolModel: FCCXPAssetDepositModel?
    var explainView: FCCXPChargeInstruView?
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
                
                assetQRCodeView?.EPCBtn.isHidden = false
                assetQRCodeView?.CMNIBtn.isHidden = false
                assetQRCodeView?.chainsTitleL.isHidden = false
                
                UIView.animate(withDuration: 0.3) {
                
                    self.assetQRCodeView?.topGapConstrainsts.constant = 40
                    self.assetQRCodeView?.snp.updateConstraints({ (make) in
                        make.height.equalTo(487)
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
                        //self.explainView?.minTradeNumL.text = "最小充值金额：\(model.depositMinor ?? "0") \(self.digitalSymbolModel?.digitalAsset ?? ""),小于最小金额的充值将不会上账且无法退回。"
                        assetQRCodeView?.EPCBtn.setTitle(model.chainNetwork, for: .normal)
                    }else if (index == 1) {
                        
                        self.seciondChainsModel = model
                        //self.explainView?.minTradeNumL.text = "最小充值金额：\(model.depositMinor ?? "0") \(self.digitalSymbolModel?.digitalAsset ?? ""),小于最小金额的充值将不会上账且无法退回。"
                        assetQRCodeView?.CMNIBtn.setTitle(model.chainNetwork, for: .normal)
                    }
                }
                
            }else {
                
                /// 默认选择第一个
                 
                assetQRCodeView?.EPCBtn.isHidden = true
                assetQRCodeView?.CMNIBtn.isHidden = true
                assetQRCodeView?.chainsTitleL.isHidden = true
                
                UIView.animate(withDuration: 0.3) {
                    self.assetQRCodeView?.topGapConstrainsts.constant = -70
                    self.assetQRCodeView?.snp.updateConstraints({ (make) in
                                      make.height.equalTo(380)
                                  })
                    self.layoutIfNeeded()
                }
            }
            
            let chainsModel = configModel.chains?.first
            self.firstChainsModel = chainsModel
            //self.explainView?.minTradeNumL.text = "最小充值金额：\(chainsModel?.depositMinor ?? "0") \(self.digitalSymbolModel?.digitalAsset ?? ""),小于最小金额的充值将不会上账且无法退回。"
            
            /// 初始化加载数据
            loadDepositData(digitalSymbol: chainsModel?.symbol ?? "")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    
        /// 二维码界面
        assetQRCodeView = Bundle.main.loadNibNamed("FCCXPAssetQRCodeView", owner: nil, options: nil)?.first as? FCCXPAssetQRCodeView
        addSubview(assetQRCodeView!)
        assetQRCodeView?.snp.makeConstraints({ (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(380)
        })
        
        /// 分割线
        let lineView = UIView()
        lineView.backgroundColor = COLOR_TabBarBgColor
        addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            
            make.top.equalTo(assetQRCodeView!.snp_bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(15)
        }
        
        /// 说明
        let explainView = Bundle.main.loadNibNamed("FCCXPChargeInstruView", owner: nil, options: nil)?.first as? FCCXPChargeInstruView
        self.explainView = explainView
        addSubview(explainView!)
        explainView!.snp.makeConstraints { (make) in
            make.top.equalTo(lineView.snp_bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(300)
        }
        
        assetQRCodeView?.digitalSymbolEPCBlock = {
            index in
            if index >= self.configModel?.chains?.count ?? 0 {
                return
            }
            let model = self.configModel?.chains?[index]
            self.loadDepositData(digitalSymbol: model?.symbol ?? "")
        }
    }
    
    func loadDepositData(digitalSymbol : String)
    {
        /**
        var digitalSymbol = "USDT_ERC20"
        if type == .DigitalSymbolType_cmni {
            digitalSymbol = "USDT_OMNI"
        }
         */
        
        let userId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
        let depositApi = FCApi_deposit.init(userId: userId, digitalSymbol: digitalSymbol)
        depositApi.startWithCompletionBlock(success: { [weak self] (response) in
            /// 更新UI数据 
            
            let responseData = response.responseObject as?  [String : AnyObject]
                               
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                              
                if let data = responseData?["data"] as? [String : AnyObject] {
                
                    let model = FCCXPAssetDepositModel.init(dict: data)
                    self?.digitalSymbolModel = model
                    self?.assetQRCodeView?.digitalSymbolModel = model
                    self?.explainView?.symbolDesL.text = "勿向上述地址充值任何非\(model.digitalSymbol ?? "")资产，否则资产将不可找回。"
                    self?.explainView?.minTradeNumL.text = "最小充值金额：\(self?.firstChainsModel?.depositMinor ?? "0") \(model.digitalAsset ?? ""),小于最小金额的充值将不会上账且无法退回。"
                    self?.explainView?.networkConfirmL.text = "您充值至上述地址后，需要整个网络节点的确认，\(model.requiredConfirmationNum ?? "0") 次网络确认后到账，\(model.requiredConfirmationNum ?? "0")次网络确认后可提币。"
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
    
}
