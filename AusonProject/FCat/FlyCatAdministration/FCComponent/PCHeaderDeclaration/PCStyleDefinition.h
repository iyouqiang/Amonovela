//
//  PCStyleDefinition.h
//  PurCowExchange
//
//  Created by Yochi on 2018/6/13.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#import "PCMacroDefinition.h"
#import "UIColor+PCHex.h"
#import "UIFont+Extension.h"
#ifndef PCStyleDefinition_h
#define PCStyleDefinition_h

/** 导航栏背景色 */
#define COLOR_BarNormalColor COLOR_HexColor(0x191B20) //COLOR_HexColor(0x101114)//COLOR_HexColor(0x191B20)

/** 导航啦标题色 */
#define COLOR_NavigationTitleColor   COLOR_HexColor(0x000000)

/** 高亮色 */
#define COLOR_HighlightColor COLOR_HexColor(0xfb7418)

/** 错误提示刷新按钮色 */
#define COLOR_RefreshBtnColor        COLOR_HexColor(0x32A8EF)

/** 界面背景色 */
#define COLOR_BackgroundColor        COLOR_HexColor(0xF2F2F2)

/** 字体颜色 */
#define COLOR_MainTitleColor         COLOR_HexColor(0x1a1a1a)
/** 次要文字颜色(浅灰) **/
#define COLOR_MinorTextColor         COLOR_HexColor(0x999999)

#define COLOR_White    [UIColor whiteColor]

#define COLOR_Clear    [UIColor clearColor]

/** 输入框下划线 */
//[UIColor colorWithHexString:@"#6B6B7C" alpha:0.8]
#define COLOR_UnderLineColor            COLOR_HexColor(0x999999)

/** 警告提示色F36D3F */
#define COLOR_warningColor                COLOR_HexColor(0xF36D3F)

/** 普通按钮背景色 */
#define COLOR_BtnBgColor                  COLOR_HexColor(0x4A90E2)

/** 按钮点击色 */
#define COLOR_BtnTouchDownColor           COLOR_HexColor(0xb3b3b3)

/** 普通按钮边框色 */
#define COLOR_BtnBorderColor             COLOR_HexColor(0x6B6B7C)

/** segmentControl点击色 */
#define COLOR_SegmentControlSelectedColor COLOR_HexColor(0xFB7418)

/** section标题色 */
#define COLOR_TitleSectionColor           COLOR_HexColor(0x666666)

/** 警告提示色F36D3F */
#define COLOR_TimerLColor                 COLOR_HexColor(0xcccccc)

/** 涨跌幅颜色 */
#define COLOR_RiseColor COLOR_HexColor(0x4AA03B)
#define COLOR_FailColor COLOR_HexColor(0xFB7418)

/** 买卖颜色 */
#define COLOR_BuyColor COLOR_HexColor(0x4AA03B)
#define COLOR_SellColor COLOR_HexColor(0xFB7418)

#define COLOR_BuyTouchColor COLOR_HexColor(0x3F8732 )
#define COLOR_SellTouchColor COLOR_HexColor(0xE06716)


#endif /* PCStyleDefinition_h */
