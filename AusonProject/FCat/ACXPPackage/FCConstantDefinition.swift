//
//  FCConstantDefinition.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/4.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import Foundation

func printLog<T>(_ message: T,
                 file: String = #file,
                 method: String = #function,
                 line: Int = #line) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent)[\(line)], \(method): \(message)")
    #endif
}

public func isPhoneX() -> Bool {
    
    if UIScreen.main.bounds.height >= 812 {
        return true
    }
    return false
}

// 回调
typealias kFCBlock = () -> Void

///尺寸
public let kSCREENWIDTH = UIScreen.main.bounds.size.width

public let kSCREENHEIGHT = UIScreen.main.bounds.size.height

public let kSTATUSHEIGHT = UIApplication.shared.statusBarFrame.size.height

public let kMarginScreenLR = 16.0

public let kNAVIGATIONHEIGHT: CGFloat = isPhoneX() ? 88 : 64

public let KSTATUSBARHEIGHT: CGFloat = isPhoneX() ? 44 : 20

let kAPPDELEGATE = UIApplication.shared.delegate as? AppDelegate

public let kTABBARHEIGHT = kAPPDELEGATE?.tabBarViewController.tabBar.frame.height ?? 49

///过滤null的字符串，当nil时返回一个初始化的空字符串
public let kFilterNullOfString:((Any)->String) = {(obj: Any) -> String in
    if obj is String {
        return obj as! String
    }
    return ""
}

/// 过滤null的数组，当nil时返回一个初始化的空数组
public let kFilterNullOfArray:((Any)->Array<Any>) = {(obj: Any) -> Array<Any> in
    if obj is Array<Any> {
        return obj as! Array<Any>
    }
    return Array()
}

/// 过滤null的字典，当为nil时返回一个初始化的字典
public let kFilterNullOfDictionary:((Any) -> Dictionary<AnyHashable, Any>) = {( obj: Any) -> Dictionary<AnyHashable, Any> in
    if obj is Dictionary<AnyHashable, Any> {
        return obj as! Dictionary<AnyHashable, Any>
    }
    return Dictionary()
}

/**************颜色值******************/
public func COLOR_HexColor(_ rgbValue: Int) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: 1.0)
}

public func COLOR_HexColorAlpha(_ rgbValue: Int, alpha: CGFloat) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: alpha)
}

/** 导航栏背景色 */
public let COLOR_navBgColor = COLOR_HexColor(0x212733)

/** cell的背景颜色 **/
public let COLOR_CellBgColor = COLOR_HexColor(0x171D31)

public let COLOR_MainThemeColor = COLOR_HexColor(0xFFC400)

/** 背景色 */
public let COLOR_BACKGROUNDColor = COLOR_HexColor(0xf2f2f2)

/** 背景色 */
public let COLOR_BGColor = COLOR_HexColor(0x171D31)
    //COLOR_HexColor(0x101114)//

public let COLOR_PartingLineColor = COLOR_HexColor(0x0C141A)

/** tabbar颜色 */
public let COLOR_TabBarBgColor  = COLOR_HexColor(0x212733)

public let COLOR_TabBarTintColor  = COLOR_HexColor(0xEFB90C)

/** TabBar选择色 */
public let COLOR_tabbarNormalColor = COLOR_HexColor(0x848D9B)

//COLOR_HexColor(0x101114)
/** page 黄色 */
public let COLOR_YELLOWColor = COLOR_HexColor(0xF4B043)

/** 主要按钮文字颜色（黑色） **/
public let COLOR_ThemeBtnTextColor = COLOR_HexColor(0x131318)

/** 主要按钮左侧颜色 **/
public let COLOR_ThemeBtnStartColor = COLOR_HexColor(0xFFBF17)

/** 主要按钮右侧颜色 **/
public let COLOR_ThemeBtnEndColor = COLOR_HexColor(0xFFAD17)

/** 主要按钮右侧颜色 **/
public let COLOR_ThemeBtnBgColor = COLOR_HexColor(0xFFC017)

/** 按钮文字颜色 **/
public let COLOR_BtnTitleColor = COLOR_HexColor(0xFFB517)

/** 文字按钮颜色(图文按钮) **/
public let COLOR_RichBtnTitleColor = COLOR_HexColor(0x696A6D)

/** 主要文字颜色（白色） **/
public let COLOR_PrimeTextColor = COLOR_HexColor(0xffffff)

/** 次要文字颜色(浅灰) **/
public let COLOR_MinorTextColor = COLOR_HexColor(0x848D9B)

/** 图标坐标刻度数值颜色*/
public let COLOR_ChartAxisColor = COLOR_HexColor(0xDADADD)

/** 图标辅助说明文案颜色*/
public let COLOR_CharTipsColor = COLOR_HexColor(0x8F9698)

/** 页脚文字颜色(浅灰) **/
public let COLOR_FooterTextColor = COLOR_HexColor(0x58595C)

/** 次要文字颜色(紫红) **/
public let COLOR_TipsTextColor = COLOR_HexColor(0xEA1751)

/** cell的背景颜色 水槽颜色 **/
public let COLOR_SectionFooterBgColor = COLOR_HexColor(0x141416)

//COLOR_HexColor(0x191B20)

/** cell的title颜色 **/
public let COLOR_CellTitleColor = COLOR_HexColor(0x6E7E97)

/** cell的message颜色 **/
public let COLOR_CellMessageColor = COLOR_HexColor(0xB0B1B4)

/** 高亮色 */
public let COLOR_HighlightColor = COLOR_HexColor(0xffad17)

/** 副标题文字颜色(黑色) **/
public let COLOR_subTitleColor = COLOR_HexColor(0x4D4D4D )

/** 线条分割线颜色 */
public let COLOR_LineColor = COLOR_HexColor(0x394155)
    //COLOR_HexColorAlpha(0xffffff, alpha: 0.05)

/** 局部背景色 */
public let COLOR_PartColor = COLOR_HexColor(0x2A2F3A)

/** 线条分割线颜色 */
//public let COLOR_SeperateColor = COLOR_HexColor(0x394155)

/** 输入框颜色 */
public let COLOR_InputColor = COLOR_HexColor(0xcccccc)

/**输入框border颜色*/
public let COLOR_InputBorder = COLOR_HexColor(0x434343)

/**输入框文本颜色*/
public let COLOR_InputText = COLOR_HexColor(0xDADADD)

/** 涨跌幅颜色 */
//public let COLOR_RiseColor = COLOR_HexColor(0x2AB462)
//public let COLOR_FailColor = COLOR_HexColor(0xFB4B50)

public let COLOR_RiseColor = COLOR_HexColor(0x2CB362)
public let COLOR_FailColor = COLOR_HexColor(0xF24D5F)

//public let COLOR_BGRiseColor = COLOR_HexColorAlpha(0x2AB462, alpha: 1.0)
//COLOR_HexColor(0x2AB462)
//public let COLOR_BGFailColor = COLOR_HexColorAlpha(0xFB4B50, alpha: 1.0) 

public let COLOR_BGRiseColor = COLOR_HexColorAlpha(0x2CB362 , alpha: 0.1)
public let COLOR_BGFailColor = COLOR_HexColorAlpha(0xE0274A, alpha: 0.1)

public let HOSTURL_SPOT = "http://spot.chainxp.io"
public let HOSTURL_SWAP = "http://swap.chainxp.io"
public let HOSTURL_API  = "http://api.chainxp.io"

public let HOSTURL_INVITE    = "http://chainxp.io/invite"
public let HOSTURL_KYC       = "http://chainxp.io/account/full/kyc"
public let HOSTURL_ASSETS    = "http://c2c.chainxp.io/thirdparty/assets"
public let HOSTURL_TRADE     = "http://c2c.chainxp.io/thirdparty/trade"
public let HOSTURL_MASSETS   = "http://c2c.chainxp.io/thirdparty/assets"
public let HOSTURL_EASYTRADE = "http://c2c.chainxp.io/thirdparty/trade"
public let HOSTURL_NEWGUIDE  = "https://supportchex.zendesk.com/hc/zh-cn/categories/900000201863-%E6%96%B0%E6%89%8B%E6%8C%87%E5%8D%97"
public let HOSTURL_CPEEXCHANGE = "https://supportchex.zendesk.com/hc/zh-cn/articles/900003238606-%E5%85%B3%E4%BA%8EChampagne-Exchange"
public let HOSTURL_TRADESKILL = "https://supportchex.zendesk.com/hc/zh-cn/sections/900000476043-%E6%93%8D%E4%BD%9C%E6%8C%87%E5%BC%95"
public let HOSTURL_DOMAIN = "http://app-api.chainxp.io"

//public let HOSTURL_SPOT = "https://spot.ausonex.com"
//public let HOSTURL_SWAP = "https://swap.ausonex.com"
//public let HOSTURL_API  = "https://api.ausonex.com"
//
//public let HOSTURL_INVITE    = "https://www.ausonex.com/invite"
//public let HOSTURL_KYC       = "https://www.ausonex.com/account/kyc"
//public let HOSTURL_ASSETS    = "https://c2c.ausonex.com/thirdparty/assets"
//public let HOSTURL_TRADE     = "https://c2c.ausonex.com/thirdparty/trade"
//public let HOSTURL_MASSETS   = "https://c2c.ausonex.com/thirdparty/assets"
//public let HOSTURL_EASYTRADE = "https://c2c.ausonex.com/thirdparty/trade"
//public let HOSTURL_NEWGUIDE  = "https://supportchex.zendesk.com/hc/zh-cn/categories/900000201863-%E6%96%B0%E6%89%8B%E6%8C%87%E5%8D%97"
//public let HOSTURL_CPEEXCHANGE = "https://supportchex.zendesk.com/hc/zh-cn/articles/900003238606-%E5%85%B3%E4%BA%8EChampagne-Exchange"
//public let HOSTURL_TRADESKILL = "https://supportchex.zendesk.com/hc/zh-cn/sections/900000476043-%E6%93%8D%E4%BD%9C%E6%8C%87%E5%BC%95"
//public let HOSTURL_DOMAIN = "https://api.ausonex.com"
 
/// 是否固定全仓 
public let onlyCross = true

class FCConstantDefinition: NSObject {
    
    @objc static public func HOSTURL_OC_SPOT() -> String {
        return "http://spot.chainxp.io"
        //return "https://spot.ausonex.com/"
    }
}
