//
//  KLineState.swift
//  KLine-Chart
//
//  Created by He on 2020/3/1.
//  Copyright © 2020 hjs. All rights reserved.
//

import Foundation
public enum KLineDirection: Int {
    case vertical   //竖屏布局
    case horizontal //横屏布局
}

public enum MainState: Int {
    case ma
    case boll
    case none
}

public enum VolState: Int {
    case vol
    case none
}

public enum SecondaryState: Int {
    case macd
    case kdj
    case rsi
    case wr
    case none
}

public enum KLinePeriod: String {
    case min01 = "1"
    case min03 = "3"
    case min05 = "5"
    case min15 = "15"
    case min30 = "30"
    case hour01 = "60"
    case hour02 = "120"
    case hour04 = "240"
    case hour06 = "360"
    case hour12 = "720"
    case day01 = "1D"
    case week01 = "1W"
    case month01 = "1M"
}
