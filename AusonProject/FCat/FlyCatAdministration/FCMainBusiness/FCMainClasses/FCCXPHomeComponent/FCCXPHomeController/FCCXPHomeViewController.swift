//
//  FCCXPHomeViewController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class FCCXPHomeViewController: UIViewController {
    
    private let cellReuseIdentifier = "com.cvp.homecell"
    var dataSource: [FCHomeSymbolsModel]?
    var homeDataModel: FCHomeModel?
    var compositeView:FCHomeCompositeView?
    var navimaskView:UIView?
    let disposeBag = DisposeBag()
    var homeSubscription: Disposable?
    var sortComponent: FCSortComponent!
    var sortType:FCMarketSortType = .Default   // Volume Change
    var orderType:FCMarketOrderType = .Default // Desc Asc
    
    private lazy var homeApi:FCApi_homedata = {
       
       let homeApi = FCApi_homedata()
        return homeApi
    }()
    private lazy var menuHeaderView:UIView = {
        
        let menuHeaderView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 90))
        menuHeaderView.backgroundColor = COLOR_BGColor
        
        let titleL = UILabel.init(frame: CGRect(x: 15, y: 0, width: kSCREENWIDTH-30, height: 45))
        titleL.text = "热门产品"
        titleL.font = UIFont(_PingFangSCTypeSize: 18)
        titleL.textColor = .white
        menuHeaderView.addSubview(titleL)
        
        let lineView = UIView.init(frame: CGRect(x: 0, y: 50, width: kSCREENWIDTH, height: 0.5))
        lineView.backgroundColor = COLOR_LineColor
        menuHeaderView.addSubview(lineView)
        
        /*
        let tradeCategoryL = UILabel.init(frame: CGRect(x: 15, y: 50, width: 60, height: 40))
        tradeCategoryL.text = "交易品种"
        tradeCategoryL.font = UIFont(_PingFangSCTypeSize: 14)
        tradeCategoryL.textColor = COLOR_CellTitleColor
        menuHeaderView.addSubview(tradeCategoryL)
        
        let newestL = UILabel.init(frame: CGRect(x: 15, y: 50, width: 60, height: 40))
        newestL.center = CGPoint(x: titleL.center.x, y: newestL.center.y)
        newestL.text = "最新价"
        newestL.font = UIFont(_PingFangSCTypeSize: 14)
        newestL.textColor = COLOR_CellTitleColor
        menuHeaderView.addSubview(newestL)
        
        let priceLimitL = UILabel.init(frame: CGRect(x: kSCREENWIDTH - 75, y: 50, width: 60, height: 40))
        priceLimitL.textAlignment = .right
        priceLimitL.text = "涨跌幅"
        priceLimitL.font = UIFont(_PingFangSCTypeSize: 14)
        priceLimitL.textColor = COLOR_CellTitleColor
        menuHeaderView.addSubview(priceLimitL)
        */
        
        self.sortComponent = FCSortComponent.init(frame: .zero)
        self.sortComponent.backgroundColor = COLOR_CellBgColor
        menuHeaderView.addSubview(self.sortComponent)
        self.sortComponent.priceBtn.setImage(nil, for: .normal)
        self.sortComponent.priceBtn.isEnabled = false
        self.sortComponent.priceBtn.snp_updateConstraints { (make) in
            make.centerX.equalToSuperview().offset(20)
        }
        self.sortComponent.orderBtnClick { [weak self] (sortType: FCMarketSortType, orderType: FCMarketOrderType) in
            self?.orderType = orderType
            self?.sortType = sortType
            self?.loadHomeFeedData(sort: orderType.rawValue, order: sortType.rawValue)
        }
        
        self.sortComponent.snp.makeConstraints { (make) in
            make.top.equalTo(51)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        return menuHeaderView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshSybolData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.homeSubscription?.dispose()
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.view.backgroundColor = COLOR_BGColor
        // Do any additional setup after loading the view.
        self.navigationController?.delegate = self
        
        /// 数据轮询
        self.refreshSybolData()
        
        /// 界面背景底色
        let bgImgView = UIImageView(image: UIImage(named: "home_bg"))
        bgImgView.contentMode = .scaleAspectFill
        self.view.addSubview(bgImgView)
        bgImgView.snp.makeConstraints { (make) in
            make.width.equalTo(kSCREENWIDTH)
            make.height.equalTo(208)
            make.left.top.equalTo(0)
        }
        
        /// 自定义导航栏按钮
        let navigationView = UIView()
        navigationView.backgroundColor = .clear
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (make) in
            make.left.top.equalTo(0)
            make.width.equalTo(kSCREENWIDTH)
            make.height.equalTo(kNAVIGATIONHEIGHT)
        }
        
        self.navimaskView = UIView()
        self.navimaskView?.backgroundColor = COLOR_BGColor
        self.navimaskView?.alpha = 1.0
        navigationView.addSubview(self.navimaskView!)
        self.navimaskView?.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        let logoBtn = fc_buttonInit(imgName: "hi", title: "Hi, Welcome to Auson!", fontSize: 17, titleColor: UIColor.white, bgColor: .clear)
        logoBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 0)
        logoBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        logoBtn.contentHorizontalAlignment = .left
        logoBtn.addTarget(self, action: #selector(clickHomeLogoAction), for: .touchUpInside)
        navigationView.addSubview(logoBtn)
        
        let remindBtn = fc_buttonInit(imgName: "home_remind")
        remindBtn.addTarget(self, action: #selector(clickHomeRemindAciton), for: .touchUpInside)
        //remindBtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)
        remindBtn.contentHorizontalAlignment = .right
        navigationView.addSubview(remindBtn)
        
        logoBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            //make.width.height.equalTo(44)
            make.bottom.equalTo(-10)
        }
        remindBtn.snp.makeConstraints { (make) in
            make.right.equalTo(-15)
            //make.width.height.equalTo(44)
            make.bottom.equalTo(-10)
        }
        
        /// 界面数据刷新 
        self.homeTableView.refreshNormalModelRefresh(true, refreshDataBlock: { [weak self] in
            self?.loadHomeData(manuRefresh: true)
            }, loadMoreDataBlock: nil)
        
        /// banner notice nav 综合界面
        compositeView = FCHomeCompositeView()
        compositeView?.parentVC = self
        compositeView?.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: compositeView?.columnHeight ?? 0)
        self.homeTableView.tableHeaderView = compositeView
    }

    lazy var homeTableView = { () -> UITableView in
        let homeTableView = UITableView.init(frame: .zero, style: .plain)
        //homeTableView.contentInset = UIEdgeInsetsMake(kNAVIGATIONHEIGHT, 0, 0, 0)
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.rowHeight = 60.0
        homeTableView.showsVerticalScrollIndicator = false
        //homeTableView.separatorStyle = .none
        homeTableView.separatorColor = COLOR_TabBarBgColor
        homeTableView.layer.masksToBounds = true
        homeTableView.backgroundColor = .clear
        self.view.addSubview(homeTableView)
        homeTableView.snp.makeConstraints { (make) in
            make.top.equalTo(kNAVIGATIONHEIGHT)
            make.left.right.bottom.equalToSuperview()
        }
        //homeTableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        homeTableView.register(UINib(nibName: "FCHotSymbolsCell", bundle: Bundle.main), forCellReuseIdentifier: cellReuseIdentifier)
        return homeTableView
    }()
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension FCCXPHomeViewController {
    
    // 定时轮询行情列表
    func refreshSybolData() {
        
      self.homeSubscription?.dispose()
      let observable = Observable<Int>.interval(2.0, scheduler: MainScheduler.instance).subscribe {[weak self] (num) in
        
        let sortStr = self?.sortType.rawValue
        let orderStr = self?.orderType.rawValue
        self?.loadHomeFeedData(sort: sortStr ?? "", order: orderStr ?? "")
        
        /**
            if(!(self?.homeApi.isExecuting ?? false)) {
                self?.loadHomeData(manuRefresh: false)
            }
        */
        }
        observable.disposed(by: self.disposeBag)
        self.homeSubscription = observable
    }
    
    func loadHomeFeedData(sort: String, order: String) {
        
        let homeFeedApi = FCApi_home_feed(sort: sort, order: order)
        homeFeedApi.startWithCompletionBlock { (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                let tempModel = FCHomeModel.init(dict: responseData?["data"] as! [String : AnyObject])
                
                /// 数据更新
                self.dataSource?.removeAll()
                self.dataSource?.append(contentsOf: tempModel.hotSymbolsArray ?? [])
                
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                    self.homeTableView.endRefresh()
                }
            }
            
        } failure: { (response) in
            
        }
        
    }
    
    func loadHomeData(manuRefresh: Bool) {
        
        //homeApi = FCApi_homedata()
        self.homeApi.startWithCompletionBlock(success: { (response) in
            
            let responseData = response.responseObject as?  [String : AnyObject]
            
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                
                self.homeDataModel = FCHomeModel.init(dict: responseData?["data"] as! [String : AnyObject])
                
                /// 数据更新
                if manuRefresh {
                    self.compositeView?.homedataModel = self.homeDataModel
                    self.dataSource = self.homeDataModel?.hotSymbolsArray
                }else {
                    
                    // 仅轮询数据
                    self.compositeView?.mainSymbolsView?.dataSource = self.homeDataModel?.mainSymbolsArray
                    self.dataSource = self.homeDataModel?.hotSymbolsArray
                }
                
                DispatchQueue.main.async {
                    self.homeTableView.reloadData()
                    self.homeTableView.endRefresh()
                }
                
            } else{
                //let errMsg = responseData?["err"]?["msg"] as? String
                //self.view.makeToast(errMsg ?? "", position: .center)
            }

        }) { (response) in
            /**
            DispatchQueue.main.async {
                self.homeTableView.endRefresh()
                self.view.makeToast(response.error?.localizedDescription, position: .center)
            }
             */
        }
    }
    
    @objc func clickHomeLogoAction() {
        
        PCCustomAlert.showAppInConstructionAlert()
    }
    
    @objc func clickHomeRemindAciton() {
        
        PCCustomAlert.showAppInConstructionAlert()
    }
}

extension FCCXPHomeViewController:UITableViewDataSource, UITableViewDelegate
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let dataSource = dataSource {
            return dataSource.count;
        }
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? FCHotSymbolsCell
        if let cell = cell {
            let selectedBackgroundView = UIView()
            selectedBackgroundView.backgroundColor = .clear
            cell.selectedBackgroundView = selectedBackgroundView
            
            if let dataSource = dataSource {
                
                let symbolModel = dataSource[indexPath.row]
                cell.symbolModel = symbolModel
            }
            //cell.textLabel?.textColor = COLOR_MinorTextColor
            //cell.textLabel?.font = UIFont(_PingFangSCTypeSize: 14)
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return self.menuHeaderView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 90
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let symbolModel = dataSource?[indexPath.row]
        
        let klineVC = FCKLineController()
        let marketModel = FCMarketModel()
        marketModel.symbol = symbolModel?.symbol
        marketModel.name = symbolModel?.name ?? ""
        marketModel.marketType = symbolModel?.marketType ?? ""        
        marketModel.latestPrice = symbolModel?.latestPrice ?? "0"
        marketModel.close = symbolModel?.close ?? ""
        marketModel.high = symbolModel?.high ?? ""
        marketModel.low = symbolModel?.low ?? ""
        marketModel.tradingType = symbolModel?.tradingType ?? ""
        marketModel.volume = symbolModel?.tradingAmount ?? ""
        marketModel.changePercent = symbolModel?.changePercent ?? ""
        marketModel.name = symbolModel?.name ?? ""
        
        klineVC.marketModel = marketModel
        klineVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(klineVC, animated: true)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let minAlphaOffset:CGFloat = -kNAVIGATIONHEIGHT;
        let maxAlphaOffset:CGFloat = 300;
        let offset:CGFloat = scrollView.contentOffset.y;
        var alpha = 0.0;
        if (offset <= 0) {
            alpha = 0.0;
        } else {
            alpha = Double((offset - minAlphaOffset) / (maxAlphaOffset - minAlphaOffset));
        }
        
        //self.navimaskView?.alpha = CGFloat(alpha)
    }
}

extension FCCXPHomeViewController: UINavigationControllerDelegate {
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {

        let isSelf = viewController.isKind(of: FCCXPHomeViewController.self)

        self.navigationController?.setNavigationBarHidden(isSelf, animated: animated)
    }
}


