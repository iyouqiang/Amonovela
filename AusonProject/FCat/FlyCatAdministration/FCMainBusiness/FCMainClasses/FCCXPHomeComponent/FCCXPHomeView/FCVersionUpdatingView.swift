//
//  FCVersionUpdatingView.swift
//  Auson
//
//  Created by Yochi on 2021/1/16.
//  Copyright © 2021 Yochi. All rights reserved.
//

import UIKit

class FCVersionUpdatingView: UIView {

    @IBOutlet weak var updateMessageL: UILabel!
    @IBOutlet weak var pageSizeL: UILabel!
    @IBOutlet weak var versionCodeL: UILabel!
    @IBOutlet weak var cancelBtn: UIButton!
    @IBOutlet weak var updateBtn: UIButton!
    
    var updateAction: (() -> Void)?
    var cancelAction: (() -> Void)?
    
    var updateModel: FCAppUpdateModel? {
        
        didSet {
            guard let updateModel = updateModel else {
                return
            }
            
            var updateMessage = updateModel.updateMsg ?? ""
            if updateMessage.count == 0 {
                updateMessage = "1、修复已知问题\n2、交互优化"
            }
            self.updateMessageL.text = updateMessage
            let viewheight = self.updateMessageL.labelHeightMaxWidth(kSCREENWIDTH - 30)
            self.frame = CGRect(x: 0, y: 0, width: kSCREENWIDTH - 60, height: 300 + viewheight)
            
            var versionCode = updateModel.targetVersion
            var pageSize = updateModel.packageSize
            
            if versionCode?.count == 0 {
                versionCode = "Auson(\(NSString.getAppBuildNumber() ?? ""))"
            }
            self.versionCodeL.text = versionCode
            
            if pageSize?.count == 0 {
                pageSize = "36.6MB"
            }
            self.pageSizeL.text = pageSize
        }
    }
    
    @IBAction func updateAppAction(_ sender: Any) {
        
        if let updateAction = self.updateAction {
            updateAction()
        }
    }
    
    @IBAction func cancelUpdateViewAction(_ sender: Any) {
        
        if let cancelAction = self.cancelAction {
            cancelAction()
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
