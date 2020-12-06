//
//  FCHomeCompositeView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCHomeCompositeView: UIView {

    var noticeView:FCNoticeView?
    var quickNavView:FCQuickNavView!
    var mainSymbolsView:FCMainSymbolsView!
    var agreeMentView:FCHomeAgreementView!
    var columnHeight: CGFloat = 0.0
    var fastRechangeBtn: UIButton!
    var fastBuyCoinsBtn: UIButton!
    weak var parentVC:UIViewController?


    var bannerView: FCBannerCarouselView = {
        
        let width = UIScreen.main.bounds.size.width * (2/3)
        let frame: CGRect = CGRect(x: 15, y: 15.0, width: width, height: (502 * width)/553)
        return FCBannerCarouselView(frame: frame)
    }()
    
    var homedataModel:FCHomeModel? {
        
        didSet {
            guard let homedataModel = homedataModel else {
                return
            }
            /// 数据不一致时 刷新banner界面数据
            
            var imageurls = [String]()
            if let bannersArray = homedataModel.bannersArray {
                
                for model in bannersArray {
                    
                    imageurls.append(model.picUrl ?? "")
                }
                self.bannerView.dataSource = Array(imageurls)
            }

            /// 刷新通知栏书籍
            if let noticeModelArray = homedataModel.noticesArray {
                self.noticeView?.dataSource = noticeModelArray
            }
            
            /// 快捷导航
            
            // 主流货币
            if let mainSymbolsArray = homedataModel.mainSymbolsArray {
                self.mainSymbolsView?.dataSource = mainSymbolsArray
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubviews() {
        
        self.backgroundColor = COLOR_BGColor
        
        /// banner位置
        addSubview(self.bannerView)
        self.bannerView.backgroundColor = .clear
        self.bannerView.layer.cornerRadius = 10
        self.bannerView.clipsToBounds = true
        columnHeight = bannerView.frame.height //(150.0/357.0) * kSCREENWIDTH
        
        bannerView.didSelectedItemBlock = {
           [weak self] index in
            if let bannersArray = self?.homedataModel?.bannersArray {
                   
                let bannerModel = bannersArray[index]
                   
                if bannerModel.linkUrl?.count ?? 0 > 0 {
                    
                    let webVC = PCWKWebHybridController.init(url: URL(string: bannerModel.linkUrl ?? ""))!
                    webVC.hidesBottomBarWhenPushed = true
                    self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
                }
            }
        }
        
        /// 快捷买币 充币
        self.fastBuyCoinsBtn = fc_buttonInit(imgName: "home_fastrechange", title: "快捷买币", fontSize: 16, titleColor: UIColor.white, bgColor: COLOR_HexColor(0x232A3F))
        self.fastBuyCoinsBtn.addTarget(self, action: #selector(fastBuyCoinsAction), for: .touchUpInside)
        self.fastBuyCoinsBtn.layer.cornerRadius = 8
        self.fastBuyCoinsBtn.clipsToBounds = true
        self.addSubview(self.fastBuyCoinsBtn)
        let itemwidth = kSCREENWIDTH*(1/3.0) - 15*3
        self.fastBuyCoinsBtn.frame = CGRect(x: 0, y: 0, width: itemwidth, height: bannerView.frame.height/2.0 - 8)
        let imageSize:CGSize = fastBuyCoinsBtn.imageView!.frame.size
        let titleSize:CGSize = fastBuyCoinsBtn.titleLabel!.frame.size
        fastBuyCoinsBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left:-imageSize.width, bottom: -imageSize.height - 5, right: 0)
        fastBuyCoinsBtn.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - 5, left: 0, bottom: 0, right: -titleSize.width - 10)
        
        self.fastRechangeBtn = fc_buttonInit(imgName: "home_fastrechange", title: "快速充币", fontSize: 16, titleColor: UIColor.white, bgColor: COLOR_HexColor(0x232A3F))
        self.fastRechangeBtn.addTarget(self, action: #selector(fastRechangeAction), for: .touchUpInside)
        self.fastRechangeBtn.layer.cornerRadius = 8
        self.fastRechangeBtn.clipsToBounds = true
        self.addSubview(self.fastRechangeBtn)
        self.fastRechangeBtn.frame = CGRect(x: 0, y: 0, width: itemwidth, height: bannerView.frame.height/2.0 - 8)
        fastRechangeBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left:-imageSize.width, bottom: -imageSize.height - 5, right: 0)
        fastRechangeBtn.imageEdgeInsets = UIEdgeInsets(top: -titleSize.height - 5, left: 0, bottom: 0, right: -titleSize.width - 10)
        
        self.fastRechangeBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.bannerView.snp_right).offset(15)
            make.top.equalTo(self.bannerView.snp_top)
            make.right.equalTo(-15)
            make.height.equalTo((self.bannerView.frame.height/2.0 - 8))
        }
        
        self.fastBuyCoinsBtn.snp_makeConstraints { (make) in
            make.left.equalTo(self.bannerView.snp_right).offset(15)
            make.top.equalTo(self.fastRechangeBtn.snp_bottom).offset(15)
            make.right.equalTo(-15)
            make.height.equalTo(self.fastRechangeBtn.snp_height)
        }
        
        /// 跑马灯
        noticeView = FCNoticeView()
        noticeView?.backgroundColor = COLOR_CellBgColor
        addSubview(noticeView!)
        noticeView?.snp.makeConstraints({ (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.bannerView.snp.bottom).offset(15)
            make.height.equalTo(60)
        })
        
        columnHeight += 60
        
        /// 分割线
        let line1View = UIView()
        line1View.backgroundColor = COLOR_HexColor(0x13151A)
        addSubview(line1View)
        line1View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.noticeView!.snp.bottom)
            make.height.equalTo(8)
        }
        
        columnHeight += 8
        
        /// 快捷导航
        var items: [FCAlertItemModel] = []
        let  titles = ["新手指南", "快捷买币", "充币", "平台介绍"]
        let imageNames = ["home_navguide", "home_navwallet", "home_navcoin", "home_navplatdes"]
        let itemEnables = [true, true, true, true]
        for i in 0..<titles.count {
            let model = FCAlertItemModel(title: titles[i], imageName: imageNames[i], isEnabled: itemEnables[i])
            items.append(model)
        }
        quickNavView = FCQuickNavView.init(items: items, clickItemAction: {[weak self] (itemModel, index) in
            
            if (index == 1) {
                
                FCUserInfoManager.sharedInstance.loginState { (model) in
                    let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_EASYTRADE))!
                    webVC.hidesBottomBarWhenPushed = true
                    self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
                }
    
            } else if (index == 2) {
                
                FCUserInfoManager.sharedInstance.loginState { (model) in
                    let assetVC = FCCXPAssetOptionController()
                    assetVC.assetOptionType = .AssetOptionType_deposit
                    assetVC.hidesBottomBarWhenPushed = true
                    self?.parentVC?.navigationController?.pushViewController(assetVC, animated: true)
                }
            }else {
             
                PCCustomAlert.showAppInConstructionAlert()
                /**
                let webVC = PCWKWebHybridController.init(url: URL(string: "http://www.baidu.com"))!
                webVC.hidesBottomBarWhenPushed = true
                self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
                 */
                
                //self?.shareCXPEvent("test", UIImage(named: "asset_ filtrate")!, URL(string: "http://www.baidu.com")!)
            }
        })
        
        addSubview(quickNavView)
        quickNavView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(line1View.snp.bottom)
            make.height.equalTo(110)
        }
        
        self.quickNavView.isHidden = true
        //columnHeight += 110
        
        let line2View = UIView()
        line2View.backgroundColor = COLOR_TabBarBgColor
        addSubview(line2View)
        line2View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(noticeView!.snp.bottom)
            make.height.equalTo(8)
        }
        line2View.isHidden = true
        //columnHeight += 8
        
        /// 主流货币
        mainSymbolsView = Bundle.main.loadNibNamed("FCMainSymbolsView", owner: nil, options:     nil)?.first as? FCMainSymbolsView
        addSubview(mainSymbolsView)
        mainSymbolsView.backgroundColor = COLOR_CellBgColor
        mainSymbolsView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(line1View.snp.bottom)
            make.height.equalTo(120)
        }
        mainSymbolsView.isHidden = true
        mainSymbolsView.clickColumnItem = {
            (index, symbolModel) in
            
            let klineVC = FCKLineController()
            let marketModel = FCMarketModel()
            marketModel.symbol = symbolModel.symbol
            marketModel.marketType = symbolModel.marketType ?? ""
            marketModel.latestPrice = symbolModel.latestPrice ?? ""
            marketModel.close = symbolModel.close ?? ""
            marketModel.high = symbolModel.high ?? ""
            marketModel.low = symbolModel.low ?? ""
            marketModel.tradingType = symbolModel.tradingType ?? ""
            marketModel.amount = symbolModel.tradingAmount ?? ""
            marketModel.changePercent = symbolModel.changePercent ?? ""
            marketModel.name = symbolModel.name ?? ""
            
            klineVC.marketModel = marketModel
            klineVC.hidesBottomBarWhenPushed = true
            self.parentVC?.navigationController?.pushViewController(klineVC, animated: true)
        }
        
        //columnHeight += 120
        
        /// 合约
        let agreeMentViewline = UIView()
        agreeMentViewline.backgroundColor = COLOR_HexColor(0x13151A)
        addSubview(agreeMentViewline)
        agreeMentViewline.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(mainSymbolsView.snp.bottom)
            make.height.equalTo(8)
        }
        agreeMentViewline.isHidden = true
        
        agreeMentView = Bundle.main.loadNibNamed("FCHomeAgreementView", owner: nil, options:     nil)?.first as? FCHomeAgreementView
        addSubview(agreeMentView)
        agreeMentView.backgroundColor = COLOR_CellBgColor
        agreeMentView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(line1View.snp.bottom)
            make.height.equalTo(140)
        }
        
        columnHeight += 140
        
        let line3View = UIView()
        line3View.backgroundColor = COLOR_HexColor(0x13151A)
        addSubview(line3View)
        line3View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.agreeMentView.snp.bottom)
            make.height.equalTo(8)
        }
        
        columnHeight += 58
        
        configureAction()
    }
    
    func shareCXPEvent(_ text:String, _ image: UIImage, _ url: URL) {
        
        let items = [text, image, url] as [Any]
        
        let activeityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activeityVC.excludedActivityTypes = [];
        
        self.parentVC?.present(activeityVC, animated: true, completion: {
            
            
        })
        
        activeityVC.completionWithItemsHandler = {
            activityType, completed, returnedItems, activityError in
              
        }
        
    }
    
    @objc func fastRechangeAction()
    {
        FCUserInfoManager.sharedInstance.loginState { (model) in
            let assetVC = FCCXPAssetOptionController()
            assetVC.assetOptionType = .AssetOptionType_deposit
            assetVC.hidesBottomBarWhenPushed = true
            self.parentVC?.navigationController?.pushViewController(assetVC, animated: true)
        }
    }
    
    @objc func fastBuyCoinsAction() {

        FCUserInfoManager.sharedInstance.loginState { (model) in
            let assetVC = FCCXPAssetOptionController()
            assetVC.assetOptionType = .AssetOptionType_deposit
            assetVC.hidesBottomBarWhenPushed = true
            self.parentVC?.navigationController?.pushViewController(assetVC, animated: true)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
}

extension FCHomeCompositeView {
    
    func configureAction() {
        
        /// 通告栏
        noticeView?.clickNoticeAction = {
          [weak self]  index in
            if let noticesArray = self?.homedataModel?.noticesArray {
                let noticeModel = noticesArray[index]
                let webVC = PCWKWebHybridController.init(url: URL(string: noticeModel.linkUrl ?? ""))!
                webVC.hidesBottomBarWhenPushed = true
                self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
            }
        }
        
        // 合约
        agreeMentView.inviteFriendBlock = {
            [weak self] in
            
            FCUserInfoManager.sharedInstance.loginState { (model) in
                
                let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_INVITE))!
                webVC.hidesBottomBarWhenPushed = true
                self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
            }

        }
        
        agreeMentView.tradingSkillBlock = {
            [weak self] in
            PCCustomAlert.showAppInConstructionAlert()
            /**
            let webVC = PCWKWebHybridController.init(url: URL(string: "http://www.baidu.com"))!
            webVC.hidesBottomBarWhenPushed = true
            self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
             */
        }
        
    }
}


