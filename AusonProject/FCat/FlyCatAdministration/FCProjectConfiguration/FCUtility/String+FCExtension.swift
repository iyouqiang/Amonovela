

//
//  String+FCExtension.swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/21.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import Foundation

extension String {
    
    func validator(pattern: String) -> Bool {
        
        let predicate =  NSPredicate(format: "SELF MATCHES %@" ,pattern)
        return predicate.evaluate(with:self)
    }
    
  static func precisionSpecification(value: CGFloat, precision: Int) -> String {
        
        let format = String(format: "%%.%df", precision)
        let resultStr = String(format: format, value)
        return resultStr
    }
}
