
//
//  FCKLineRestingView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/15.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCKLineRestingView: UITableView {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    var restModel: FCKLineRestingModel?
    let tabHeader = FCKLineRestingHeader.restingView()
    
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
    
    func reloadWithDatas(symbol: String, model: FCKLineRestingModel?) {
        self.tabHeader.reloadLabels(symbol: symbol)
        self.restModel = model
        /// 对买盘数据进行翻转
        self.reloadData()
    }
}

extension FCKLineRestingView : UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  min(self.restModel?.bids?.count ?? 0, self.restModel?.asks?.count ?? 0, 9)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentify = "FCKLineRestingCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify) as? FCKLineRestingCell
        
        if cell == nil {
            cell = Bundle.main.loadNibNamed("FCKLineRestingCell", owner: nil, options: nil)?.last as? FCKLineRestingCell
        }
        cell?.configCell(index: indexPath.row, bidModel: self.restModel?.bids?[indexPath.row], askModel: self.restModel?.asks?.reversed()[indexPath.row])
        return cell!
    }
}
