//
//  FCAccountAssetController.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/16.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import JXSegmentedView
import SnapKit


class FCAccountAssetController: UIViewController {

    var assetInfoView: FCAccountAssetInfoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = COLOR_BGColor

        self.title = "持币"
        
        assetInfoView = FCAccountAssetInfoView()
        assetInfoView?.parentVC = self
        view.addSubview(assetInfoView!)
        assetInfoView!.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
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

extension FCAccountAssetController : JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return view
    }
}

