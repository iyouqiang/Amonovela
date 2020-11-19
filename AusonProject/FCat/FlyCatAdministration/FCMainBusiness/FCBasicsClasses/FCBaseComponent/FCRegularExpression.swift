

//
//  FCRegularExpression.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCRegularExpression: NSObject {

    //校验邮箱是否合法
    static func isEmailLagal(email: String?) -> Bool {
        if let validEmail = email {
            return validEmail.validator(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
        }
        
        return false
    }
    
    static func isLegalpassword (password: String?) -> Bool {
        if let validPwd = password {
            return validPwd.validator(pattern: "^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,20}$")
        }
        
        return false
    }
    
}
