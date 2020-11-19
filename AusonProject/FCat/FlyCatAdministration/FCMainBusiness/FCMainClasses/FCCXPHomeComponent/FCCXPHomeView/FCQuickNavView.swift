//
//  FCQuickNavView.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/8.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

struct FCAlertItemModel {
    let title: String
    let imageName: String
    let isEnabled: Bool
    init(title: String, imageName: String, isEnabled: Bool = true) {
        self.title = title
        self.imageName = imageName
        self.isEnabled = isEnabled
    }
}

typealias FCClickItemAction = (FCAlertItemModel, Int) -> Void

class FCQuickNavView: UIView {

    // 父视图
    private var alertSuperView: UIView!
    private var shadowView: UIView!
    public var containerView: UIView!
    
    /// 菜单栏目数组
    let alertItems: [FCAlertItemModel]
    /// 菜单每列最大展示栏目个数
    var itemMaxShowCountForColumn: Int
    /// 点击回调
    let clickItemAction: FCClickItemAction
    
    private var containerHeight: CGFloat = 0.0
    
    init(items: [FCAlertItemModel], itemMaxShowCountForColumn: Int = 4, clickItemAction: @escaping FCClickItemAction) {
        self.alertItems = items
        self.itemMaxShowCountForColumn = itemMaxShowCountForColumn
        self.clickItemAction = clickItemAction
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {

        // 容器视图
        let containerView = UIView()
        containerView.backgroundColor = COLOR_CellBgColor
        addSubview(containerView)
        self.containerView = containerView
        
        let itemWidth: CGFloat = (kSCREENWIDTH - 30) / CGFloat(itemMaxShowCountForColumn) - 0.01
        let itemHeight: CGFloat = 110.0
        for (index, item) in alertItems.enumerated() {
            // 容器
            let column = index / itemMaxShowCountForColumn
            let menuItem = UIView.init(frame: CGRect(x: itemWidth * CGFloat(index) + 15.0, y: itemHeight * CGFloat(column), width: itemWidth, height: itemHeight))
            containerView.addSubview(menuItem)
            menuItem.backgroundColor = .clear
            
            // 图标
            let image = UIImage(named: item.imageName)
            let iconImageView = UIImageView(image: image)
            menuItem.addSubview(iconImageView)
            iconImageView.snp.makeConstraints { (make) in
                make.top.equalTo(30.0)
                make.centerX.equalToSuperview()
                make.size.equalTo(image?.size ?? CGSize(width: 30.0, height: 30.0))
            }

            // 标题
            let titleLabel = UILabel()
            titleLabel.font = UIFont.systemFont(ofSize: 14)
            titleLabel.text = item.title
            titleLabel.textAlignment = .center
            titleLabel.textColor = COLOR_CellTitleColor
            menuItem.addSubview(titleLabel)
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalTo(iconImageView.snp.bottom).offset(8.0)
                make.centerX.equalToSuperview()
                make.height.equalTo(14.0)
            }

            // control
            let control = UIButton(type: .custom)
            control.addTarget(self, action: #selector(clickItem(sender:)), for: .touchUpInside)
            control.tag = index
            control.isEnabled = item.isEnabled
            menuItem.insertSubview(control, at: 0)
            control.snp.makeConstraints { (make) in

                make.top.equalTo(iconImageView.snp_top).offset(-20)
                make.left.right.equalTo(titleLabel)
                make.bottom.equalTo(titleLabel.snp_bottom).offset(20)
            }
        }
        let column = alertItems.count / itemMaxShowCountForColumn + alertItems.count % itemMaxShowCountForColumn != 0 ? 1 : 0
        containerHeight = CGFloat(column) * itemHeight

        containerView.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(containerHeight)
        }
    }

    @objc func clickItem(sender: UIButton) {
        
        clickItemAction(alertItems[sender.tag], sender.tag)
    }

}
