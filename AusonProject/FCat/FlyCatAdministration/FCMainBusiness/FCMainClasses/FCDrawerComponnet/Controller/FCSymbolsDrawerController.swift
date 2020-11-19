
//
//  FCSymbolsDrawerController.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/25.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import JXSegmentedView

let FCSymbolsDrawerCellReuseId = "FCSymbolsDrawerCellReuseId"

class FCSymbolsDrawerController: UIViewController {
    var keepWhenPresenting: Bool = false
    var symbol: String = ""
    var marketType: String = "spot"
    
    let segmentedView = JXSegmentedView()
    var segmentedDataSource :JXSegmentedTitleDataSource?
    var searchbar: UISearchBar?
    
    var quotes: FCQuoteTypesModel?
    var tableView: UITableView?
    var searchResult: Array<FCMarketModel>?
    var didSelectItem: ((FCMarketModel) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor
        //self.adjuestInsets()
        self.loadLeftNavItem()
        
        self.fetchQuoteTypes()
        self.loadSegmentControl()
        self.loadSearchbar()
        self.loadTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.backgroundColor = COLOR_BGColor
        
        //self.fetchQuoteTypes()
    }
    
    func loadLeftNavItem () {
        let lab = fc_labelInit(text: "币币", textColor: COLOR_ThemeBtnEndColor, textFont: 18, bgColor: COLOR_Clear)
        lab.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let item = UIBarButtonItem.init(customView: lab)
        self.navigationItem.leftBarButtonItem = item
    }
    
    func loadSegmentControl () {
        
        self.loadDataSource()
        let indicator = JXSegmentedIndicatorLineView()
        indicator.backgroundColor = COLOR_BGColor
        indicator.indicatorColor = COLOR_ThemeBtnEndColor
        segmentedView.indicators = [indicator]
        segmentedView.delegate = self
        
        segmentedView.backgroundColor = COLOR_BGColor
        self.view.addSubview(segmentedView)
        segmentedView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
    }
    
    func loadDataSource() {
        
        var titles: Array<String> = []
        
        for item: FCQuoteTypeItem in self.quotes?.quoteTypes ?? [] {
            titles.append(item.name)
        }
        
        segmentedDataSource = JXSegmentedTitleDataSource()
        //配置数据源相关配置属性
        segmentedDataSource?.titles = titles
        segmentedDataSource?.isTitleColorGradientEnabled = true
        segmentedDataSource?.titleNormalFont = UIFont.init(_customTypeSize: 14)
        segmentedDataSource?.itemSpacing = 25
        
        segmentedDataSource?.titleNormalColor = COLOR_White
        segmentedDataSource?.titleSelectedColor = COLOR_ThemeBtnEndColor
        segmentedView.dataSource = self.segmentedDataSource
    }
    
    func loadSearchbar () {
        self.searchbar = UISearchBar.init()
        self.searchbar?.placeholder = "搜索币种"
        self.searchbar?.barTintColor = COLOR_BGColor
        self.searchbar?.backgroundColor = COLOR_BGColor
        self.searchbar?.searchBarStyle = .minimal
        self.searchbar?.barStyle = .black
        if #available(iOS 13.0, *) {
            self.searchbar?.searchTextField.backgroundColor = COLOR_HexColor(0x25262F)
        } else {
            // Fallback on earlier versions
        }
        self.searchbar?.tintColor = COLOR_ThemeBtnEndColor
        
        let lineView = UIView()
        lineView.backgroundColor = COLOR_BGColor
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.segmentedView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        })
        
        self.view.addSubview(self.searchbar!)
        self.searchbar?.snp.makeConstraints({ (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        })
        
        self.searchbar?.delegate = self
    }
    
    func loadTableView () {
        
        self.tableView = UITableView.init()
        self.tableView?.backgroundColor = COLOR_BGColor
        self.tableView?.separatorStyle = .none
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.view.addSubview(self.tableView!)
        
        let lineView = UIView()
        lineView.backgroundColor = COLOR_BGColor
        self.view.addSubview(lineView)
        
        lineView.snp.makeConstraints({ (make) in
            make.top.equalTo(self.searchbar!.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(10)
        })
        
        self.tableView?.snp.makeConstraints({ (make) in
            make.top.equalTo(lineView.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview()
        })
    }
    
    func didSelectItem (callback: @escaping (_ model: FCMarketModel) -> Void) {
        self.didSelectItem = nil;
        self.didSelectItem = callback
    }
    
    func fetchQuoteTypes () {
        let api = FCApi_quote_types.init()
        api.startWithCompletionBlock(success: { (response) in
            
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                self.quotes = FCQuoteTypesModel.stringToObject(jsonData: resData)
                if(self.quotes?.quoteTypes?.count ?? 0 > 0) {
                    self.loadDataSource()
                    let count = self.segmentedView.selectedIndex
                    self.fetchQuoteTickers(index:count)
                }
            }) { (errMsg) in
                self.view.makeToast(errMsg ?? "", position: .center)
            }
            
        }) { (response) in
            
            FCNetworkUtils.handleError(response: response) { (errMsg) in
                
            }
        }
    }
    
    func fetchQuoteTickers(index: Int) {
        //切换了类型先清空搜索框
        self.searchbar?.text = nil
        let api = FCApi_quote_tickers.init(quote: self.quotes?.quoteTypes?[index].quote ?? "")
        api.startWithCompletionBlock(success: { (response) in
            FCNetworkUtils.handleResponse(response: response, success: { (resData) in
                let quoteItem = FCQuoteTypeItem.stringToObject(jsonData: resData)
                quoteItem.name = self.quotes?.quoteTypes?[index].name ?? ""
                quoteItem.quote = self.quotes?.quoteTypes?[index].quote ?? ""
                self.quotes?.quoteTypes?[index] = quoteItem
                self.reloadQuoteList(item: quoteItem)
            }) { (errMsg) in
                
            }
            
        }) { (response) in
            
        }
    }
    
    
    func reloadQuoteList(item: FCQuoteTypeItem) {
        self.searchResult = []
        
        if self.searchbar?.text?.isEmpty ?? false {
            self.searchResult = item.tickers
        } else {
            for model: FCMarketModel in item.tickers ?? [] {
                if model.symbol?.uppercased().contains(self.searchbar?.text?.uppercased() ?? "") ?? false {
                    self.searchResult?.append(model)
                }
            }
        }
        
        self.tableView?.reloadData()
    }
}

extension FCSymbolsDrawerController: JXSegmentedViewDelegate {
    
    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        self.fetchQuoteTickers(index: index)
    }
}

extension FCSymbolsDrawerController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.reloadQuoteList(item: self.quotes?.quoteTypes?[self.segmentedView.selectedIndex] ?? FCQuoteTypeItem())
    }
}

extension FCSymbolsDrawerController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResult?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = FCSymbolsDrawerCell.init(style: .default, reuseIdentifier: FCSymbolsDrawerCellReuseId)
        cell.loadData(model: self.searchResult?[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.didSelectItem?(self.searchResult?[indexPath.row] ?? FCMarketModel())
    }
}



