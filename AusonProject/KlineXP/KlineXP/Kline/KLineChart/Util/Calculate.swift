//
//  Calculate.swift
//  KLine-Chart
//
//  Created by He on 2020/3/1.
//  Copyright © 2020 hjs. All rights reserved.
//

import UIKit

func clamp<T : Comparable>(value: T,min: T, max: T) -> T {
    if value < min {
        return min
    } else if value > max {
        return max
    } else {
        return value
    }
}

func calculateTextRect(text: String, fontSize: CGFloat) -> CGRect {
     let rect = text.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: 0), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font_DINProBoldTypeSize(size: fontSize)], context: nil)
    //UIFont.systemFont(ofSize: fontSize)
    return rect
}

func calculateDateText(timestamp: Int64, dateFormat: String) -> String {
    let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
    let formater = DateFormatter()
    formater.dateFormat = dateFormat
    return formater.string(from: date)
}

func volFormat(value: CGFloat) -> String {
    if (value > 10000 && value < 999999) {
         let d = value / 1000;
        
         return "\(KLineStateManger.manager.precisionSpecification(value: d))K"
       } else if (value > 1000000) {
         let d = value / 1000000;
         return "\(KLineStateManger.manager.precisionSpecification(value: d))M"
       }
       return KLineStateManger.manager.precisionSpecification(value: value)
}

func precisionSpecification(value: CGFloat, precision: Int) -> String {
      
      let format = String(format: "%%.%df", precision)
      let resultStr = String(format: format, value)
      return resultStr
}
