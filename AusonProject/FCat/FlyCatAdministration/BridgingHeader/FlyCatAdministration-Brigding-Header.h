//
//  FlyCatAdministration-Brigding-Header.h
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/4.
//  Copyright © 2018年 Yochi. All rights reserved.
//

#ifndef FlyCatAdministration_Brigding_Header_h
#define FlyCatAdministration_Brigding_Header_h

// 业务类
#import "PCNavigationController.h"
#import "PCH5ErrorView.h"
#import "FCMarqueeView.h"

// CXP的Api
#import "PCSlider.h"
#import "FCApi_CountryCode.h"
#import "FCApi_MarketTypes.h"

#import "FCApi_account_register.h"
#import "FCApi_captcha_send.h"
#import "FCApi_captcha_resend.h"
#import "FCApi_captcha_verify.h"
#import "FCApi_login.h"
#import "FCApi_logout.h"
#import "FCApi_market_tickers.h"
#import "FCApi_delete_optional.h"
#import "FCApi_add_optional.h"
#import "FCApi_tickers_latest.h"
#import "FCApi_ticker_trade.h"
#import "UILabel+FJAttribute.h"
#import "UIButton+Gradient.h"
#import "FCUrlArgumentsFilter.h"
#import "FCAPI_Account_logout.h"

//bugly
#import <Bugly/Bugly.h>

// 工具类
#import "PCCookieManager.h"
#import "YTKNetwork.h"
#import "APICommon_report_deviceinfo.h"
#import "PCWebSocketNetwork.h"
#import "FCBannerCarouselView.h"

#import "PCStyleDefinition.h"
#import "PCStaticStrConstants.h"

#import "PCAlertManager.h"

#import "UITableView+PCRefreshExtension.h"
#import "UINavigationBar+CustomStyle.h"
#import "UIImage+PCExtension.h"
#import "UIImageView+WebCache.h"
#import "UIViewController+PCNavigationBar.h"
#import "NSString+PCExtend.h"
#import "UIImage+PCExtension.h"
#import "PCCMethod.h"

//#import "TextInputLimit.h"
#import "Masonry.h"
#import "YYModel.h"

#import "PCUtility.h"
#import "FCShareTool.h"
#import "NSObject+PCRequestExtension.h"
#import "PCWKWebHybridController.h"

#endif /* FlyCatAdministration_Brigding_Header_h */

/// swift 不适用
#ifdef TARGET_VERSION_CPE
/// 
#elif defined TARGET_VERSION_CXP
///
#else
/// defalse
#endif
