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
    weak var parentVC:UIViewController?

    var bannerView: FCBannerCarouselView = {
        
        let width = UIScreen.main.bounds.size.width
        let frame: CGRect = CGRect(x: 15, y: 15.0, width: width-30, height: (150.0/357.0) * kSCREENWIDTH)
        return FCBannerCarouselView(frame: frame)
        
    }()
    
    //var mainBannerView: i
    
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
        columnHeight = (150.0/357.0) * kSCREENWIDTH
        
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
        line1View.backgroundColor = COLOR_TabBarBgColor
        addSubview(line1View)
        line1View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.noticeView!.snp.bottom)
            make.height.equalTo(15)
        }
        
        columnHeight += 15
        
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
            
            if (index == 0) {
                
                let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_NEWGUIDE))!
                webVC.hidesBottomBarWhenPushed = true
                self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
                
            }else if (index == 1) {
                
                FCUserInfoManager.sharedInstance.loginState { (model) in
                    let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_TRADE))!
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
             
                //PCCustomAlert.showAppInConstructionAlert()
                
                let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_CPEEXCHANGE))!
                webVC.hidesBottomBarWhenPushed = true
                self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
            }
        })
        
        addSubview(quickNavView)
        quickNavView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(line1View.snp.bottom)
            make.height.equalTo(110)
        }
        
        columnHeight += 110
        
        let line2View = UIView()
        line2View.backgroundColor = COLOR_TabBarBgColor
        addSubview(line2View)
        line2View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.quickNavView.snp.bottom)
            make.height.equalTo(15)
        }
        
        columnHeight += 15
        
        /// 主流货币
        mainSymbolsView = Bundle.main.loadNibNamed("FCMainSymbolsView", owner: nil, options:     nil)?.first as? FCMainSymbolsView
        addSubview(mainSymbolsView)
        mainSymbolsView.backgroundColor = COLOR_CellBgColor
        mainSymbolsView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(line2View.snp.bottom)
            make.height.equalTo(100)
        }
        
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
            
            klineVC.marketModel = marketModel
            klineVC.hidesBottomBarWhenPushed = true
            self.parentVC?.navigationController?.pushViewController(klineVC, animated: true)
        }
        
        columnHeight += 120
        /// 合约
        agreeMentView = Bundle.main.loadNibNamed("FCHomeAgreementView", owner: nil, options:     nil)?.first as? FCHomeAgreementView
        addSubview(agreeMentView)
        agreeMentView.backgroundColor = COLOR_CellBgColor
        agreeMentView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(self.mainSymbolsView.snp.bottom).offset(15)
            make.height.equalTo(140)
        }
        
        columnHeight += 140
        
        let line3View = UIView()
        line3View.backgroundColor = COLOR_BGColor
        addSubview(line3View)
        line3View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.agreeMentView.snp.bottom)
            make.height.equalTo(15)
        }
        
        columnHeight += 15+20
        
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
            //PCCustomAlert.showAppInConstructionAlert()
            
            let webVC = PCWKWebHybridController.init(url: URL(string: HOSTURL_TRADESKILL))!
            webVC.hidesBottomBarWhenPushed = true
            self?.parentVC?.navigationController?.pushViewController(webVC, animated: true)
             
        }
        
    }
}


