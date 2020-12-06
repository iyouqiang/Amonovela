//
//  ChartStyle.swift
//  KLine-Chart
//
//  Created by He on 2020/3/1.
//  Copyright © 2020 hjs. All rights reserved.
//

import Foundation
import UIKit

let KLineBundle = Bundle(path: Bundle.main.path(forResource:"KLineBundle", ofType:"bundle") ?? "")

let KLINEPERIODKEY    = "KLINEPERIODKEY"
let KLINEPERIODTIMESHARINGKETY = "KLINEPERIODTIMESHARINGKETY"
let MAINCHARTINDEXKEY = "MAINCHARTINDEXKEY"
let AUXILIARYCHARTKEY = "AUXILIARYCHARTKEY"

/**************颜色值******************/
public func COLOR_KLineColor(_ rgbValue: Int) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: 1.0)
}

public func COLOR_KLineColorAlpha(_ rgbValue: Int, alpha: CGFloat) -> (UIColor) {
    
    return UIColor(red: ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0,
                   green: ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0,
                   blue: ((CGFloat)(rgbValue & 0xFF)) / 255.0,
                   alpha: alpha)
}

class ChartColors {
 
      //背景颜色
    static let bgColor    = COLOR_KLineColor(0x06141D)
    static let kLineColor = COLOR_KLineColor(0x4C86CD)
    static let gridColor  = COLOR_KLineColor(0x4c5c74)
    static let ma5Color   = COLOR_KLineColor(0xC9B885)
    static let ma10Color  = COLOR_KLineColor(0x6CB0A6)
    static let ma30Color  = COLOR_KLineColor(0x9979C6)
    static let upColor    = COLOR_KLineColor(0x2CB362)
    static let dnColor    = COLOR_KLineColor(0xE0274A)
    static let volColor   = COLOR_KLineColor(0x4729AE)
    
    static let macdColor = COLOR_KLineColor(0x4729AE)
    static let difColor  = COLOR_KLineColor(0xC9B885)
    static let deaColor  = COLOR_KLineColor(0x6CB0A6)
    
    static let kColor    = COLOR_KLineColor(0xC9B885)
    static let dColor    = COLOR_KLineColor(0x6CB0A6)
    static let jColor    = COLOR_KLineColor(0x9979C6)
    static let rsiColor  = COLOR_KLineColor(0xC9B885)
    
    static let wrColor  = COLOR_KLineColor(0xD2D2B4)
    
    static let yAxisTextColor = COLOR_KLineColor(0x70839E)  //右边y轴刻度
    static let xAxisTextColor = COLOR_KLineColor(0x60738E)  //下方时间刻度
    
    static let maxMinTextColor = COLOR_KLineColor(0xffffff)  //最大最小值的颜色
    
    //深度颜色
    static let depthBuyColor  = COLOR_KLineColor(0x60A893)
    static let depthSellColor = COLOR_KLineColor(0xC15866)
    
    //选中后显示值边框颜色
    static let markerBorderColor = COLOR_KLineColor(0xFFFFFF)
    
    //选中后显示值背景的填充颜色
    static let markerBgColor = COLOR_KLineColor(0x0D1722)
    
      //实时线颜色等
    static let realTimeBgColor = COLOR_KLineColor(0x0D1722)
    static let rightRealTimeTextColor = COLOR_KLineColor(0x4C86CD)
    static let realTimeTextBorderColor = COLOR_KLineColor(0xffffff)
    static let realTimeTextColor = COLOR_KLineColor(0xffffff)
    
     //实时线
    static let realTimeLineColor = COLOR_KLineColor(0xffffff)
    static let realTimeLongLineColor = COLOR_KLineColor(0x4C86CD)
    
    
    //表格右边文字颜色
    static let reightTextColor = COLOR_KLineColor(0x70839E)
    static let bottomDateTextColor = COLOR_KLineColor(0x70839E)
    
    static let crossHlineColor = COLOR_KLineColor(0x1FFFFFFF)
}

class ChartStyle {

    //点与点的距离（）不用这种方式实现
    static let pointWidth: CGFloat = 11.0

     //蜡烛之间的间距
    static let canldeMargin: CGFloat = 1

     //蜡烛默认宽度
    static  let defaultcandleWidth: CGFloat = 5

     //蜡烛宽度
    static  let candleWidth: CGFloat = 5

     //蜡烛中间线的宽度
    static let  candleLineWidth: CGFloat = 1.5

     //vol柱子宽度
    static let  volWidth: CGFloat = 5

     //macd柱子宽度
    static let  macdWidth: CGFloat = 3.0

     //垂直交叉线宽度
    static let  vCrossWidth: CGFloat = 5

     //水平交叉线宽度
    static let hCrossWidth: CGFloat = 0.5

     //网格
    static let gridRows: Int = 4
    
    static let gridColumns: Int = 5

    static let  topPadding: CGFloat = 30.0
    
    static let  bottomDateHigh: CGFloat = 20.0
    
    static let childPadding: CGFloat = 25.0

    static let  defaultTextSize: CGFloat = 10
    
    static let  bottomDatefontSize: CGFloat = 10
    
    //表格右边文字价格
    static let reightTextSize: CGFloat = 10
    
}
