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
import JXSegmentedView

class FCMarketViewController: UIViewController {
    
    var segmentControl: FCSegmentControl!
    var segmentContainer: UIView!
    var sortComponent: FCSortComponent!
    var marketScroller: UIScrollView!
    var typeModel: FCMarketTypesModel?
    var marketTypes: [String]?
    var marketList: [FCMarketListController]?
    var webSocket: PCWebSocketNetwork?
    var searchTextField: UITextField!
    var navimaskView: UIView!
    var cancelBtn: UIButton!

    /// 头部选择标签
    var segmentedDataSource = JXSegmentedTitleDataSource()
    let segmentedView = JXSegmentedView()
    lazy var listContainerView: JXSegmentedListContainerView! = {
        return JXSegmentedListContainerView(dataSource: self)
    }()
    
    deinit {
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        listContainerView.frame = CGRect(x: 0, y: 120 + 40 + 45 + 24, width: kSCREENWIDTH, height: kSCREENHEIGHT - 217 - kTABBARHEIGHT)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.title = "行情"
        self.view.backgroundColor = COLOR_BGColor
        self.navigationController?.delegate = self
        
        loadNavigationSearchView()
        
        //登入登出通知
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogin))
            .takeUntil(self.rx.deallocated)
            .subscribe { [weak self] _ in
                DispatchQueue.main.async {
                    self?.segmentedView.selectItemAt(index: 0)
                    //self?.segmentControl.setSelected(0)
                    //self?.marketScroller.setContentOffset(CGPoint(x: 0, y: 0) , animated: true)
                }
        }
        
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUserLogout))
            .takeUntil(self.rx.deallocated)
            .subscribe { [weak self]  _ in
                DispatchQueue.main.async {
                    
                    if self?.segmentControl == nil {
                        return
                    }
                    self?.segmentedView.selectItemAt(index: 1)
                    //self?.segmentControl.setSelected(1)
                    //self?.marketScroller.setContentOffset(CGPoint(x: kSCREENWIDTH, y: 0) , animated: true)
                }
        }
        
        //获取交易市场种类列表
        fetchMarketTypes()
    }
    
    func loadNavigationSearchView() {
        
        let leftView = UIView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
        leftView.backgroundColor = .clear
        
        let imagView = UIImageView(frame: CGRect(x: 0, y: 0, width: 21, height: 21))
        imagView.image = UIImage(named: "market_search")
        imagView.center = leftView.center
        leftView.addSubview(imagView)
        
        let searchView = UITextField(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH - 30, height: 38))
        searchView.delegate = self
        searchView.layer.cornerRadius = 5
        searchView.leftView = leftView
        //searchView.placeholder = "搜索"
        searchView.font = UIFont(_customTypeSize: 14)
        searchView.textColor = COLOR_MinorTextColor
        searchView.backgroundColor = COLOR_HexColor(0x22283A)
        searchView.borderStyle = .none
        searchView.returnKeyType = .search
        searchView.leftViewMode = .always
        searchView.textAlignment = .left
        searchView.attributedPlaceholder = NSAttributedString.init(string:"搜索", attributes: [NSAttributedString.Key.foregroundColor:COLOR_HexColor(0x6E7E97)])
        self.searchTextField = searchView
        searchView.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        let navigationView = UIView()
        navigationView.backgroundColor = .clear
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.width.equalTo(kSCREENWIDTH)
            make.height.equalTo(120)
        }
        
        self.navimaskView = UIView()
        self.navimaskView?.backgroundColor = COLOR_HexColor(0x131829)
        self.navimaskView?.alpha = 1.0
        navigationView.addSubview(self.navimaskView!)
        self.navimaskView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        /// 搜索视图
        navigationView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-70)
            make.bottom.equalTo(-16)
            make.height.equalTo(38)
        }
        
        cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(COLOR_MinorTextColor, for: .disabled)
        cancelBtn.addTarget(self, action: #selector(cancelSearchAction), for: .touchUpInside)
        cancelBtn.contentHorizontalAlignment = .right
        cancelBtn.titleLabel?.font = UIFont(_customTypeSize: 14)
        cancelBtn.isEnabled = false
        cancelBtn.setTitleColor(UIColor.white, for: .normal)
        navigationView.addSubview(cancelBtn)
        cancelBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            make.centerY.equalTo(searchView.snp_centerY)
            make.width.equalTo(55)
        }
    }
    
    func loadSubViews () {
        
        loadSegmentControl()
        loadSortComponnet()
        //loadMarketListView()
    }
    
    func loadSegmentControl () {
        
        self.marketTypes = NSMutableArray.init() as? [String]
        
        for typeItem in self.typeModel?.marketTypes ?? [] {
            self.marketTypes?.append(typeItem.name ?? "")
        }
        
        self.marketList = NSMutableArray.init() as? [FCMarketListController]
        
        //let totalItemWidth = 100 * (self.marketTypes?.count ?? 0)
        let titles = self.marketTypes
        let titleDataSource = JXSegmentedTitleDataSource()
        titleDataSource.itemWidth = 100
        titleDataSource.titles = titles!
        titleDataSource.isTitleMaskEnabled = true
        titleDataSource.titleNormalColor = COLOR_HexColor(0x71819A)
        titleDataSource.titleSelectedColor = .white
        titleDataSource.titleSelectedFont = UIFont(_customTypeSize: 15)
        titleDataSource.titleNormalFont = UIFont(_customTypeSize: 14)
        titleDataSource.itemSpacing = 0
        segmentedDataSource = titleDataSource
        segmentedView.dataSource = titleDataSource
        segmentedView.frame = CGRect(x: 15, y: 132, width: kSCREENWIDTH - 30, height: 45)
        segmentedView.backgroundColor = COLOR_HexColor(0x22283A)
        segmentedView.layer.masksToBounds = true
        segmentedView.layer.cornerRadius = 5
        segmentedView.layer.borderColor = COLOR_HexColorAlpha(0x000000, alpha: 0.2).cgColor//COLOR_HexColor(0x3E4046).cgColor
        segmentedView.layer.borderWidth = 1
        segmentedView.delegate = self
        
        //UIScreen.main.scale
        //navigationItem.titleView = segmentedView

        let indicator = JXSegmentedIndicatorBackgroundView()
        indicator.indicatorHeight = 40
        indicator.indicatorWidth = 95
        indicator.indicatorCornerRadius = 5
        indicator.indicatorWidthIncrement = 0
        indicator.indicatorColor = COLOR_HexColor(0x323B4F)
        segmentedView.indicators = [indicator]
        segmentedView.listContainer = listContainerView
        
        view.addSubview(listContainerView)
        view.addSubview(segmentedView)
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
            make.top.equalTo(self.segmentedView.snp.bottom).offset(12)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
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
    
    @objc func cancelSearchAction() {
        
        self.searchTextField.text = ""
        self.searchTextField.resignFirstResponder()
        self.cancelBtn.isEnabled = false
        if let marketList = self.marketList {
            for marketVC in marketList {
                marketVC.searchStr = ""
            }
        }
    }
    
    @objc private func textFieldChange(textField: UITextField) {
        
        if textField.text?.count ?? 0 > 0 {
            
            self.cancelBtn.isEnabled = true
        }else {
            
            self.cancelBtn.isEnabled = false
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

extension FCMarketViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let marketList = self.marketList {
            
            for marketVC in marketList {
                
                marketVC.searchStr = textField.text
            }
        }
        
        textField.resignFirstResponder()
        
        return true
    }
}

extension FCMarketViewController: JXSegmentedListContainerViewDataSource{
    
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        if let titleDataSource = segmentedView.dataSource as? JXSegmentedBaseDataSource {
            return titleDataSource.dataSource.count
        }
        return 0
    }
    
    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
    
        let typeItem = self.typeModel?.marketTypes?[index]
        let marketVC = FCMarketListController()
        marketVC.parentController = self
        marketVC.marketTypesItem = typeItem
        self.marketList?.append(marketVC)
        
        return marketVC
    }
}

extension FCMarketViewController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int)
    {
        
    }
}

extension FCMarketViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        let isSelf = viewController.isKind(of: FCMarketViewController.self)

        self.navigationController?.setNavigationBarHidden(isSelf, animated: animated)
    }
}
