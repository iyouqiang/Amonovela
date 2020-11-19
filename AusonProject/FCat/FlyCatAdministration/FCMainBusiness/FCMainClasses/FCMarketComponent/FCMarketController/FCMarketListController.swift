//
//  FCMarketListController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FCMarketListController: UIViewController {
    
    let disposeBag = DisposeBag()
    var listSubscription: Disposable?
    var marketTableView : UITableView!
    var isOptional = false
    var pageIndex = 0 
    var marketArray = [FCMarketModel]()
    var loginoutView: UIView?
    var webSocket: PCWebSocketNetwork?
    weak var parentController: FCMarketViewController?
    var usdt_rate: String?
    var total: Int = 0
    var sortArray = [FCMarketModel]()
    var lastTimeInterval:TimeInterval = 0.0
    var reloadArray = [IndexPath]()
    var isFirstRequest = false
    var shuffling = [String]()
    
    private lazy var footerHint:UILabel = {
        
        let footerHint = fc_labelInit(text: "暂无数据", textColor: COLOR_InputText, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        footerHint.textAlignment = .center
        footerHint.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        return footerHint
    }()
    
    // CXP
    var marketType: String = "Spot"
    var sortType: FCMarketSortType = .Default
    var orderType: FCMarketOrderType = .Default
    
    deinit {
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //observableSubscribe()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //listSubscription?.dispose()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let now = NSDate()
        
        self.lastTimeInterval = now.timeIntervalSince1970
        
        self.loadMarketView()
        
        // 登录成功通知
        NotificationCenter.default.addObserver(self, selector: #selector(marketLogin), name: NSNotification.Name(rawValue: kNotificationUserLogin), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(marketLoginout), name: NSNotification.Name(rawValue: kNotificationUserLogout), object: nil)
        
        // 添加删除自选的通知
        _ = NotificationCenter.default.rx.notification(NSNotification.Name(rawValue: kNotificationUpdateFavorite))
            .takeUntil(self.rx.deallocated)
            .subscribe { [weak self]  _ in
                // 重新拉取列表， 刷新UI
                if self?.isOptional ?? false {
                    self?.requestAllData(false)
                }
        }
        
        observableSubscribe()
    }
    
    func observableSubscribe() {
        
          // 定时轮询行情列表
        listSubscription?.dispose()
        let observable = Observable<Int>.interval(5.0, scheduler: MainScheduler.instance).subscribe {[weak self] (num) in
              self?.requestlistData()
          }
        observable.disposed(by: self.disposeBag)
        listSubscription = observable
    }
    
    func sortMarketList(sortType: FCMarketSortType, orderType: FCMarketOrderType) {
        
        if (sortType == self.sortType && orderType == self.orderType) {
            return
        }
        self.sortType = sortType
        self.orderType = orderType
        self.requestlistData()
    }
    
    @objc func reqeustOptionData(_ loadMore: Bool) {
        
        if !FCUserInfoManager.sharedInstance.isLogin {
            self.marketTableView.endRefresh()
            return
        }
        
        self.pageIndex = loadMore ? self.pageIndex : 0
    }
    
    func requestlistData () {
        if (self.isOptional && FCUserInfoManager.sharedInstance.isLogin) {
            self.requestAllData(false)
        } else if (self.isOptional == false){
            self.requestAllData(false)
        }
    }
    
    func requestAllData(_ loadMore: Bool) {
        let tickersApi = FCApi_market_tickers.init(marketType: self.marketType, sortType: self.sortType.rawValue, orderType: self.orderType.rawValue)
        tickersApi.startWithCompletionBlock(success: { (response) in
        
            if response.responseCode == 0 {
                self.marketArray.removeAll()
                let data = (response.responseObject as AnyObject)["data"] as! [String: AnyObject]
                let list = data["tickers"] as! [Any]
                
                for marketDic in list {
                    if let marketDic = marketDic as?  [String: AnyObject] {
                        //                        let model = FCMarketModel.init(dict: marketDic)
                        let model = FCMarketModel.stringToObject(jsonData: marketDic)
                        self.marketArray.append(model)
                    }
                }
                
                DispatchQueue.main.async {
                    if self.marketArray.count > 0 {
                        
                        self.marketTableView.tableFooterView = UIView()
                    }else {
                        self.marketTableView.tableFooterView = self.footerHint
                    }
                    self.marketTableView.reloadData()
                }
            }else {
                self.view.makeToast(response.responseMessage, position: .center)
            }
            
            self.marketTableView.endRefresh()
            
        }) { (response) in
            self.marketTableView.endRefresh()
            self.view.makeToast(response.error?.localizedDescription, position: .center)
        }
    }
    
    // 登录成功
    @objc func marketLogin() {
        
        if self.isOptional {
            self.marketTableView.isScrollEnabled = true
            self.marketTableView.backgroundView  = nil
            self.reqeustOptionData(false)
        }
    }
    
    // 退出登录
    @objc func marketLoginout() {
        
        if self.isOptional {
            self.marketTableView.isScrollEnabled = false
            self.marketArray.removeAll()
            self.sortArray.removeAll()
            self.marketTableView.backgroundView = self.loginoutView
            self.marketTableView.tableHeaderView = nil
            self.marketTableView.reloadData()
        }
    }
    
    // 自选
    func configureOptionalView() {
        
        var isAutoRefresh = false
        if FCUserInfoManager.sharedInstance.isLogin {
            
            isAutoRefresh = true
        }else {
            
            self.marketTableView.isScrollEnabled = false
            self.marketTableView.tableHeaderView = nil
            self.marketTableView.backgroundView = self.loginoutView
        }
        
        self.marketTableView.refreshNormalModelRefresh(isAutoRefresh, refreshDataBlock: {
            // 下拉加载
            self.reqeustOptionData(false)
        }) {
            // self.reqeustOptionData(true)
        }
    }
    
    // 所有
    func configureAllView() {
        self.requestAllData(false)
        self.marketTableView.refreshNormalModelRefresh(false, refreshDataBlock: {
            self.requestAllData(false)
        }) {
            self.requestAllData(true)
        }
    }
     
    func loadMarketView()  {
        
        self.marketTableView = UITableView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: kSCREENHEIGHT-kTABBARHEIGHT - 100 - KSTATUSBARHEIGHT), style: .plain)
        self.marketTableView.estimatedRowHeight = 64
        //self.marketTableView.separatorStyle = .none
        self.marketTableView.delegate = self
        self.marketTableView.dataSource = self
        self.marketTableView.showsVerticalScrollIndicator = false
        self.marketTableView.backgroundColor = COLOR_BGColor
        self.marketTableView.separatorColor = COLOR_LineColor
        self.view.addSubview(self.marketTableView)
        
        self.loadloginoutView()
        
    }
    
    func loadloginoutView () {
        // 未登录提示界面
        self.loginoutView = UIView.init(frame: self.marketTableView.bounds)
        self.loginoutView?.backgroundColor = UIColor.clear
        
        let loginBtn = UIButton(type: .custom)
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setTitleColor(COLOR_HighlightColor, for: .normal)
        loginBtn.backgroundColor = UIColor.white
        loginBtn.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
        loginBtn.center = (self.loginoutView?.center)!
        loginBtn.addTarget(self, action: #selector(marketLoginAction), for: .touchUpInside)
        self.loginoutView?.addSubview(loginBtn)
    }
    
    func marketSubscriptionListening() {
        
        // 请求完成后订阅 滑动结束订阅 暂时弃用
        //        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(shufflingMarket), object: nil)
        //        self.perform(#selector(shufflingMarket), with: nil, afterDelay: 1)
    }
    
    @objc func shufflingMarket() {
        
    }
    
    
    @objc func marketLoginAction() {
        
        FCLoginViewController.showLogView { (model) in
            
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

extension FCMarketListController : UITableViewDataSource, UITableViewDelegate {
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        self.marketSubscriptionListening()
    }
    
    func tableView(_ tableView: UITableView, willBeginEditingRowAt indexPath: IndexPath) {
        view.setNeedsLayout()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        self.marketSubscriptionListening()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return false //self.isOptional
    }
    
    // 滑动删除
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return UITableViewCell.EditingStyle.delete
    }
    
    //在这里修改删除按钮的文字
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        
        return "删除自选"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let klineVC = FCKLineController()
        let marketModel = self.marketArray[indexPath.row]
        
        klineVC.marketModel = marketModel
        klineVC.hidesBottomBarWhenPushed = true
        self.parentController?.navigationController?.pushViewController(klineVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.marketArray.count
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 5))
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentify = "cellIdentify"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify) as? FCMarketCell
        
        if cell == nil {
            
            cell = Bundle.main.loadNibNamed("FCMarketCell", owner: nil, options: nil)?.last as? FCMarketCell
            cell?.contentView.backgroundColor = COLOR_BGColor
            cell?.backgroundColor = COLOR_BGColor
        }
        
        cell?.indexPath = indexPath as NSIndexPath;
        cell?.configureCell(self.marketArray[indexPath.row], isOptional: self.isOptional)
        
        return cell!
    }
}

