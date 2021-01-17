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
    var symbolImgView: UIImageView!
    
    lazy var assetsdropDown: DropDown = {
        let dropMoreAssetsDown = DropDown()
        dropMoreAssetsDown.textFont = UIFont.init(_PingFangSCTypeSize: 14)
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
        self.view.backgroundColor = COLOR_PartingLineColor
        
        var navTitle = "提币"
        if assetOptionType == .AssetOptionType_deposit {
            navTitle = "充币"
        }
        
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
    
        let naviTitleView = UIView()
        containerView.addSubview(naviTitleView)
        naviTitleView.backgroundColor = COLOR_navBgColor
        naviTitleView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let naviTitleL = fc_labelInit(text: navTitle, textColor: .white, textFont: UIFont(_PingFangSCTypeSize: 24), bgColor: .clear)
        naviTitleView.addSubview(naviTitleL)
        naviTitleL.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        /// 选择币种
        let selectCurrencyView = UIView()
        selectCurrencyView.backgroundColor = COLOR_PartingLineColor
        containerView.addSubview(selectCurrencyView)
        
        selectCurrencyView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(naviTitleView.snp_bottom)
            make.height.equalTo(60)
        }
        
        let symbolTitleL = UILabel()
        //symbolTitleL.text = "USDT"
        symbolTitleL.font = UIFont(_DINProBoldTypeSize: 17)
        symbolTitleL.textColor = .white
        selectCurrencyView.addSubview(symbolTitleL)
        self.symbolTitleL = symbolTitleL
        
        let symbolImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        selectCurrencyView.addSubview(symbolImgView)
        symbolImgView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(25)
        }
        self.symbolImgView = symbolImgView
        
        symbolTitleL.snp.makeConstraints { (make) in
            
            make.left.equalTo(symbolImgView.snp_right).offset(5)
            make.bottom.top.equalToSuperview()
            make.width.equalTo(100)
        }
        
        let selectedL = UILabel()
        selectedL.text = "选择币种"
        selectedL.textAlignment = .right
        selectedL.font = UIFont(_PingFangSCTypeSize: 16)
        selectedL.textColor = COLOR_MinorTextColor
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
            make.width.equalTo(6)
            make.height.equalTo(10)
            make.centerY.equalTo(selectCurrencyView.snp_centerY)
        }
        
        selectedL.snp.makeConstraints { (make) in
            
            make.right.equalTo(arrowImgView.snp_left).offset(-8)
            make.width.equalTo(100)
            make.centerY.equalTo(selectCurrencyView.snp_centerY)
        }
        
        let lineView = UIView()
        lineView.backgroundColor = .black
        containerView.addSubview(lineView)
        lineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(selectCurrencyView.snp_bottom)
            make.height.equalTo(3)
        }
        
        if assetOptionType == .AssetOptionType_deposit {
            //self.title = "充币"
            
            // 充币界面
            assetChargeView = FCCXPAssetChargeView()
            assetChargeView?.backgroundColor = COLOR_PartingLineColor
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
                //self.title = "提币"
            
            // 提币界面
            assetMentionView = FCCXPAssetMentionView()
            assetMentionView?.backgroundColor = COLOR_PartingLineColor
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
        
        let listVC = FCDigitalListViewController()
        listVC.assetsArry = self.assetsArray
        listVC.modalPresentationStyle = .fullScreen
        self.present(listVC, animated: true) {
            
        }
        
        listVC.callBackItemBlock = { model in
            
            let configModel = model as! FCAllAssetsConfigModel
            
            self.symbolTitleL.text = configModel.asset
            self.symbolImgView.sd_setImage(with: URL(string: configModel.iconUrl), completed: nil)
            /// 配置下拉列表
            if self.assetOptionType == .AssetOptionType_deposit {
                
                self.assetChargeView?.configModel = configModel
                
            }else if (self.assetOptionType == .AssetOptionType_withdraw) {
             
                self.assetMentionView?.configModel = configModel
            }
        }
        //self.assetsdropDown.show()
    }
    
    func configListView(index: Int) {
    
        if assetsArray.count <= index{
            return
        }
        
        let configModel = assetsArray[index]
        
        symbolTitleL.text = configModel.asset
        self.symbolImgView.sd_setImage(with: URL(string: configModel.iconUrl), completed: nil)
        
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
