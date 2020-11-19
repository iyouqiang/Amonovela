//
//  FCPersonalDataController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/11.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCPersonalDataController: UIViewController {

    var personalTableView: UITableView!
    var loginOutBtn: UIButton!
    var userInfoModel: FCUserInfoModel!
    
    typealias LoginoutBlock = () -> Void
    
    var loginoutBlock: LoginoutBlock?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BACKGROUNDColor
        self.title = "个人资料"
        
        self.personalTableView = UITableView.init(frame:CGRect(x: 0, y: kNAVIGATIONHEIGHT, width: kSCREENWIDTH, height: self.view.frame.height), style: .plain)

        self.personalTableView.delegate   = self
        self.personalTableView.dataSource = self
        self.personalTableView.separatorStyle = .none
        self.personalTableView.backgroundColor = COLOR_BACKGROUNDColor
        self.view.addSubview(self.personalTableView)
        
        self.loginOutBtn = UIButton(type: .custom)
        self.loginOutBtn.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 44)
        self.loginOutBtn.setTitleColor(COLOR_HighlightColor, for: .normal)
        self.loginOutBtn.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        self.loginOutBtn.setTitle("退  出", for: .normal)
        self.loginOutBtn.backgroundColor = UIColor.white
        self.loginOutBtn.addTarget(self, action: #selector(userLoginoutClick), for: .touchUpInside)
        
        self.personalTableView.tableFooterView = self.loginOutBtn
    }
    
    @objc func userLoginoutClick() {
        
        let apiLogout = FCAPI_Account_logout()
        apiLogout.startWithCompletionBlock(success: { (response) in
            
            self.logintouResult()
            
        }) { (response) in
            
            self.logintouResult()
        }
    }
    
    func logintouResult() {
        
        FCUserInfoManager.sharedInstance.remveUserInfo()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: kNotificationUserLogout), object: nil)
        
        if self.loginoutBlock != nil {
            self.loginoutBlock!()
        }
        
        self.navigationController?.popViewController(animated: true)
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

extension FCPersonalDataController : UITableViewDataSource, UITableViewDelegate { 
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
       return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let viewFooter = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 50))
        viewFooter.backgroundColor = COLOR_BACKGROUNDColor
        return viewFooter
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentify = "cellIdentify"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify)
        
        if cell == nil {
            
            cell = UITableViewCell.init(style: .value1, reuseIdentifier: cellIdentify)
            cell?.textLabel?.textColor = COLOR_PrimeTextColor
            cell?.detailTextLabel?.textColor = COLOR_PrimeTextColor
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 18)
            cell?.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        }
        
        cell?.textLabel?.text = "UID"
        cell?.detailTextLabel?.text = self.userInfoModel.member_id
        
        return cell!
    }
}
