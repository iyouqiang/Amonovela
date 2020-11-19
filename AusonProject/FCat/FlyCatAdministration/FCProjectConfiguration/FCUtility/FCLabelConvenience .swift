//
//  FCLabelConvenience .swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/10.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import Foundation

public func fc_labelInit(text: String?, textColor: UIColor?, textFont: CGFloat?, bgColor: UIColor?) -> UILabel {
    
    let label = UILabel()
    label.text = text ?? ""
    label.font = UIFont.init(_customTypeSize: textFont ?? 15)
    label.textColor = textColor ?? COLOR_White
    label.backgroundColor = bgColor ?? COLOR_Clear
    label.numberOfLines = 0
    
    return label
}

public func fc_labelInit(text: String, textColor: UIColor, textFont: UIFont, bgColor: UIColor) -> UILabel {
    
    let label = UILabel()
    label.text = text
    label.font = textFont
    label.textColor = textColor
    label.backgroundColor = bgColor
    label.numberOfLines = 0
    
    return label
}
