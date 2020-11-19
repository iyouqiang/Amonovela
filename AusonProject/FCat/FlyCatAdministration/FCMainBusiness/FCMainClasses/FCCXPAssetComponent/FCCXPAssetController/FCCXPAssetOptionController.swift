//
//  FCCXPAssetOptionController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import DropDown

public enum AssetOptionType: Int {
    case AssetOptionType_deposit
    case AssetOptionType_withdraw
    case AssetOptionType_all
}

class FCCXPAssetOptionController: UIViewController {

    public var assetOptionType: AssetOptionType?
    var assetChargeView:FCCXPAssetChargeView?
    var assetMentionView:FCCXPAssetMentionView?
    var mainScrollView:UIScrollView?
    var assetsArray = [FCAllAssetsConfigModel]()
    var symbolTitleL: UILabel!
    
    lazy var assetsdropDown: DropDown = {
        let dropMoreAssetsDown = DropDown()
        dropMoreAssetsDown.textFont = UIFont.init(_customTypeSize: 14)
        dropMoreAssetsDown.textColor = COLOR_PrimeTextColor
        dropMoreAssetsDown.cellHeight = 36
        dropMoreAssetsDown.selectionBackgroundColor = .clear
        dropMoreAssetsDown.selectedTextColor = COLOR_PrimeTextColor
        dropMoreAssetsDown.bottomOffset = CGPoint(x: 0, y: 60)
        dropMoreAssetsDown.backgroundColor = COLOR_HexColor(0x232529)
        dropMoreAssetsDown.separatorColor = .clear
        dropMoreAssetsDown.shadowOpacity = 0
        
        return dropMoreAssetsDown

    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        
        /// 配置资产列表 默认显示第一个
        self.requestWalletAllAssetConfig()
        
        /// 资产交易历史记录
        self.addrightNavigationItemImgNameStr("asst_historyIcon", title: nil, textColor: nil, textFont: nil) {
            [weak self] in
            
            let assetHistoryVC = FCCXPAssetHistoryController()
            assetHistoryVC.optionType = self?.assetOptionType
            self?.navigationController?.pushViewController(assetHistoryVC, animated: true)
        }
        
        /// main View
        self.mainScrollView = UIScrollView()
        self.view.addSubview(mainScrollView!)
        self.mainScrollView?.snp.makeConstraints({ (make) in
            make.edges.equalTo(self.view)
        })
        self.mainScrollView?.contentSize = CGSize(width: kSCREENWIDTH, height: kSCREENHEIGHT)
        
        /// 容器
        let containerView = UIView()
        self.mainScrollView?.addSubview(containerView)
    
        /// 选择币种
        let selectCurrencyView = UIView()
        selectCurrencyView.backgroundColor = COLOR_BGColor
        containerView.addSubview(selectCurrencyView)
        
        selectCurrencyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(0)
            make.height.equalTo(60)
        }
        
        let symbolTitleL = UILabel()
        //symbolTitleL.text = "USDT"
        symbolTitleL.font = UIFont.systemFont(ofSize: 16)
        symbolTitleL.textColor = COLOR_ChartAxisColor
        selectCurrencyView.addSubview(symbolTitleL)
        self.symbolTitleL = symbolTitleL
        symbolTitleL.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.bottom.top.equalToSuperview()
            make.width.equalTo(100)
        }
        
        let selectedL = UILabel()
        selectedL.text = "选择币种"
        selectedL.textAlignment = .right
        selectedL.font = UIFont.systemFont(ofSize: 16)
        selectedL.textColor = COLOR_RichBtnTitleColor
        selectCurrencyView.addSubview(selectedL)
        
        let arrowImgView = UIImageView.init(image: UIImage.init(named: "cell_arrow_right"))
        selectCurrencyView.addSubview(arrowImgView)
        
        let selecteAssetsBtn = UIButton(type: .custom)
        selectCurrencyView.addSubview(selecteAssetsBtn)
        selecteAssetsBtn.addTarget(self, action: #selector(showAssetsListAction), for: .touchUpInside)
        self.assetsdropDown.anchorView = selecteAssetsBtn
        selecteAssetsBtn.snp.makeConstraints { (make) in
            make.right.equalTo(arrowImgView.snp_right)
            make.left.equalTo(selectedL.snp_left).offset(33)
            make.top.bottom.equalToSuperview()
        }
        
        self.assetsdropDown.selectionAction = { [weak self] (index: Int, item: String) in
            
            self?.configListView(index: index)
        }
        
        arrowImgView.snp.makeConstraints { (make) in
            
            make.right.equalTo(-15)
            make.width.equalTo(18)
            make.height.equalTo(18)
            make.centerY.equalTo(selectCurrencyView.snp_centerY)
        }
        
        selectedL.snp.makeConstraints { (make) in
            
            make.right.equalTo(arrowImgView.snp_left).offset(-8)
            make.width.equalTo(100)
            make.centerY.equalTo(selectCurrencyView.snp_centerY)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = COLOR_TabBarBgColor
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(selectCurrencyView.snp_bottom)
            make.height.equalTo(15)
        }
        
        if assetOptionType == .AssetOptionType_deposit {
            self.title = "充币"
            
            // 充币界面
            assetChargeView = FCCXPAssetChargeView()
            assetChargeView?.backgroundColor = COLOR_BGColor
            containerView.addSubview(assetChargeView!)
            assetChargeView?.snp.makeConstraints { (make) in
                make.top.equalTo(lineView.snp_bottom)
                make.left.right.bottom.equalToSuperview()
            }
            containerView.snp.makeConstraints { (make) in
                 make.edges.equalToSuperview()
                 make.width.equalTo(kSCREENWIDTH)
                 make.height.equalTo(880)
             }
            
        }else if (assetOptionType == .AssetOptionType_withdraw) {
                self.title = "提币"
            
            // 提币界面
            assetMentionView = FCCXPAssetMentionView()
            assetMentionView?.backgroundColor = COLOR_BGColor
            containerView.addSubview(assetMentionView!)
            assetMentionView?.snp.makeConstraints { (make) in
                make.top.equalTo(lineView.snp_bottom)
                make.left.right.bottom.equalToSuperview()
            }
            
            containerView.snp.makeConstraints { (make) in
                make.edges.equalToSuperview()
                make.width.equalTo(kSCREENWIDTH)
                make.height.equalTo(910)
            }
        }
        
        self.mainScrollView?.snp.makeConstraints({ (make) in
            make.bottom.equalTo(containerView.snp_bottom)
        })
    }
    
    @objc func showAssetsListAction() {
        
        if  self.assetsArray.count == 0 {
            
            self.requestWalletAllAssetConfig()
            return
        }
        
        self.assetsdropDown.show()
    }
    
    func configListView(index: Int) {
    
        if assetsArray.count <= index{
            return
        }
        
        let configModel = assetsArray[index]
        
        symbolTitleL.text = configModel.asset
        
        /// 配置下拉列表
        if assetOptionType == .AssetOptionType_deposit {
            
            self.assetChargeView?.configModel = configModel
            
        }else if (assetOptionType == .AssetOptionType_withdraw) {
         
            self.assetMentionView?.configModel = configModel
        }
    }
    
    func requestWalletAllAssetConfig() {
        
        let configApi = FCApi_wallet_all_asset()
        configApi.startWithCompletionBlock(success: { [weak self] (response) in
            
            self?.assetsArray.removeAll()
            
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                
                let configModel = FCWalletAllConfig.stringToObject(jsonData: resData)
                
                self?.assetsArray = configModel.assets ?? []
                var assetsTitles = [String]()
                guard let assetArray = self?.assetsArray else {
                    return
                }
                
                for (_, model) in assetArray.enumerated() {
                    assetsTitles.append(model.asset ?? "")
                }
                
                self?.assetsdropDown.dataSource = assetsTitles
                
                /// 默认第一个币种
                self?.configListView(index: 0)
                
             }) { (errMsg) in
                 self?.view.makeToast(errMsg ?? "", position: .center)
             }
            
        }) { (response) in
            
        };
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
