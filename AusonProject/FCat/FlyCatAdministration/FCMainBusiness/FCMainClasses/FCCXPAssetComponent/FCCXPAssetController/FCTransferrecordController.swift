//
//  FCTransferrecordController.swift
//  Auson
//
//  Created by Yochi on 2021/1/9.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit

class FCTransferrecordController: UIViewController {

    var dataSource:[FCTransferRecordModel]? = [FCTransferRecordModel]()
    
    private lazy var sectionHeaderView:UIView = {
        
        let sectionView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44))
        sectionView.backgroundColor = COLOR_PartingLineColor
        
        // 币种/划转时间
        let assetL = fc_labelInit(text: "币种/划转时间", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: .clear)
        sectionView.addSubview(assetL)
        
        // 数量
        let numbL = fc_labelInit(text: "数量", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: .clear)
        numbL.textAlignment = .center
        sectionView.addSubview(numbL)
        
        // 划转类型
        let transferTypeL = fc_labelInit(text: "划转类型", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: .clear)
        transferTypeL.textAlignment = .right
        sectionView.addSubview(transferTypeL)
        
        assetL.snp.makeConstraints { (make) in
            
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
        }
        
        numbL.snp.makeConstraints { (make) in
           
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
        
        transferTypeL.snp.makeConstraints { (make) in
            
            make.right.equalTo(-15)
            make.top.bottom.equalToSuperview()
        }
        
        return sectionView
    }()
    
    lazy var recordTableView = { () -> UITableView in
        let recordTableView = UITableView.init(frame: .zero, style: .plain)
        
        recordTableView.delegate = self
        recordTableView.dataSource = self
        recordTableView.rowHeight = 100.0
        recordTableView.tableFooterView = UIView()
        recordTableView.showsVerticalScrollIndicator = false
        recordTableView.separatorColor = COLOR_TabBarBgColor
        recordTableView.layer.masksToBounds = true
        recordTableView.backgroundColor = .clear
        self.view.addSubview(recordTableView)
        recordTableView.snp.makeConstraints { (make) in
            make.top.equalTo(80)
            make.left.right.bottom.equalToSuperview()
        }
        
        recordTableView.register(UINib(nibName: "FCTransferRecordCell", bundle: Bundle.main), forCellReuseIdentifier: "FCTransferRecordCell")
        return recordTableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = COLOR_PartingLineColor
        
        let naviTitleView = UIView()
        self.view.addSubview(naviTitleView)
        naviTitleView.backgroundColor = COLOR_navBgColor
        naviTitleView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(80)
        }
        
        let naviTitleL = fc_labelInit(text: "划转记录", textColor: .white, textFont: UIFont(_PingFangSCTypeSize: 24), bgColor: .clear)
        naviTitleView.addSubview(naviTitleL)
        naviTitleL.snp_makeConstraints { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo(-15)
        }
        
        self.view.addSubview(recordTableView)
        
        loadTransferRecordData()
    }
    
    func loadTransferRecordData() {
        
        let timestampStr = NSString.timestampTo()
        let startDate = currentDateToWantDate(year: 0, month: -6, day: 0)
        let startTimestamp = NSString.dateTotimestamp(startDate)
        
        let startTime: String = (startTimestamp! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        let endTime: String = (timestampStr! as NSString).timestampTodateFormatter("yyyy-MM-dd HH:mm:ss")!
        
        let transferApi = FCApi_transfer_records(startTime: startTime, endTime: endTime, Asset: "All", fromAccount: "", toAccount: "", page: "1", pageSize: "2147483647")
        transferApi.startWithCompletionBlock { [weak self] (response) in
            
            self?.dataSource?.removeAll()
            let responseData = response.responseObject as?  [String : AnyObject]
                       
            if responseData?["err"]?["code"] as? Int ?? -1 == 0 {
                      
                if let data = responseData?["data"] as? [String : Any] {
                    
                    if let records = data["records"] as? [Any] {
                        
                        for dic in records {
                            
                            let recordsModel = FCTransferRecordModel.stringToObject(jsonData: dic as? [String : Any])
                            self?.dataSource?.append(recordsModel)
                        }
                        
                        let totalNum = data["totalNum"] as? Int
                        
                        if (totalNum ?? 0) == 0 {
                            
                            //self?.historyTableView.tableFooterView = self?.footerHint
                            self?.view.unAvailableDataSource("暂无历史数据", imgStr: "", verticalSpace: 2*kNAVIGATIONHEIGHT)
                            
                        }else {
                            
                            self?.view.removePlaceholderView()
                        }
                        
                        self?.recordTableView.reloadData()
                    }
                }
            }
            
        } failure: { [weak self] (response) in
            
            self?.view.unAvailableDataSource("暂无历史数据", imgStr: "", verticalSpace: 2*kNAVIGATIONHEIGHT)
        }
    }
    
    func currentDateToWantDate(year:Int,month:Int,day:Int)->Date {
        let current = Date()
        let calendar = Calendar(identifier: .gregorian)
        var comps:DateComponents?
        
        comps = calendar.dateComponents([.year,.month,.day], from: current)
        comps?.year = year
        comps?.month = month
        comps?.day = day
        return calendar.date(byAdding: comps!, to: current) ?? Date()
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

extension FCTransferrecordController: UITableViewDelegate, UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FCTransferRecordCell") as? FCTransferRecordCell
        if let cell = cell {
            
            if let dataSource = dataSource {
            
                let model = dataSource[indexPath.row]
                cell.transferRecordModel = model
                cell.backgroundColor = COLOR_PartingLineColor
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = self.sectionHeaderView
        return self.dataSource?.count ?? 0 > 0 ? sectionView : UIView()
    }
}
