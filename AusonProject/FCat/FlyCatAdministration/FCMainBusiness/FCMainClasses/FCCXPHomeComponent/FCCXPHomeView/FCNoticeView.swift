//
//  FCNoticeView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

typealias FCClickNoticeAction = (Int) -> Void

class FCNoticeView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    var notiIcon:UIImageView!
    var clickNoticeAction:FCClickNoticeAction?
    
    var dataSource:[FCHomenoticesModel]? {
           didSet {
            guard let dataSource = dataSource else {
                return
            }
            
            var textArray = [String]()
            for noticModel in dataSource {
                textArray.append(noticModel.text ?? "")
            }
            
            self.rollLabel.marqueeContentArray = textArray
            self.rollLabel.block = {
               [weak self] index in
                
                if let clickNoticeAction = self?.clickNoticeAction {
                    clickNoticeAction(index)
                }
            }
            self.rollLabel.start();
        }
    }
    
    private lazy var rollLabel: FCMarqueeView! = {
       
        let rollLabel = FCMarqueeView.init(frame: CGRect(x: 50, y: 0, width: kSCREENWIDTH-60, height: 60))
        addSubview(rollLabel)
        rollLabel.pauseDuration = 2.0
        rollLabel.backgroundColor = .clear
        return rollLabel
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.initsubView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func initsubView() {
        
        notiIcon = UIImageView(image: UIImage(named: "home_notice"))
        addSubview(notiIcon)
        notiIcon.contentMode = .scaleAspectFit
        notiIcon.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.centerY.equalToSuperview()
            make.height.width.equalTo(18)
        }
    }
}
