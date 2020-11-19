//
//  FCMarketViewController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/5.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit
//import Toast_Swift
import RxSwift
import RxCocoa


class FCMarketViewController: UIViewController {
    
    var segmentControl: FCSegmentControl!
    var segmentContainer: UIView!
    var sortComponent: FCSortComponent!
    var marketScroller: UIScrollView!
    var typeModel: FCMarketTypesModel?
    var marketTypes: [String]?
    var marketList: [FCMarketListController]?
    var webSocket: PCWebSocketNetwork?
    
    deinit {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "行情"
        self.view.backgroundColor = COLOR_SectionFooterBgColor
        //self.adjuestInsets()
        
        //登入登出通知
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogin))
            .takeUntil(self.rx.deallocated)
            .subscribe { [weak self] _ in
                DispatchQueue.main.async {
                    self?.segmentControl.setSelected(0)
                    self?.marketScroller.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
                }
        }
        
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogout))
            .takeUntil(self.rx.deallocated)
            .subscribe { [weak self]  _ in
                DispatchQueue.main.async {
                    
                    if self?.segmentControl == nil {
                        return
                    }
                    self?.segmentControl.setSelected(1)
                    self?.marketScroller.setContentOffset(CGPoint(x: kSCREENWIDTH, y: 0) , animated: true)
                }
        }
        
        //获取交易市场种类列表
        fetchMarketTypes()
    }
    
    func loadSubViews () {
        loadSegmentControl()
        loadSortComponnet()
        loadMarketListView()
    }
    
    func loadSegmentControl () {
        
        self.marketTypes = NSMutableArray.init() as? [String]
        
        for typeItem in self.typeModel?.marketTypes ?? [] {
            self.marketTypes?.append(typeItem.name ?? "")
        }
        
        self.segmentContainer = UIView.init(frame: .zero)
        self.segmentContainer.backgroundColor = COLOR_CellBgColor
        self.segmentControl = FCSegmentControl.init(frame: CGRect.zero)
        segmentControl?.itemSpace = 25
        segmentControl?.setTitles(titles: self.marketTypes ?? [], fontSize: 16, normalColor: COLOR_MinorTextColor, tintColor: COLOR_ThemeBtnEndColor, showUnderLine: true)
        segmentControl.backgroundColor = COLOR_navBgColor
        self.segmentContainer.addSubview(self.segmentControl!)
        self.view.addSubview(self.segmentContainer)
        
        self.segmentControl.didSelectedItem { [weak self] (index: Int) in
            self?.marketScroller.setContentOffset(CGPoint(x: kSCREENWIDTH * CGFloat(index), y: 0) , animated: false)
            let marketlistVC = self?.marketList?[index]
            marketlistVC?.requestlistData()
        }
        
        self.segmentContainer.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(50)
        }
        
        self.segmentControl.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(kMarginScreenLR)
            make.height.equalToSuperview()
        }
    }
    
    func loadSortComponnet () {
        self.sortComponent = FCSortComponent.init(frame: .zero)
        self.sortComponent.backgroundColor = COLOR_CellBgColor
        self.view.addSubview(self.sortComponent)
        
        self.sortComponent.orderBtnClick { [weak self] (sortType: FCMarketSortType, orderType: FCMarketOrderType) in
            for marketVC in self?.marketList ?? [] {
                marketVC.sortMarketList(sortType: sortType, orderType: orderType)
            }
        }
        
        self.sortComponent.snp.makeConstraints { (make) in
            make.top.equalTo(self.segmentContainer.snp.bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func loadMarketListView() {
        
        let marketScroller: UIScrollView = UIScrollView.init(frame: CGRect(x: 0, y: 50 + 10 + 40, width: kSCREENWIDTH, height: (kSCREENHEIGHT-kNAVIGATIONHEIGHT-kTABBARHEIGHT - 100)))
        marketScroller.delegate = self
        marketScroller.isPagingEnabled = true
        marketScroller.showsVerticalScrollIndicator = false
        marketScroller.showsHorizontalScrollIndicator = false
        marketScroller.contentSize = CGSize(width: 3*kSCREENWIDTH, height: marketScroller.frame.height)
        marketScroller.contentOffset = CGPoint(x: kSCREENWIDTH, y: 0)
        self.view.addSubview(marketScroller)
        self.marketScroller = marketScroller
        
        self.marketList = NSMutableArray.init() as? [FCMarketListController]
        for index in 0..<(self.typeModel?.marketTypes ?? []).count {
            let typeItem = self.typeModel?.marketTypes?[index]
            let marketVC = FCMarketListController()
            marketVC.marketType = typeItem?.type ?? "Spot"
            marketVC.view.frame = CGRect(x: kSCREENWIDTH * CGFloat(index), y: 0, width: kSCREENWIDTH, height: marketScroller.frame.height)
            marketVC.isOptional = typeItem?.type == "Optional"
            self.marketScroller.addSubview(marketVC.view)
            typeItem?.type == "Optional" ? marketVC.configureOptionalView() :  marketVC.configureAllView()
            marketVC.marketType = typeItem?.type ?? ""
            marketVC.parentController = self
            self.marketList?.append(marketVC)
        }
        marketScroller.contentSize = CGSize(width: CGFloat((self.marketList?.count ?? 1))*kSCREENWIDTH, height: marketScroller.frame.height)
    }
    
    
    func fetchMarketTypes () {
        let typeApi = FCApi_MarketTypes.init()
        typeApi.startWithCompletionBlock(success: { (response) in
            
            if response.responseCode == 0 {
                let result = response.responseObject as? [String : AnyObject]
                if let validResult = result?["data"] as? [String : Any] {
                    self.typeModel = FCMarketTypesModel.stringToObject(jsonData: validResult)
                    self.loadSubViews()
                }
                
            } else{
                
                self.view.makeToast(response.responseMessage, position: .center)
            }
            
        }) { (response) in
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
}

extension FCMarketViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.x
        self.segmentControl.setSelected(Int(offset/kSCREENWIDTH))
    }
    
}

