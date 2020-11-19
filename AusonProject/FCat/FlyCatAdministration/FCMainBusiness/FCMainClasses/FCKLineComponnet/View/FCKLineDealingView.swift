
//
//  FCKLineDealingView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCKLineDealingView: UITableView {

    var dealModel: FCKLineDealModel?
     let tabHeader = FCKLineDealHeader.dealingView()
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        self.tableHeaderView = self.tabHeader
        self.delegate = self
        self.dataSource = self
        self.isScrollEnabled = false
        self.allowsSelection = false
        self.backgroundColor = COLOR_BGColor
        self.separatorStyle = .none
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func reloadWithDatas(symbol: String, model: FCKLineDealModel?) {
        self.tabHeader.reloadLabels(symbol: symbol)
        self.dealModel = model
        self.reloadData()
    }
}


extension FCKLineDealingView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return min(self.dealModel?.trades?.count ?? 0, 9)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentify = "FCKLineDealCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify) as? FCKLineDealCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FCKLineDealCell", owner: nil, options: nil)?.last as? FCKLineDealCell
        }
        cell?.configCell(index: indexPath.row, tradeModel: self.dealModel?.trades?[indexPath.row])
        return cell!
    }
    
    
    
    
}

