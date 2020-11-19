//
//  FCContractSyntheController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/11.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import SideMenu
import JXSegmentedView

let tradeViewHeight: CGFloat = 550 // 交易界面高度
let topViewHeight: CGFloat = 594   // tradeViewHeight + 44

class FCContractSyntheController: UIViewController {

    var marketModel: FCMarketModel?
    var mainScrollView: UIScrollView!
    var menuSectionView: UIView!
    var selectedView: UIView!
    var historyBtn: UIButton!
    var entrustBtn: UIButton!
    var positionBtn: UIButton!
    var currentVC : UIViewController?
    var controlOrderVC: FCTreatyOrderController!
    var selectedBtn: UIButton!
    var planEntrustBtn: UIButton!
    var profitLossBtn: UIButton!
    var addContentHeight: CGFloat!
    
    //合约持仓
    lazy var positionController: FCContractPositionController = {
        let positionController = FCContractPositionController()
        positionController.marketModel = self.marketModel
        return positionController
    }()
    
    //合约委托
    lazy var perpetualEntrustController: FCPerpetualEntrustController = {
        let perpetualVC = FCPerpetualEntrustController()
        perpetualVC.marketModel = self.marketModel
        return perpetualVC
    }()
    
    /// 计划委托
    lazy var planEntrustController: FCTriggerEntrustViewController = {
        let planEntrustVC = FCTriggerEntrustViewController()
        planEntrustVC.marketModel = self.marketModel
        return planEntrustVC
    }()
    
    // 止盈止损
    lazy var profitLossEntrustController: FCContractProfitLossController = {
        let profitLossVC = FCContractProfitLossController()
        profitLossVC.marketModel = self.marketModel
        return profitLossVC
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        /// 切换更新
        controlOrderVC.updateSymbol(model: self.marketModel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addContentHeight = 0
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        
        self.setupUI()
    
        /// 持仓
        self.positionController.currentViewHeightBolcok = {
            [weak self](viewHeight, accountModel) in
            let positionNum = accountModel.account?.positionNum ?? "0"
            let pendingOrderNum = accountModel.account?.pendingOrderNum ?? "0"
            let triggerCloseOrderNum = accountModel.account?.triggerCloseOrderNum ?? "0"
            let triggerOpenOrderNum = accountModel.account?.triggerOpenOrderNum ?? "0"
            self?.positionBtn.setTitle("持仓(\(positionNum))", for: .normal)
            self?.entrustBtn.setTitle("委托(\(pendingOrderNum))", for: .normal)
            self?.planEntrustBtn.setTitle("计划委托(\(triggerOpenOrderNum))", for: .normal)
            self?.profitLossBtn.setTitle("止盈止损(\(triggerCloseOrderNum))", for: .normal)
            self?.controlOrderVC.accountInfoModel = accountModel
            
            if self?.currentVC == self?.positionController {
                
                self?.setContentHeight(viewHeight: viewHeight, controller:(self?.positionController)!)
            }
        }
        
        /// 委托 
        self.perpetualEntrustController.currentViewHeightBolcok = {
           [weak self] (viewHeight, count) in
            
            self?.entrustBtn.setTitle("委托(\(count))", for: .normal)
            
            if self?.currentVC == self?.perpetualEntrustController {
                
                self?.setContentHeight(viewHeight: viewHeight, controller:(self?.perpetualEntrustController)!)
            }
        }
        
        /// 止盈止损
        self.controlOrderVC.orderView?.showProfitLossItemBlock = {
            isfolded in
            let changeHeight:CGFloat = 130
            //let height = isfolded ? tradeViewHeight:tradeViewHeight + changeHeight
            self.addContentHeight = isfolded ? 0 : changeHeight
            
            let contentHeight = self.addContentHeight == changeHeight ? self.mainScrollView.contentSize.height + changeHeight : self.mainScrollView.contentSize.height - changeHeight
            
            self.mainScrollView.contentSize = CGSize(width: self.mainScrollView.contentSize.width, height: contentHeight)
            
            UIView.animate(withDuration: 0.2) {
                
                self.menuSectionView.frame = CGRect(x: self.menuSectionView.frame.minX, y: tradeViewHeight + self.addContentHeight, width: self.menuSectionView.frame.width, height: self.menuSectionView.frame.height)
                
                self.currentVC?.view.frame = CGRect(x: 0, y: topViewHeight + self.addContentHeight, width: kSCREENWIDTH, height: self.currentVC?.view.frame.height ?? kSCREENHEIGHT)
                
                self.controlOrderVC.view.snp.remakeConstraints { (make) in
                    make.left.right.top.equalToSuperview()
                    make.height.equalTo(tradeViewHeight + self.addContentHeight)
                }
            }
        }
        
        /// 计划委托
        self.planEntrustController.currentViewHeightBolcok = {
           [weak self] (viewHeight, count) in
            
            self?.planEntrustBtn.setTitle("计划委托(\(count))", for: .normal)
            if self?.currentVC == self?.planEntrustController {
                
                self?.setContentHeight(viewHeight: viewHeight, controller:(self?.planEntrustController)!)
            }
        }
        
        /// 止盈止损
        self.profitLossEntrustController.currentViewHeightBolcok = {
           [weak self] (viewHeight, count) in
            
            self?.profitLossBtn.setTitle("止盈止损(\(count))", for: .normal)
            if self?.currentVC == self?.profitLossEntrustController {
                
                self?.setContentHeight(viewHeight: viewHeight, controller:(self?.profitLossEntrustController)!)
            }
        }
    }
    
    func setContentHeight(viewHeight: CGFloat, controller: UIViewController) {
        
        controller.view.frame = CGRect(x: 0, y: topViewHeight + self.addContentHeight, width: kSCREENWIDTH, height: viewHeight + kTABBARHEIGHT)
        
        let contentViewHeight = viewHeight < kSCREENHEIGHT ? kSCREENHEIGHT : viewHeight
        
        let contentSizeHeight = topViewHeight + contentViewHeight + kTABBARHEIGHT + 44 + (self.addContentHeight ?? 0.0)
        
        if contentSizeHeight > self.mainScrollView.contentSize.height {
            
            self.mainScrollView.contentSize = CGSize(width: kSCREENWIDTH, height: contentSizeHeight)
        }
    }
    
    func setupUI() {

        /// scrollview 底图
        mainScrollView = UIScrollView(frame: self.view.bounds)
        mainScrollView.showsVerticalScrollIndicator = false
        mainScrollView.backgroundColor = COLOR_BGColor
        mainScrollView.delegate = self
        view.addSubview(mainScrollView)
                
        /// 合约交易界面
        controlOrderVC = FCTreatyOrderController()
        controlOrderVC.marketModel = FCTradeUtil.shareInstance.tradeModel
        controlOrderVC.view.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: tradeViewHeight)
        mainScrollView.addSubview(controlOrderVC.view)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
            
            self.mainScrollView.contentSize = CGSize(width: kSCREENWIDTH, height: tradeViewHeight + 400.0)
        })
        
        /// 交易高度
        controlOrderVC.view.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(tradeViewHeight)
        }
        
        ///  第一次进入界面请求接口
        controlOrderVC.updateSymbol(model: self.marketModel)
        
        controlOrderVC.klineViewItemBlock = {
            [weak self] in
            let klineVC = FCKLineController()
            let marketModel = self?.marketModel
 
            klineVC.marketModel = marketModel
            klineVC.hidesBottomBarWhenPushed = true
                       
            self?.navigationController?.pushViewController(klineVC, animated: true)
        }
        
        controlOrderVC.leftMenuItemBlock = {
           [weak self] leftSideMenu in
            
            self?.controlOrderVC.leftVC.fetchQuoteTypes()
            if let menu = leftSideMenu.menuLeftNavigationController {
                self?.present(menu , animated: true, completion: nil)
            }
        }
        
        controlOrderVC.contractSetItemBlock = {
            
            [weak self] in
            let settingVC = FCPerpetualContractSetController()
            settingVC.marketModel = self?.marketModel
            
            settingVC.hidesBottomBarWhenPushed = true
            self?.navigationController?.pushViewController(settingVC, animated: true)
        }
        
        // 切换交易对
         controlOrderVC.didSelectItem = { [weak self] (model) in
            self?.marketModel = model
            self?.positionController.marketModel = self?.marketModel
            self?.perpetualEntrustController.marketModel = self?.marketModel
         }
        
        /// 底部选择标签页 菜单
        menuSectionView = UIView(frame: CGRect(x: 0, y: tradeViewHeight, width: kSCREENWIDTH, height: 44))
        menuSectionView.backgroundColor = COLOR_BGColor
        mainScrollView.addSubview(menuSectionView)
        
        /// 三个 按钮 和 底部选择 按钮
        positionBtn = fc_buttonInit(imgName: "", title: "持仓(0)", fontSize: 14, titleColor: COLOR_TabBarTintColor, bgColor: .clear)
        positionBtn.tag = 100
        positionBtn.addTarget(self, action: #selector(changeContractContent(sender:)), for: .touchUpInside)
        positionBtn.setTitleColor(COLOR_TabBarTintColor, for: .selected)
        positionBtn.isSelected = true
        positionBtn.setTitleColor(COLOR_CellTitleColor, for: .normal)
        menuSectionView.addSubview(positionBtn)
        self.selectedBtn = positionBtn
        
        entrustBtn = fc_buttonInit(imgName: "", title: "委托(0)", fontSize: 14, titleColor: COLOR_InputText, bgColor: .clear)
        entrustBtn.setTitleColor(COLOR_TabBarTintColor, for: .selected)
        entrustBtn.setTitleColor(COLOR_CellTitleColor, for: .normal)
        entrustBtn.tag = 101
        entrustBtn.addTarget(self, action: #selector(changeContractContent(sender:)), for: .touchUpInside)
        menuSectionView.addSubview(entrustBtn)
        
        planEntrustBtn = fc_buttonInit(imgName: "", title: "计划委托(0)", fontSize: 14, titleColor: COLOR_InputText, bgColor: .clear)
        planEntrustBtn.setTitleColor(COLOR_TabBarTintColor, for: .selected)
        planEntrustBtn.setTitleColor(COLOR_CellTitleColor, for: .normal)
        planEntrustBtn.tag = 102
        planEntrustBtn.addTarget(self, action: #selector(changeContractContent(sender:)), for: .touchUpInside)
        menuSectionView.addSubview(planEntrustBtn)
        
        profitLossBtn = fc_buttonInit(imgName: "", title: "止盈止损(0)", fontSize: 14, titleColor: COLOR_InputText, bgColor: .clear)
        profitLossBtn.setTitleColor(COLOR_TabBarTintColor, for: .selected)
        profitLossBtn.setTitleColor(COLOR_CellTitleColor, for: .normal)
        profitLossBtn.tag = 103
        profitLossBtn.addTarget(self, action: #selector(changeContractContent(sender:)), for: .touchUpInside)
        menuSectionView.addSubview(profitLossBtn)
        
        let btnWidth = entrustBtn.titleLabel?.labelWidthMaxHeight(50) ?? 0.0
        positionBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(15)
            make.width.equalTo(btnWidth)
        }
        
        entrustBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(positionBtn.snp.right).offset(10)
            make.width.equalTo(btnWidth)
        }
        
        let btnplanWidth = planEntrustBtn.titleLabel?.labelWidthMaxHeight(50) ?? 0.0
        planEntrustBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(entrustBtn.snp.right).offset(10)
            make.width.equalTo(btnplanWidth)
        }
        
        profitLossBtn.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(0)
            make.left.equalTo(planEntrustBtn.snp.right).offset(10)
            make.width.equalTo(btnplanWidth)
        }
        
        /// 按钮底部选择条
        selectedView = UIView(frame: CGRect(x: 0, y: 0, width: btnWidth, height: 2))
        selectedView.backgroundColor = COLOR_TabBarTintColor
        menuSectionView.addSubview(selectedView)
        selectedView.snp.makeConstraints { (make) in
            
            make.left.equalTo(positionBtn.snp_left)
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(btnWidth)
        }
        
        let historyBtn = fc_buttonInit(imgName: "historyIcon", title: "", fontSize: 14, titleColor: COLOR_CellTitleColor, bgColor: .clear)
        historyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 5)
        historyBtn.frame = CGRect(x: kSCREENWIDTH - 60, y: 0, width: 44, height: 44)
        historyBtn.contentHorizontalAlignment = .right
        menuSectionView.addSubview(historyBtn)
        historyBtn.addTarget(self, action: #selector(gotoHistoryVC), for: .touchUpInside)
        
        /// 底部视图 委托 持仓
        self.positionController.view.frame = CGRect(x: 0, y: (topViewHeight), width: kSCREENWIDTH, height: kSCREENHEIGHT)
        mainScrollView.addSubview(self.positionController.view)
        self.positionController.didMove(toParent: self)
        self.addChild(self.positionController)
        self.currentVC = self.positionController
        
        mainScrollView.addSubview(menuSectionView)
        
    }
    
    @objc func changeContractContent(sender: UIButton) {
    
        if mainScrollView.contentOffset.y > tradeViewHeight {
            
            mainScrollView.setContentOffset(CGPoint(x: 0, y: tradeViewHeight), animated: true)
        }
        
        self.selectedBtn.isSelected = false
        sender.isSelected = true
        self.selectedBtn = sender
        
        UIView.animate(withDuration: 0.2) {
          
            self.selectedView.snp.remakeConstraints { (make) in
                
                make.left.equalTo(self.selectedBtn.snp_left)
                make.bottom.equalToSuperview()
                make.height.equalTo(2)
                make.width.equalTo(self.selectedBtn.snp.width)
            }
            
            self.menuSectionView.layoutIfNeeded()
        }
    
        if sender.tag == 100 {
            
            self.changeControllerFromOldController(oldController: self.currentVC!, newController: self.positionController)
            
        }else if (sender.tag == 101) {
            
            self.changeControllerFromOldController(oldController: self.currentVC!, newController: self.perpetualEntrustController)
            
        }else if (sender.tag == 102) {
            
            self.changeControllerFromOldController(oldController: self.currentVC!, newController: self.planEntrustController)
            
        }else {
            
            self.changeControllerFromOldController(oldController: self.currentVC!, newController: self.profitLossEntrustController)
        }
        
        mainScrollView.addSubview(menuSectionView)
    }
    
    @objc func gotoHistoryVC() {
        
        let contractEntrustListVC = FCContractsEntrustMultiListController()
        contractEntrustListVC.marketModel = self.marketModel
        contractEntrustListVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(contractEntrustListVC, animated: true)
    }
    
    /// 控制器切换
    func changeControllerFromOldController(oldController: UIViewController, newController:UIViewController)
    {
        if self.currentVC == newController {
            return
        } 
        self.addChild(newController)
        newController.view.frame = CGRect(x: 0, y: topViewHeight + self.addContentHeight, width: kSCREENWIDTH, height: newController.view.frame.height)
        mainScrollView.addSubview(newController.view)
        
        self.transition(from: oldController, to: newController, duration: 0.3, options: .curveEaseIn, animations: {
            
        }) { (finish) in
            
            if (finish) {
                
                newController.didMove(toParent: self)
                oldController.willMove(toParent: nil)
                oldController .removeFromParent()
                self.currentVC = newController
                   
            }else {
                
                self.currentVC = oldController
            }
        }
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

extension FCContractSyntheController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        
        if scrollView.contentOffset.y > tradeViewHeight + addContentHeight {
            
            menuSectionView.frame = CGRect(x: 0, y: tradeViewHeight + addContentHeight + abs(contentOffsetY - tradeViewHeight - addContentHeight), width: kSCREENWIDTH, height: 44)
            
        }else {
           
            menuSectionView.frame = CGRect(x: 0, y: tradeViewHeight + addContentHeight, width: kSCREENWIDTH, height: 44)
        }
    }
}

extension FCContractSyntheController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

