//
//  FCUserInfoModel.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/11.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit
import HandyJSON

class FCUserInfoModel: NSObject, HandyJSON, Codable {
    
    // 获取用户信息
    var member_id:String?
    var avatar:String?
    //    var email:String?
    //    var invite_code:String?
    var phone:String?
    
    // 登录接口 差异参数
    var sid:String?
    
    // 隐藏小额资产
    enum Dribblet {
        case dribblet_hidden
        case dribblet_show
    }
    
    //    init(dict: [String: AnyObject]) {
    //        super.init()
    //
    //        let json = JSON(dict)
    //
    //        member_id     = json["member_id"].stringValue
    //        avatar        = json["avatar"].stringValue
    //        email         = json["email"].stringValue
    //        invite_code   = json["invite_code"].stringValue
    //        phone         = json["phone"].stringValue
    //        sid           = json["sid"].stringValue
    //    }
    
    
    //CXP
    //    "data": {
    //        "userId": "33",
    //        "userName": "+86 15195966877",
    //        "phoneCode": "+86",
    //        "phoneNumber": "15195966877",
    //        "email": "",
    //        "state": "1",
    //        "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE2MjQ4MTI0MDEsImlhdCI6MTU5MzI3NjQwMSwibmJmIjoxNTkzMjc2NDAxLCJ1c2VySWQiOiIzMyJ9.R9JoXfxuOj6Qt1Eg0W1llOZTJroov_bASFppekM1nEY"
    //    }
    
    
    required override init() {
        super.init()
    }
    
    @objc var userId: String?
    @objc var userName: String?
    @objc var phoneCode: String?
    @objc var phoneNumber: String?
    @objc var email: String?
    @objc var state: String?
    @objc var invite_code:String?
    @objc var token: String?
    
    static public func stringToObject(jsonData: [String : Any]?) -> FCUserInfoModel {
        return FCUserInfoModel.deserialize(from: jsonData) ?? FCUserInfoModel()
    }
}
