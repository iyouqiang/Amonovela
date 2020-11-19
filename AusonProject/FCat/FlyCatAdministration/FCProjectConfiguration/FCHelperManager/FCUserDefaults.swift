//
//  FCUserDefaults.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/17.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCUserDefaults: NSObject {

    class func objectForKey(_ key: String) -> AnyObject? {
        return UserDefaults.standard.object(forKey: key) as AnyObject?
    }
    
    class func setObject(_ Object: AnyObject?, ForKey key: String, synchronize: Bool) {
        if Object == nil {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }
        UserDefaults.standard.set(Object, forKey: key)
        if synchronize {
            UserDefaults.standard.synchronize()
        }
    }
    
    class func boolForKey(_ key: String) -> Bool {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    class func setBool(_ Object: Bool?, ForKey key: String, synchronize: Bool) {
        if Object == nil {
            UserDefaults.standard.removeObject(forKey: key)
            return
        }
        UserDefaults.standard.set(Object, forKey: key)
        if synchronize {
            UserDefaults.standard.synchronize()
        }
    }
    
    class func removeObjectForKey(_ key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
