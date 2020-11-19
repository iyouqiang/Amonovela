//
//  FCContractDepthAlertVeiw.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/9/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

let cellidentify = "contractDepthIdentify"

class FCContractDepthAlertVeiw: UIView {
    
    var closeAlertBlock:(() -> Void)?
    var switchDepthBlock:((_ index: Int) -> Void)?

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    lazy var depthSelectTableVeiw: UITableView = {
        
        let depthSelectTableVeiw = UITableView(frame: CGRect.zero, style: .plain)
        depthSelectTableVeiw.delegate = self
        depthSelectTableVeiw.dataSource = self
        depthSelectTableVeiw.rowHeight = 44
        depthSelectTableVeiw.separatorColor = Color(0xD8D8D8)
        return depthSelectTableVeiw
    }()
    
    var dataSource = [["默认", "买盘", "卖盘"], ["取消"]]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(depthSelectTableVeiw)
        depthSelectTableVeiw.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension FCContractDepthAlertVeiw: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            FCTradeSettingconfig.sharedInstance.depthType = "\(indexPath.row)"
            
            if let switchDepthBlock = switchDepthBlock {
                switchDepthBlock(indexPath.row)
            }
            
            switch indexPath.row {
            case 0:
                print("默认")
                FCTradeSettingconfig.sharedInstance.depthType = "\(indexPath.row)"
               break
            case 1:
            
                print("买盘")
              break
            case 2:
            
                print("卖盘")
               break
            default:
                break
            }
            
        }else {
            
        }
        
        if let closeAlertBlock = closeAlertBlock {
            closeAlertBlock()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellidentify)
        
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: cellidentify)
            cell?.backgroundColor = .white
            cell?.selectionStyle = .none
        }
        
        var titleL = cell?.contentView.viewWithTag(1998) as? UILabel
        let titleArray = dataSource[indexPath.section]
        if titleL == nil {
            titleL = fc_labelInit(text:"", textColor: COLOR_HexColor(0x696A6D), textFont: UIFont.boldSystemFont(ofSize: 16), bgColor: .white)
            titleL?.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
            titleL?.textAlignment = .center
            titleL?.tag = 1998
            cell?.contentView.addSubview(titleL!)
        }
        
        titleL?.text = titleArray[indexPath.row]
        
        
        if indexPath.section == 0 {
            
            let depthType = FCTradeSettingconfig.sharedInstance.depthType ?? "0"
            if indexPath.row == (depthType as NSString).integerValue{
                
                titleL?.textColor = COLOR_TabBarTintColor
            }else {
                
                titleL?.textColor = COLOR_HexColor(0x696A6D)
            }
    
        }else {
            
            titleL?.textColor = COLOR_HexColor(0x696A6D)
        }
        
        return cell ?? UITableViewCell()
    }
 
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
                   
            return 8
         }else {
            
            return 0.0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if section == 0 {
            
           let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 8))
            sectionView.backgroundColor = COLOR_HexColor(0xf7f7f7)
            return sectionView
        }else {
            
            return UIView()
        }
        
    }
}

