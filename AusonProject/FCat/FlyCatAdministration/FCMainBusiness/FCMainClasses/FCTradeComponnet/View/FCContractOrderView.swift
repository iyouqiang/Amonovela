//
//  FCTreatyOrderView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/31.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa

class FCContractOrderView: UIView {
    
    let disposeBag = DisposeBag()
    var marketModel: FCMarketModel?
    var depthModel: FCKLineRestingModel?
    var markerSide: String = "Bid"
    var orderType: String  = "Limit"
    
    var askData: [FCKLineDepthModel]?
    var bidData: [FCKLineDepthModel]?
    
    // 深度头部价格 和 数量 title
    var depthpriceTitleL: UILabel!
    var depthamountTitleL: UILabel!
    var marketOrderTitleL: UILabel!
    var priceUnitView: UIView!
    var percentValue = 0.0
    var ratioView: FCBtnSelectedView!
    
    var showProfitLossItemBlock:((_ isFolded: Bool) -> Void)?
    
    // var tradeAsset: FCAssetModel?  //交易币资产
    // var baseAsset: FCAssetModel?   //基础币资产
    
    var accountInfoModel: FCPositionAccountInfoModel? //合约资产
    
    var headerSymbolView: UIView?
    
    //  init(symbol:String, tradingUnit: String, entrustVolume: String, entrustPrice: String, side: String, action: String, tradeType: String, volumeType: String)
    
    /// 计划委托block
    var triggerOrderPlaceBlock: ((_ tradingUnit: String, _ entrustVolume: Float, _ entrustPrice: Float,_ side: String,_ action: String, _ tradeType: String, _ volumeType: String, _ triggerSource: String, _ triggerPrice: String, _ stopLossPrice: String, _ takeProfitPrice: String, _ positionId: String) -> Void)?
    
    /// 定义的block
    var placeOrder: ((_ tradingUnit: String, _ entrustVolume: String, _ entrustPrice: String, _ side: String, _ action: String, _ tradeType: String, _ volumeType: String, _ triggerClose:[String:Any]) -> Void)?
    
    /// 优化 按钮位置  增加逐仓 杠杆  资金费率 结束时间
    var marginModeBtn = fc_buttonInit(imgName: "", title: "全仓模式", fontSize: 14, titleColor: COLOR_InputText, bgColor: .clear)
    
    var leverageBtn = fc_buttonInit(imgName: "trade_downtriangle", title: "50X", fontSize: 14, titleColor: COLOR_CellTitleColor, bgColor: .clear)
    var fundsRateNameL = fc_labelInit(text: "资金费率", textColor: COLOR_CellTitleColor, textFont: UIFont(_PingFangSCTypeSize: 12), bgColor: .clear)
    var endTimeNameL = fc_labelInit(text: "结束时间", textColor: COLOR_CellTitleColor, textFont: UIFont(_PingFangSCTypeSize: 12), bgColor: .clear)
    var fundsRateL = fc_labelInit(text: "0.00%", textColor: .white, textFont: UIFont(_DINProBoldTypeSize: 12), bgColor: .clear)
    var endTimeL = fc_labelInit(text: "00:00:00", textColor: .white, textFont: UIFont(_DINProBoldTypeSize: 12), bgColor: .clear)
    
    lazy var strategyInfoView: UIView = {
        
        let strategyInfoView = UIView(frame: CGRect(x: 0, y: 8, width: kSCREENWIDTH, height: 44))
        strategyInfoView.backgroundColor = COLOR_BGColor
        self.addSubview(strategyInfoView)
        
        /**
        marginModeBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        marginModeBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        marginModeBtn.tintColor = COLOR_InputText
        marginModeBtn.semanticContentAttribute = .forceRightToLeft
        marginModeBtn.layer.cornerRadius = 8
        marginModeBtn.clipsToBounds = true
        marginModeBtn.layer.borderWidth = 0.5
        marginModeBtn.isEnabled = !onlyCross
        
        let image = UIImage.init(named: "trade_downtriangle")?.withRenderingMode(UIImage.RenderingMode.alwaysOriginal)
        if onlyCross == false {
            marginModeBtn.setImage(image, for: .normal)
        }
        
        marginModeBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        marginModeBtn.addTarget(self, action: #selector(changeMarketModelAction), for: .touchUpInside)
        strategyInfoView.addSubview(marginModeBtn)
        marginModeBtn.snp.makeConstraints { (make) in
            make.left.equalTo(15)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(100)
        }
        
        leverageBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        leverageBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        leverageBtn.setImage(image, for: .normal)
        leverageBtn.tintColor = COLOR_InputText
        leverageBtn.semanticContentAttribute = .forceRightToLeft
        leverageBtn.layer.cornerRadius = 5
        leverageBtn.clipsToBounds = true
        leverageBtn.layer.borderWidth = 0.5
        leverageBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        strategyInfoView.addSubview(leverageBtn)
        leverageBtn.addTarget(self, action: #selector(changeLeverageAction), for: .touchUpInside)
        leverageBtn.snp.makeConstraints { (make) in
            make.left.equalTo(marginModeBtn.snp_right).offset(8)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(70)
        }
         */
        
        let width = fundsRateNameL.labelWidthMaxHeight(20)
        
        /// 费率
        strategyInfoView.addSubview(fundsRateNameL)
        strategyInfoView.addSubview(fundsRateL)
        fundsRateNameL.textAlignment = .center
        fundsRateL.textAlignment = .center
        
        /// 倒计时
        strategyInfoView.addSubview(endTimeNameL)
        strategyInfoView.addSubview(endTimeL)
        endTimeNameL.textAlignment = .center
        endTimeL.textAlignment = .center
        
        fundsRateNameL.snp.makeConstraints { (make) in
            make.left.equalTo(endTimeNameL.snp_left)
            make.top.equalToSuperview()
            make.width.equalTo(width)
        }
        
        fundsRateL.snp.makeConstraints { (make) in
            make.centerY.equalTo(fundsRateNameL.snp_centerY)
            make.right.equalToSuperview()
        }
        
        endTimeNameL.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(fundsRateNameL.snp_bottom)
            make.width.equalTo(width)
        }
        
        endTimeL.snp.makeConstraints { (make) in
            make.centerY.equalTo(endTimeNameL.snp_centerY)
            make.right.equalToSuperview()
        }
        
        return strategyInfoView
    }()
    
    /// 剩余时间倒计时
    var timer: Timer?
    var leftSeconds: Int = 0
    
    var contractModel: FCContractsModel? {
        didSet {
            guard  let contractModel = contractModel else {
                return
            }
            
            /// 默认精度
            self.accuracyBtn.setTitle(contractModel.defaultPrecision, for: .normal)
            
            /// 永续合约 symbol
            var title = contractModel.symbol?.replacingOccurrences(of: "-", with: "/") ?? "--/--"
            title = contractModel.name?.count ?? 0 > 0 ? (contractModel.name ?? "") : title
            self.symbolBtn.setTitle("\(title)", for: .normal)
            
            /// 资金费率
            fundsRateL.text = "\(contractModel.fundingRate ?? "0.00")%"
            if (Float(contractModel.fundingRate ?? "0.00") ?? 0) >= 0 {
                
                fundsRateL.textColor = COLOR_RiseColor
            }else {
                fundsRateL.textColor = COLOR_FailColor
            }
            /// 倒计时
            let leftSeconds = Int(contractModel.leftSeconds ?? "0")
            self.leftSeconds = leftSeconds ?? 0
            
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(contractLeftSecondsCountDown), userInfo: nil, repeats: true);
        }
    }
    
    @objc func contractLeftSecondsCountDown() {
        
        leftSeconds = leftSeconds - 1
        let totalminute = (leftSeconds)/60
        let second = (leftSeconds)%60
        let hour = (totalminute)/60
        let minute = (totalminute)%60
        self.endTimeL.text = String(format: "%02d:%02d:%02d", hour, minute, second)
        
        if (leftSeconds == 0) {
            timer?.invalidate()
        }
    }
    
    /// 设置 保证金模式 杠杆策略
    var strateSetModel:FCTradeSettingModel? {
        didSet {
            guard let strateSetModel = strateSetModel else {
                return
            }
            
            /// 使用单例和model都可以设置
            if strateSetModel.accountMode == "Cross" {
                
                self.marginModeBtn.setTitle("全仓模式", for: .normal)
                
            }else {
                
                self.marginModeBtn.setTitle("逐仓模式", for: .normal)
            }
            
            /// 判断当前是买盘还是卖盘 "Bid" "Ask"
            if (self.markerSide == "Bid") {
                /// 卖盘 开多杠杆
                self.leverageBtn.setTitle("\(strateSetModel.longLeverage ?? "")X", for: .normal)
            }else {
                /// 卖盘 开空杠杆
                self.leverageBtn.setTitle("\(strateSetModel.shortLeverage ?? "")X", for: .normal)
            }
        }
    }
    
    /// 指数价格 深度图精度
    var indexPriceL:UILabel!
    var accuracyBtn: UIButton!
    var dropTriangleImgView: UIImageView!
    var depthswitchBtn: UIButton!
    
    /// 底部深度精度
    lazy var indexPriceView: UIView = {
        
        let indexPriceView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH/2.0, height: 25))
        
    
        let indexPriceNameL = fc_labelInit(text: "指数价", textColor: UIColor.white, textFont: UIFont(_PingFangSCTypeSize: 12), bgColor: .clear)
        indexPriceView.addSubview(indexPriceNameL)
        indexPriceNameL.snp.makeConstraints { (make) in
            make.left.top.equalToSuperview()
        }
        
        indexPriceL = fc_labelInit(text: "0.00", textColor: UIColor.white, textFont: UIFont(_DINProBoldTypeSize: 12), bgColor: .clear)
        indexPriceL.textAlignment = .right
        indexPriceView.addSubview(indexPriceL)
        indexPriceL.snp.makeConstraints { (make) in
            make.right.equalTo(indexPriceView.snp_right)
            make.centerY.equalTo(indexPriceNameL.snp_centerY)
        }
        
        /**
         let lineView = UIView()
         lineView.backgroundColor = COLOR_TabBarBgColor
         indexPriceView.addSubview(lineView)
         lineView.snp.makeConstraints { (make) in
         make.bottom.left.right.equalToSuperview()
         make.height.equalTo(0.8)
         }
         */
        
        return indexPriceView
    }()
    
    lazy var accuracyView: UIView = {
        
        let accuracyView = UIView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH/2.0, height: 36))
        accuracyBtn = fc_buttonInit(imgName: "trade_downtriangle", title: "0.1", fontSize: 14, titleColor: COLOR_InputColor, bgColor: .clear)
        accuracyBtn.tintColor = COLOR_InputText
        accuracyBtn.semanticContentAttribute = .forceRightToLeft
        //accuracyBtn.contentHorizontalAlignment = .left
        //accuracyBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        accuracyBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: -5)
        accuracyBtn.backgroundColor = COLOR_HexColor(0x293247)
        accuracyBtn.layer.cornerRadius = 4
        accuracyBtn.clipsToBounds = true
        //accuracyBtn.layer.borderWidth = 0.5
        accuracyBtn.layer.borderColor = COLOR_RichBtnTitleColor.cgColor
        accuracyView.addSubview(accuracyBtn)
        accuracyBtn.addTarget(self, action: #selector(changeaccuracyAction), for: .touchDown)
        
        dropTriangleImgView = UIImageView(image: UIImage(named: "trade_downtriangle"))
        accuracyBtn.addSubview(dropTriangleImgView)
        dropTriangleImgView.isHidden = true
        /// 列表 
        depthswitchBtn = fc_buttonInit(imgName: "TradingonIcon")
        depthswitchBtn.contentHorizontalAlignment = .right
        depthswitchBtn.addTarget(self, action: #selector(changeDepthViewAction), for: .touchUpInside)
        accuracyView.addSubview(depthswitchBtn)
        
        depthswitchBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview()
            make.height.width.equalTo(24)
        }
        
        accuracyBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.right.equalTo(depthswitchBtn.snp_left).offset(-10)
        }
        
        dropTriangleImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-10)
        }
        
        return accuracyView
    }()
    
    //Header
    lazy var symbolBtn: UIButton = {
        let button = UIButton(type: .custom)
        button.contentHorizontalAlignment = .left
        button.setTitle("--/--", for: .normal)
        button.setImage(UIImage(named: "kline_drawer"), for: .normal)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.font = UIFont(_DINProBoldTypeSize: 18)
        button.setTitleColor(.white, for: .normal)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 0)
        return button
    }()
    
    lazy var changeLab: UILabel = {
        
        //let lab = fc_labelInit(text: "0.00%", textColor: COLOR_RiseColor, textFont: 13, bgColor: UIColor.clear)
        let lab = fc_labelInit(text: "0.00%", textColor: COLOR_RiseColor, textFont: UIFont(_DINProBoldTypeSize: 13), bgColor: .clear)
        
        return lab
    }()
    
    lazy var changeView: UIView = {
        let changeView = UIView.init(frame: .zero)
        changeView.backgroundColor = .clear
        //changeView.backgroundColor = COLOR_HexColorAlpha(0x39CC43, alpha: 0.2)
        changeView.layer.cornerRadius = 8
        changeView.layer.masksToBounds = true
        return changeView
    }()
    
    lazy var klineBtn: UIButton = {
        let button = fc_buttonInit(imgName: "trade_kline", title: "", fontSize: 17, titleColor: UIColor.white, bgColor: .clear)
        return button
    }()
    
    lazy var ktradeSettingBtn: UIButton = {
        let button = fc_buttonInit(imgName: "tradingMore", title: "", fontSize: 17, titleColor: UIColor.white, bgColor: .clear)
        return button
    }()
    
    //Left
    let leftView: UIView = UIView.init(frame: .zero)
    lazy var bidBtn: UIButton = {
        let bidBtn = fc_buttonInit(imgName: "", title: "开多", fontSize: 14, titleColor: UIColor.white, bgColor: UIColor.clear)
        let tintImage = UIImage(named: "kline_buyBtnBg")
        let selectImg = tintImage?.imageWithTintColor(color: COLOR_RiseColor)
        let normalImg = tintImage?.imageWithTintColor(color: COLOR_HexColor(0x3E4046))
        bidBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        bidBtn.setTitleColor(COLOR_tabbarNormalColor, for: .normal)
        bidBtn.setTitleColor(UIColor.white, for: .selected)
        bidBtn.isSelected = true
        bidBtn.setBackgroundImage(normalImg, for: .normal)
        bidBtn.setBackgroundImage(selectImg, for: .selected)
        bidBtn.setImage(UIImage(named: "trade_buyNormal"), for: .normal)
        bidBtn.setImage(UIImage(named: "trade_buyHighlight"), for: .selected)
        return bidBtn
    }()
    lazy var askBtn: UIButton = {
        let askBtn = fc_buttonInit(imgName: "", title: "开空", fontSize: 14, titleColor: UIColor.white, bgColor: UIColor.clear)
        let tintImage = UIImage(named: "kline_sellBtnBg")
        let selectImg = tintImage?.imageWithTintColor(color: COLOR_FailColor)
        let normalImg = tintImage?.imageWithTintColor(color: COLOR_HexColor(0x3E4046))
        askBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -8, bottom: 0, right: 8)
        askBtn.setTitleColor(COLOR_tabbarNormalColor, for: .normal)
        askBtn.setTitleColor(UIColor.white, for: .selected)
        askBtn.setBackgroundImage(normalImg, for: .normal)
        askBtn.setBackgroundImage(selectImg, for: .selected)
        askBtn.setImage(UIImage(named: "trade_saleNormal"), for: .normal)
        askBtn.setImage(UIImage(named: "trade_saleHighlight"), for: .selected)
        return askBtn
    }()
    
    lazy var typeLab: UILabel = {
        let typeLab = fc_labelInit(text: "限价委托", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: COLOR_BGColor)
        return typeLab
    }()
    
    lazy var typeImgView: UIImageView = {
        let arrowImgView = UIImageView.init(frame: .zero)
        arrowImgView.image = UIImage(named: "trade_downtriangle")
        return arrowImgView
    }()
    
    lazy var typeBtn: UIButton = {
        let typeBtn = UIButton.init(type: .custom)
        typeBtn.backgroundColor = UIColor.clear
        return typeBtn
    }()
    
    lazy var typeView: UIView = {
        let typeView = UIView.init(frame: .zero)
        typeView.backgroundColor = COLOR_BGColor
        
        //leverageBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -5)
        leverageBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: -8)
        leverageBtn.tintColor = COLOR_InputText
        leverageBtn.semanticContentAttribute = .forceRightToLeft
        leverageBtn.addTarget(self, action: #selector(changeLeverageAction), for: .touchUpInside)
        
        return typeView
    }()
    
    lazy var leverageView: UIView = {
        let typeView = UIView.init(frame: .zero)
        typeView.backgroundColor = COLOR_BGColor
        typeView.layer.cornerRadius = 5
        typeView.layer.borderWidth = 0.5
        typeView.layer.borderColor = COLOR_InputBorder.cgColor
        
        return typeView
    }()
    
    lazy var dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = ["限价委托", "市价委托", "计划委托"]
        dropDown.anchorView = self.typeBtn
        dropDown.textFont = UIFont.init(_PingFangSCTypeSize: 14)
        dropDown.textColor = COLOR_CellTitleColor
        dropDown.cellHeight = 36
        dropDown.bottomOffset = CGPoint(x: 0, y: 36)
        dropDown.backgroundColor = COLOR_HexColor(0x2A2F3A)
        dropDown.separatorColor = .clear
        dropDown.shadowOpacity = 0
        dropDown.layer.cornerRadius = 5
        dropDown.selectionBackgroundColor = COLOR_HexColor(0x2A2F3A)
        dropDown.selectedTextColor = COLOR_CellTitleColor
        return dropDown
    }()
    
    lazy var dropMoreSettingDown: DropDown = {
        let dropMoreSettingDown = DropDown()
        dropMoreSettingDown.dataSource = ["  合约设置  ", "  添加自选  "]
        dropMoreSettingDown.anchorView = self.ktradeSettingBtn
        dropMoreSettingDown.textFont = UIFont.init(_PingFangSCTypeSize: 14)
        dropMoreSettingDown.textColor = COLOR_CellTitleColor
        dropMoreSettingDown.cellHeight = 36
        dropMoreSettingDown.bottomOffset = CGPoint(x: 0, y: 36)
        dropMoreSettingDown.backgroundColor = COLOR_HexColor(0x2A2F3A)
        dropMoreSettingDown.separatorColor = .clear
        dropMoreSettingDown.shadowOpacity = 0
        dropMoreSettingDown.layer.cornerRadius = 5
        dropMoreSettingDown.selectionBackgroundColor = COLOR_HexColor(0x2A2F3A)
        dropMoreSettingDown.selectedTextColor = COLOR_CellTitleColor
        return dropMoreSettingDown
    }()
    
    lazy var accuracyViewDropDown: DropDown = {
        let dropMoreSettingDown = DropDown()
        dropMoreSettingDown.shadowOpacity = 0
        
//        dropMoreSettingDown.selectionAction = {
//            (index: Int, title: String) in
//            
//            UIView.animate(withDuration: 0.3, animations: {[weak self] () -> () in
//                
//                self?.dropTriangleImgView.transform = (self?.dropTriangleImgView.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
//            })
//            
//            self.accuracyBtn.setTitle(title, for: .normal)
//        }
        
        //dropMoreSettingDown.dataSource = ["1", "0.01", "0.1", "10"]
        dropMoreSettingDown.anchorView = self.accuracyBtn
        dropMoreSettingDown.textFont = UIFont.init(_DINProBoldTypeSize: 12)
        dropMoreSettingDown.textColor = COLOR_CellTitleColor
        dropMoreSettingDown.cellHeight = 30
        dropMoreSettingDown.bottomOffset = CGPoint(x: 0, y: 36)
        dropMoreSettingDown.backgroundColor = COLOR_HexColor(0x2A2F3A)
        dropMoreSettingDown.separatorColor = .clear
        dropMoreSettingDown.shadowOpacity = 0
        dropMoreSettingDown.layer.cornerRadius = 5
        dropMoreSettingDown.selectionBackgroundColor = COLOR_HexColor(0x2A2F3A)
        dropMoreSettingDown.selectedTextColor = COLOR_CellTitleColor
        return dropMoreSettingDown
    }()
    
    /// 标记价格单位 
    lazy var tagPriceUnitLab: UILabel = {
        let tagPriceUnitLab = fc_labelInit(text: "USDT 触发价", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: COLOR_BGColor)
        tagPriceUnitLab.setAttributeColor(.white, range: NSRange(location: 5, length: 3))
        tagPriceUnitLab.textAlignment = .right
        tagPriceUnitLab.numberOfLines = 0
        tagPriceUnitLab.adjustsFontSizeToFitWidth = true
        return tagPriceUnitLab
    }()
    
    /// 标记价格输入框
    lazy var tagPriceTxd: UITextField = {
        
        /// 限价委托显示下输入 //
        let priceTxd = fc_textfiledInit(placeholder: "价格", holderColor: COLOR_CellTitleColor, textColor: .white, fontSize: 14, borderStyle: .roundedRect)
        priceTxd.attributedPlaceholder = NSAttributedString.init(string: "价格", attributes: [NSAttributedString.Key.font:UIFont(_PingFangSCTypeSize: 14),NSAttributedString.Key.foregroundColor:COLOR_CellTitleColor])
        priceTxd.setValue(3, forKey: "paddingLeft")
        priceTxd.rightViewMode = .always
        priceTxd.backgroundColor = COLOR_BGColor
        priceTxd.layer.borderWidth = 0.7
        priceTxd.layer.borderColor = COLOR_HexColor(0x293247).cgColor
        priceTxd.layer.cornerRadius = 5
        priceTxd.delegate = self
        priceTxd.tintColor = COLOR_InputText
        
        return priceTxd
    }()
    
    /// 计划委托下拉列表
    lazy var planEntrustDrop: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = ["委托价", "市场价", "对手价"]
        dropDown.anchorView = priceUnitLab
        // dropDown.selectRow(0)  //默认选中
        dropDown.textFont = UIFont.init(_PingFangSCTypeSize: 14)
        dropDown.textColor = COLOR_PrimeTextColor
        dropDown.cellHeight = 36
        dropDown.selectionBackgroundColor = .clear
        dropDown.selectedTextColor = COLOR_PrimeTextColor
        dropDown.bottomOffset = CGPoint(x: 0, y: 36)
        dropDown.backgroundColor = COLOR_HexColor(0x232529)
        dropDown.separatorColor = .clear
        dropDown.shadowOpacity = 0
        //dropDown.separatorInsetLeft = true //分割线左对齐
        
        dropDown.selectionAction = {
            (index: Int, title: String) in
            
            if title == "委托价" {
                
                self.orderType = "Limit"
                self.marketOrderTitleL.isHidden = true
                
            }else if (title == "市场价") {
                
                self.orderType = "Market"
                self.marketOrderTitleL.text = "最优市场价格"
                self.marketOrderTitleL.isHidden = false
                self.marketOrderTitleL.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(self.priceTxd)
                    make.left.equalTo(8)
                    make.right.equalTo(-52)
                    make.height.equalTo(32)
                }
                
            }else {
                
                self.orderType = "Limit"
                self.marketOrderTitleL.text = "最优对手价"
                self.marketOrderTitleL.snp.remakeConstraints { (make) in
                    make.centerY.equalTo(self.priceTxd)
                    make.left.equalTo(8)
                    make.right.equalTo(-52)
                    make.height.equalTo(32)
                }
                self.marketOrderTitleL.isHidden = false
            }
            
            self.priceUnitLab.text = "USDT \(title)"
            self.priceUnitLab.setAttributeColor(.white, range: NSRange(location: 5, length: title.count))
        }
        
        return dropDown
    }()

    /// 价格输入框
    lazy var priceTxd: UITextField = {
        
        /// 限价委托显示下输入
        let priceTxd = fc_textfiledInit(placeholder: "价格", holderColor: COLOR_CellTitleColor, textColor: .white, fontSize: 14, borderStyle: .roundedRect)
        priceTxd.attributedPlaceholder = NSAttributedString.init(string: "价格", attributes: [NSAttributedString.Key.font:UIFont(_PingFangSCTypeSize: 14),NSAttributedString.Key.foregroundColor:COLOR_CellTitleColor])
        priceTxd.setValue(3, forKey: "paddingLeft")
        priceTxd.rightViewMode = .always
        priceTxd.backgroundColor = COLOR_BGColor
        priceTxd.layer.borderWidth = 0.7
        priceTxd.layer.borderColor = COLOR_HexColor(0x293247).cgColor
        priceTxd.layer.cornerRadius = 5
        priceTxd.delegate = self
        priceTxd.tintColor = COLOR_InputText
        
        /// 市价委托显示提示
        marketOrderTitleL = fc_labelInit(text: "最优市场价格", textColor: COLOR_CellTitleColor, textFont: UIFont(_PingFangSCTypeSize: 14), bgColor: .clear)
        marketOrderTitleL.textAlignment = .left
        marketOrderTitleL.backgroundColor = COLOR_BGColor
        //marketOrderTitleL.layer.borderWidth = 0.5
        marketOrderTitleL.layer.borderColor = COLOR_InputBorder.cgColor
        marketOrderTitleL.layer.cornerRadius = 5
        marketOrderTitleL.tintColor = COLOR_InputText
        marketOrderTitleL.isHidden = true
        
        return priceTxd
    }()
    
    lazy var amountTxd: UITextField = {
        let amountTxd = fc_textfiledInit(placeholder: "数量", holderColor: COLOR_CellTitleColor, textColor: .white, fontSize: 14, borderStyle: .roundedRect)
        amountTxd.attributedPlaceholder = NSAttributedString.init(string: "数量", attributes: [NSAttributedString.Key.font:UIFont(_PingFangSCTypeSize: 14),NSAttributedString.Key.foregroundColor:COLOR_CellTitleColor])
        amountTxd.setValue(3, forKey: "paddingLeft")
        amountTxd.rightViewMode = .always
        amountTxd.backgroundColor = COLOR_BGColor
        amountTxd.layer.borderWidth = 0.7
        amountTxd.layer.borderColor = COLOR_HexColor(0x293247).cgColor
        amountTxd.layer.cornerRadius = 5
        amountTxd.delegate = self
        amountTxd.tintColor = COLOR_InputText
        return amountTxd
    }()
    
    lazy var priceUnitLab: UILabel = {
        let priceUnitLab = fc_labelInit(text: "USDT", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: COLOR_BGColor)
        priceUnitLab.adjustsFontSizeToFitWidth = true
        priceUnitLab.textAlignment = .right
        priceUnitLab.numberOfLines = 0
        let tap = UITapGestureRecognizer(target: self, action: #selector(planEntrustSelected))
        priceUnitLab.addGestureRecognizer(tap)
        priceUnitLab.isEnabled = true
        priceUnitLab.isUserInteractionEnabled = true
        
        return priceUnitLab
    }()
    
    lazy var amountUnitLab: UILabel = {
        let amountUnitLab = fc_labelInit(text: "张", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: COLOR_BGColor)
        amountUnitLab.adjustsFontSizeToFitWidth = true
        amountUnitLab.textAlignment = .right
        amountUnitLab.numberOfLines = 0
        return amountUnitLab
    }()
    
    lazy var convertLab: UILabel = { 
        //let convertLab = fc_labelInit(text: "0.00", textColor: COLOR_InputText, textFont: 12, bgColor: UIColor.clear)
        let convertLab = fc_labelInit(text: "0.00", textColor: COLOR_InputText, textFont: UIFont(_DINProBoldTypeSize: 12), bgColor: UIColor.clear)
        return convertLab
    }()
    
    lazy var marginTitleL: UILabel = {
        let marginTitleL = fc_labelInit(text: "保证金", textColor: COLOR_CellTitleColor, textFont: 12, bgColor: UIColor.clear)
        return marginTitleL
    }()
    
    lazy var slider: PCSlider = {
        let slider = PCSlider.init(frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 30) / 2.0, height: 30), scaleLineNumber: 4)
        slider?.isHidden = true
        slider?.setSliderValue(0.0)
        return slider!
    }()
    
    lazy var volumeTitleLab: UILabel = {
        //let titleLab = fc_labelInit(text: "可用", textColor: COLOR_CharTipsColor, textFont: 15, bgColor: COLOR_BGColor)
        
        let titleLab = fc_labelInit(text: "可用", textColor: COLOR_CellTitleColor, textFont: UIFont(_PingFangSCTypeSize: 13), bgColor: .clear)
        return titleLab
    }()
    
    lazy var sliderPercentL: UILabel = {
        let titleLab = fc_labelInit(text: "0%", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: COLOR_BGColor)
        titleLab.textAlignment = .right
        titleLab.isHidden = true
        return titleLab
    }()
    
    lazy var volumeLab: UILabel = {
        let volumeLab = fc_labelInit(text: "-.--", textColor: .white, textFont: UIFont(_DINProBoldTypeSize: 13), bgColor: .clear)
        volumeLab.numberOfLines = 0
        return volumeLab
    }()
    
    lazy var estimateTitleLab: UILabel = {
        let titleLab = fc_labelInit(text: "可开多", textColor: COLOR_CellTitleColor, textFont: UIFont(_PingFangSCTypeSize: 13), bgColor: .clear)
        return titleLab
    }()
    
    lazy var estimateLab: UILabel = {
        //let volumeLab = fc_labelInit(text: "-.--", textColor: COLOR_InputText, textFont: 15, bgColor: COLOR_BGColor)
        let volumeLab = fc_labelInit(text: "-.--", textColor: .white, textFont: UIFont(_DINProBoldTypeSize: 13), bgColor: .clear)
        volumeLab.numberOfLines = 0
        return volumeLab
    }()
    
    lazy var orderBtn: UIButton = {
        let orderBtn = fc_buttonInit(imgName: nil, title: "买入开多", fontSize: 16, titleColor: UIColor.white, bgColor: COLOR_RiseColor)
        orderBtn.addTarget(self, action: #selector(placeAnorderAction), for: .touchUpInside)
        orderBtn.layer.cornerRadius = 2
        orderBtn.layer.masksToBounds = true
        return orderBtn
    }()
    
    /// 止盈止损 
    var profitArrowIcon: UIImageView = UIImageView(image: UIImage(named: "trade_downtriangle"))
   
    lazy var profitLossBtn: UIButton = {
        let profitLossBtn = fc_buttonInit(imgName: nil, title: "止盈止损", fontSize: 14, titleColor: COLOR_CellTitleColor, bgColor: .clear)
        profitLossBtn.addTarget(self, action: #selector(showProfitLossViewAction), for: .touchUpInside)
        profitLossBtn.addSubview(self.profitArrowIcon)
        profitArrowIcon.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(20)
        }
        
        //self.profitArrowIcon.transform = (self.profitArrowIcon.transform).rotated(by: 180 * CGFloat(Double.pi/180)) 
        
        return profitLossBtn
    }()
    
    lazy var profitLossView:FCContractProfitLossView = {
        
        let profitLossView = FCContractProfitLossView()
        profitLossView.isHidden = true
        profitLossView.alpha = 0.0
        
        return profitLossView
    }()

    //Right
    let rightView: UIView = UIView.init(frame: .zero)
    
    lazy var depthTableView: UITableView = {
        let depthTableView = UITableView.init(frame: .zero, style: .grouped)
        depthTableView.isScrollEnabled = false
        depthTableView.separatorInset = .zero
        depthTableView.separatorStyle = .none
        depthTableView.delegate = self
        depthTableView.dataSource = self
        //COLOR_HexColorAlpha(0x141416, alpha: 0.7)
        depthTableView.separatorColor = COLOR_HexColor(0x141416)
        depthTableView.backgroundColor = COLOR_BGColor
        depthTableView.tableHeaderView = self.dethHeader
        return depthTableView
    }()
    
    lazy var dethHeader: UIView = {
        let dethHeader = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 25))
        let priceTitle = fc_labelInit(text: "价格", textColor: COLOR_CellTitleColor, textFont: 12, bgColor: UIColor.clear)
        
        let amountTitle = fc_labelInit(text: "数量", textColor: COLOR_CellTitleColor, textFont: 12, bgColor: UIColor.clear)
        
        dethHeader.addSubview(priceTitle)
        dethHeader.addSubview(amountTitle)
        self.depthamountTitleL = amountTitle
        self.depthpriceTitleL = priceTitle
        
        priceTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        amountTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview()
            make.left.greaterThanOrEqualTo(priceTitle.snp_right).offset(5)
        }
        
        return dethHeader
    }()
    
    lazy var dethFooter: UIView = {
        
        let dethFooter = UIView.init(frame: .zero)
        dethFooter.addSubview(dethPriceLab)
        dethFooter.addSubview(priceEstimateLab)
        dethPriceLab.snp.makeConstraints { (make) in
            //make.top.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-12)
        }
        
        priceEstimateLab.snp.makeConstraints { (make) in
            //make.bottom.equalToSuperview().offset(-16)
            make.right.equalToSuperview()
            //make.right.lessThanOrEqualToSuperview().offset(-12)
            // make.bottom.lessThanOrEqualTo(-12)
            make.centerY.equalTo(dethPriceLab.snp_centerY)
        }
        
        let line1View = UIView()
        line1View.backgroundColor = COLOR_LineColor
        dethFooter.addSubview(line1View)
        
        let line2View = UIView()
        line2View.backgroundColor = COLOR_LineColor
        dethFooter.addSubview(line2View)
        
        line1View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.7)
            make.bottom.equalTo(dethPriceLab.snp_top).offset(-10)
        }
        
        line2View.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(0.7)
            make.top.equalTo(dethPriceLab.snp_bottom).offset(10)
        }

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dethPrceSeletedItem))
        dethFooter.addGestureRecognizer(tapGesture)
        
        return dethFooter
    }()
    
    lazy var dethPriceLab: UILabel = {
        //let dethPriceLab = fc_labelInit(text: "-.--", textColor: COLOR_RiseColor, textFont: 14, bgColor: UIColor.clear)
        let dethPriceLab = fc_labelInit(text: "0.00", textColor: COLOR_RiseColor, textFont: UIFont(_DINProBoldTypeSize: 14), bgColor: .clear)
        return dethPriceLab
    }()
    
    lazy var priceEstimateLab: UILabel = {
        //let priceEstimateLab = fc_labelInit(text: "≈-.--", textColor: COLOR_MinorTextColor, textFont: 12, bgColor: UIColor.clear)
        let priceEstimateLab = fc_labelInit(text: "0.00", textColor: COLOR_MinorTextColor, textFont: UIFont(_DINProBoldTypeSize: 12), bgColor: .clear)
        return priceEstimateLab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        loadSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func loadSubviews() {
        self.backgroundColor = COLOR_BGColor
        loadHeader()
        loadLeftView()
    }
    
    func loadHeader () {
        
        let header = UIView.init(frame: .zero)
        header.backgroundColor = COLOR_navBgColor
        self.addSubview(header)
        
        self.headerSymbolView = header
        
        changeView.addSubview(self.changeLab)
        header.addSubview(changeView)
        header.addSubview(self.symbolBtn)
        header.addSubview(self.klineBtn)
        header.addSubview(self.ktradeSettingBtn)
        
        header.snp.makeConstraints { (make) in
            //make.top.equalTo(strategyInfoView.snp_bottom).offset(10)
            make.top.equalTo(0)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(45)
        }
        
        self.symbolBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
        }
        
        changeView.snp.makeConstraints { (make) in
            make.left.equalTo(self.symbolBtn.snp.right).offset(5)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
        
        changeLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(5)
            make.right.equalToSuperview().offset(-5)
            make.height.equalToSuperview()
        }
        
        self.klineBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalToSuperview()
            //make.right.equalToSuperview().offset(-12)
            make.right.equalTo(self.ktradeSettingBtn.snp_left).offset(-12)
        }
        
        self.ktradeSettingBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
    }
    
    func loadLeftView () {
        
        leftView.addSubview(bidBtn)
        leftView.addSubview(askBtn)
        
        self.addSubview(leftView)
        self.addSubview(depthTableView)
        self.addSubview(indexPriceView)
        self.addSubview(accuracyView)
        self.addSubview(self.strategyInfoView)
        
        let segLineView = UIView()
        segLineView.backgroundColor = COLOR_HexColor(0x12151B)
        self.addSubview(segLineView)
        
        segLineView.snp_makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(5)
        }
        
        depthTableView.snp.makeConstraints { (make) in
            make.top.equalTo(leftView.snp_top).offset(30)
            make.height.equalTo(345)
            make.left.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        leftView.snp.makeConstraints { (make) in
            make.top.equalTo(self.headerSymbolView!.snp_bottom).offset(15)
            make.left.equalTo(depthTableView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(depthTableView).multipliedBy(1.4)
            make.height.equalTo(480)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        indexPriceView.snp.makeConstraints { (make) in
            make.top.equalTo(leftView.snp_top)
            make.height.equalTo(25)
            make.left.equalTo(depthTableView.snp_left)
            make.width.equalTo(depthTableView.snp_width)
        }
        
        accuracyView.snp.makeConstraints { (make) in
            make.top.equalTo(depthTableView.snp_bottom).offset(10)
            make.height.equalTo(24)
            make.left.equalTo(depthTableView.snp_left)
            make.width.equalTo(depthTableView.snp_width)
        }
        
        strategyInfoView.snp.makeConstraints { (make) in
            make.left.right.equalTo(depthTableView)
            make.top.equalTo(accuracyView.snp_bottom).offset(10)
            make.height.equalTo(36)
        }
        
        bidBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.height.equalTo(32)
        }
        
        askBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(bidBtn.snp_centerY)
            make.left.equalTo(bidBtn.snp.right).offset(-5)
            make.right.equalToSuperview()
            make.height.equalTo(32)
            make.width.equalTo(bidBtn)
        }
        
        bidBtn.rx.tap.subscribe { [weak self](event) in

            self?.bidBtn.isSelected = true
            self?.askBtn.isSelected = false
            self?.markerSide = "Bid"
            self?.orderBtn.backgroundColor = COLOR_RiseColor
            self?.orderBtn.setTitle("买入开多", for: .normal)
            self?.loadAmountData(markerSide: "Bid")
            self?.leverageBtn.setTitle("\(self?.strateSetModel?.longLeverage ?? "")X", for: .normal)
            self?.slider.setSliderValue(0.0)
            
        }.disposed(by: self.disposeBag)
        
        askBtn.rx.tap.subscribe { [weak self](event) in
            self?.bidBtn.isSelected = false
            self?.askBtn.isSelected = true
            self?.markerSide = "Ask"
            self?.orderBtn.backgroundColor = COLOR_FailColor
            self?.orderBtn.setTitle("卖出开空", for: .normal)
            self?.loadAmountData(markerSide: "Ask")
            self?.leverageBtn.setTitle("\(self?.strateSetModel?.shortLeverage ?? "")X", for: .normal)
            self?.slider.setSliderValue(0.0)
        }.disposed(by: self.disposeBag)
        
        //下单类型
        typeView.addSubview(typeLab)
        typeView.addSubview(typeImgView)
        typeView.addSubview(typeBtn)
        typeView.addSubview(leverageBtn)
        leftView.addSubview(typeView)
        
  
        
        leverageBtn.snp.makeConstraints { (make) in
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(70)
        }
        
        typeLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        typeImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalTo(typeLab.snp_right).offset(8)
            make.size.equalTo(CGSize(width: 13, height: 7.5))
        }
        
        typeBtn.snp.makeConstraints { (make) in
            make.edges.equalTo(typeLab.snp_edges)
        }
        
        typeView.snp.makeConstraints { (make) in
            make.top.equalTo(askBtn.snp.bottom).offset(15)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        // 交互
        typeBtn.rx.tap.subscribe { (event) in
            self.dropDown.show()
        }.disposed(by: self.disposeBag)
        
        self.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            
            self?.priceTxd.text = ""
            self?.tagPriceTxd.text = ""
            
            //self?.orderType = index == 0 ? "Market" : "Limit"
            //self?.typeLab.text = index == 0 ? "限价委托" : "市价委托"
            
            if index == 0 {
                
                self?.priceUnitLab.isUserInteractionEnabled = false
                self?.orderType = "Limit"
                self?.typeLab.text = "限价委托"
                self?.marketOrderTitleL.isHidden = true
                self?.tagPriceTxd.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
                self?.priceUnitView.frame = CGRect(x: 0, y: 0, width: 45, height: 36)
                //self?.priceTxd.rightView = self?.priceUnitView
                self?.priceUnitLab.text = "USDT"
                self?.tagPriceTxd.isHidden = true
                self?.profitLossBtn.isHidden = false
                self?.profitLossBtn.snp.updateConstraints { (make) in
                    
                    make.height.equalTo(22)
                }
            }else if (index == 1) {
                
                self?.priceUnitLab.isUserInteractionEnabled = false
                self?.orderType = "Market"
                self?.typeLab.text = "市价委托"
                self?.marketOrderTitleL.isHidden = false
                self?.marketOrderTitleL.text = "最优市场价"
                self?.marketOrderTitleL.snp.remakeConstraints { (make) in
                    make.centerY.equalTo((self?.priceTxd)!)
                    make.left.equalTo(8)
                    make.right.equalTo(-8)
                    make.height.equalTo(32)
                }
                self?.tagPriceTxd.snp.updateConstraints({ (make) in
                    make.height.equalTo(0)
                })
                self?.priceUnitView.frame = CGRect(x: 0, y: 0, width: 45, height: 36)
                //self?.priceTxd.rightView = self?.priceUnitView
                self?.priceUnitLab.text = "USDT"
                self?.tagPriceTxd.isHidden = true
                self?.profitLossBtn.isHidden = false
                self?.profitLossBtn.snp.updateConstraints { (make) in
                    
                    make.height.equalTo(22)
                }
            }else {
                
                self?.priceUnitLab.isUserInteractionEnabled = true
                self?.typeLab.text = "计划委托"
                self?.orderType = "Limit"
                self?.priceUnitLab.text = "USDT 委托价"
                self?.priceUnitView.frame = CGRect(x: 0, y: 0, width: 90, height: 36)
                //self?.priceTxd.rightView = self?.priceUnitView
                self?.priceUnitLab.setAttributeColor(.white, range: NSRange(location: 5, length: 3))
                self?.marketOrderTitleL.isHidden = true
                self?.tagPriceTxd.isHidden = false
                self?.tagPriceTxd.snp.updateConstraints({ (make) in
                    make.height.equalTo(36)
                })
                self?.profitLossBtn.isHidden = true
                self?.profitLossBtn.snp.updateConstraints { (make) in
                    
                    make.height.equalTo(0)
                }
                self?.showProfitLossView(isShow: false)
            }
        }
        
        /// 标记价格
       let tagPriceUnitView = UIView.init(frame: CGRect(x: 0, y: 0, width: 85, height: 36))
        tagPriceUnitView.addSubview(tagPriceUnitLab)
        tagPriceTxd.rightView = tagPriceUnitView
        leftView.addSubview(tagPriceTxd)
        tagPriceTxd.isHidden = true
        tagPriceTxd.snp.makeConstraints { (make) in
            make.top.equalTo(typeView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0)
        }
        
        tagPriceUnitLab.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
            make.width.greaterThanOrEqualTo(45)
        }
        
        // 价格
        priceUnitView = UIView.init(frame: CGRect(x: 0, y: 0, width: 40, height: 36))
        priceUnitView.addSubview(priceUnitLab)
        priceTxd.rightView = priceUnitView
        leftView.addSubview(priceTxd)
        leftView.addSubview(marketOrderTitleL)
        
        priceUnitLab.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
            //make.width.greaterThanOrEqualTo(80)
            make.width.greaterThanOrEqualTo(45)
        }
        
        priceTxd.snp.makeConstraints { (make) in
            make.top.equalTo(tagPriceTxd.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        marketOrderTitleL.snp.makeConstraints { (make) in
            make.centerY.equalTo(priceTxd)
            make.left.equalTo(8)
            make.right.equalTo(-52)
            make.height.equalTo(32)
        }
        
        // 数量
        let amountUnitView = UIView.init(frame: CGRect(x: 0, y: 0, width: 45, height: 36))
        amountUnitView.addSubview(amountUnitLab)
        amountTxd.rightView = amountUnitView
        leftView.addSubview(amountTxd)
        leftView.addSubview(convertLab)
        leftView.addSubview(marginTitleL)
        leftView.addSubview(slider)
        leftView.addSubview(sliderPercentL)
        leftView.addSubview(profitLossBtn)
        leftView.addSubview(profitLossView)
        
        // 交易额&提交
        leftView.addSubview(volumeTitleLab)
        leftView.addSubview(volumeLab)
        leftView.addSubview(estimateTitleLab)
        leftView.addSubview(estimateLab)
        leftView.addSubview(orderBtn)
        
        ratioView = FCBtnSelectedView(frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 60) * 0.6, height: 36))
        ratioView.cornerRadius = 5
        ratioView.titleColor = COLOR_tabbarNormalColor
        ratioView.borderColor = COLOR_LineColor
        ratioView.clipsToBounds = true
        ratioView.titleArray = ["25%", "50%", "75%", "100%"]
        leftView.addSubview(ratioView)
        
        amountUnitLab.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
            make.width.greaterThanOrEqualTo(45)
        }
        
        amountTxd.snp.makeConstraints { (make) in
            make.top.equalTo(priceTxd.snp_bottom).offset(20)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        convertLab.snp.makeConstraints { (make) in
            make.top.equalTo(amountTxd.snp_bottom).offset(5)
            make.right.equalToSuperview()
        }
        
        marginTitleL.snp.makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(amountTxd.snp_bottom).offset(5)
        }
        
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(convertLab.snp_bottom).offset(10)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        sliderPercentL.snp.makeConstraints { (make) in
            make.right.equalTo(slider.snp_right)
            make.top.equalTo(slider.snp_bottom)
            make.height.equalTo(22)
        }
        
        profitLossBtn.snp.makeConstraints { (make) in
            
            make.left.equalToSuperview()
            make.top.equalTo(ratioView.snp_bottom).offset(20)
            make.height.equalTo(22)
        }
        
        profitLossView.snp.makeConstraints { (make) in
            
            make.left.right.equalToSuperview()
            make.top.equalTo(profitLossBtn.snp_bottom).offset(0)
            make.height.equalTo(0)
        }
        
        amountTxd.rx.text.orEmpty.asObservable().subscribe(onNext: { (text) in
            let value = Double(text) ?? 0.0
            let availableLongVolume = Double(self.accountInfoModel?.symbolAccount?.availableLongVolume ?? "0") ?? 0.0
            let availableShortVolume = Double(self.accountInfoModel?.symbolAccount?.availableShortVolume ?? "0") ?? 0.0
            
            /// 合约size
            let size = Double(self.contractModel?.size ?? "1")!
            
            if (availableLongVolume == 0.0 && self.markerSide == "Bid" || availableShortVolume == 0.0 && self.markerSide == "Ask" )  {
                //self.slider.setSliderValue(0.0)
            } else if (self.markerSide == "Bid") {
                //self.slider.setSliderValue( min(Float(value / availableLongVolume), 1.0) )
            } else {
                //self.slider.setSliderValue( min(Float(value / availableShortVolume), 1.0) )
            }
            
            self.slider.setSliderValue(0.0)
            
            //最小交易单位与张数的转换
            let arrayStrings: [String] = self.accountInfoModel?.symbolAccount?.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
            
            let tradingUnitStr = arrayStrings.first ?? ""
            var contractAsset = self.marketModel?.asset ?? ""
            if contractAsset.count == 0 {
                contractAsset = tradingUnitStr
            }
            
            // 价格*数据量/杠杆
            var leverage = Double(self.strateSetModel?.shortLeverage ?? "0") ?? 0.0
            if (self.markerSide == "Bid") {
                /// 卖盘 开多杠杆
                leverage = Double(self.strateSetModel?.longLeverage ?? "0") ?? 0.0
            }
            
            let priceValue = Double(self.priceTxd.text ?? "0") ?? 0.0
            let qtyFactor = self.contractModel?.qtyFactor ?? 1.0
            self.convertLab.text = String(format: "%0.4f", ((value*priceValue*qtyFactor)/(leverage)))
            
            if (leverage == 0.0) {self.convertLab.text = "0.00"}
            
            /// 合约单位判断
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
                
                /// 张 =？币
                //self.convertLab.text = String(format:"≈%.4f \(contractAsset)", (value * size))
            }else {
                
                //币 =？ 张
                //self.convertLab.text = String(format:"≈%.0f \("(张)")", (value/size))
            }
            
            
        }).disposed(by: self.disposeBag)
        
        slider.monitorSliderValue { (value) in
            
            self.amountTxd.endEditing(true)
            /// 合约size
            let size = Double(self.contractModel?.size ?? "1")!

            self.sliderPercentL.text = String(format: "%.0f%%", value * 100)
            let availableLongVolume = Double(self.accountInfoModel?.symbolAccount?.availableLongVolume ?? "0") ?? 0.0
            let availableShortVolume = Double(self.accountInfoModel?.symbolAccount?.availableShortVolume ?? "0") ?? 0.0
            
            //最小交易单位与张数的转换
            let arrayStrings: [String] = self.accountInfoModel?.symbolAccount?.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
            
            var availableVolume = 0.00
            if(self.markerSide == "Bid") {
                //self.amountTxd.text = String(format: "%.4f", Double(value) * availableLongVolume)
                availableVolume = availableLongVolume
            } else {
                //self.amountTxd.text = String(format: "%.4f", Double(value) * availableShortVolume)
                availableVolume = availableShortVolume
            }
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
                
                self.amountTxd.text = String(format: "%.0f", Double(value) * availableVolume)
                
                /// 张 =？币
                //self.convertLab.text = String(format:"≈%.4f \(arrayStrings.first ?? "")", (Double(value) * availableVolume * size))
            }else {
                
                self.amountTxd.text = String(format: "%.4f", Double(value) * availableVolume)
                
                //币 =？ 张
                //self.convertLab.text = String(format:"≈%.0f \("(张)")", (Double(value) * availableVolume))
            }
        }
        
        ratioView.clickItemBlock = {
            
            [weak self] (index, str) in
            
                if index == 0 {
  
                    self?.percentValue = 0.25
                    
                }else if (index == 1) {
                  
                    self?.percentValue = 0.50
                    
                }else if (index == 2) {
                    
                    self?.percentValue = 0.75
                }else {
                  
                    self?.percentValue = 1.0
                }
            
            let value = self?.percentValue ?? 0.0
            
            self?.amountTxd.endEditing(true)
            /// 合约size
            let size = Double(self?.contractModel?.size ?? "1")!

            self?.sliderPercentL.text = String(format: "%.0f%%", value * 100)
            let availableLongVolume = Double(self?.accountInfoModel?.symbolAccount?.availableLongVolume ?? "0") ?? 0.0
            let availableShortVolume = Double(self?.accountInfoModel?.symbolAccount?.availableShortVolume ?? "0") ?? 0.0
            
            //最小交易单位与张数的转换
            let arrayStrings: [String] = self?.accountInfoModel?.symbolAccount?.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
            
            var availableVolume = 0.00
            if(self?.markerSide == "Bid") {
                //self.amountTxd.text = String(format: "%.4f", Double(value) * availableLongVolume)
                availableVolume = availableLongVolume
            } else {
                //self.amountTxd.text = String(format: "%.4f", Double(value) * availableShortVolume)
                availableVolume = availableShortVolume
            }
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
                
                self?.amountTxd.text = String(format: "%.0f", Double(value) * availableVolume)
                
                /// 张 =？币
                //self?.convertLab.text = String(format:"≈%.4f \(arrayStrings.first ?? "")", (Double(value) * availableVolume * size))
            }else {
                
                self?.amountTxd.text = String(format: "%.4f", Double(value) * availableVolume)
                
                //币 =？ 张
                //self?.convertLab.text = String(format:"≈%.0f \("(张)")", (Double(value) * availableVolume))
            }
            
            // 价格*数据量/杠杆
            var leverage = Double(self?.strateSetModel?.shortLeverage ?? "0") ?? 0.0
            if (self?.markerSide == "Bid") {
                /// 卖盘 开多杠杆
                leverage = Double(self?.strateSetModel?.longLeverage ?? "0") ?? 0.0
            }
            
            let amountValue = Double(self?.amountTxd.text ?? "0") ?? 0.0
            let priceValue = Double(self?.priceTxd.text ?? "0") ?? 0.0
            let qtyFactor = self?.contractModel?.qtyFactor ?? 1.0
            self?.convertLab.text = String(format: "%0.4f", (amountValue*priceValue*qtyFactor)/(leverage))
        }
    
        ratioView.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(convertLab.snp_bottom).offset(20)
            make.height.equalTo(36)
            make.right.equalToSuperview()
        }
        
        volumeTitleLab.snp.makeConstraints { (make) in
            
            make.top.equalTo(profitLossView.snp_bottom).offset(50)
            make.left.equalToSuperview()
        }
        
        volumeLab.snp.makeConstraints { (make) in
            
            make.centerY.equalTo(volumeTitleLab.snp_centerY)
            make.right.equalToSuperview()
            //make.left.equalTo(volumeTitleLab.snp_right)
            // make.right.lessThanOrEqualToSuperview()
        }
        
        estimateTitleLab.snp.makeConstraints { (make) in
            
            make.top.equalTo(volumeTitleLab.snp_bottom).offset(5)
            make.left.equalToSuperview()
        }
        
        estimateLab.snp.makeConstraints { (make) in
            
            make.top.equalTo(volumeTitleLab.snp_bottom).offset(5)
            make.right.equalToSuperview()
            //make.left.equalTo(estimateTitleLab.snp_right)
            // make.right.lessThanOrEqualToSuperview()
        }
        
        orderBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(estimateLab.snp_bottom).offset(16)
            make.height.equalTo(37)
        }
    }

    func loadAssetsData (accountInfoModel: FCPositionAccountInfoModel?) {
        self.accountInfoModel = accountInfoModel
        self.loadAmountData(markerSide: self.markerSide)
    }
    
    func loadAmountData(markerSide: String) {
        
        let arrayStrings: [String] = accountInfoModel?.symbolAccount?.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
        
        if self.markerSide == "Bid" {
            /// 开多
            let volume = accountInfoModel?.symbolAccount?.availableLongVolume
            self.estimateLab.text = volume
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {
                
                let volumeValue = Float(volume ?? "0")!
                //let size = Float(self.contractModel?.size ?? "0")!
                self.estimateLab.text = String(format: "%0.4f", volumeValue)
            }
        }else {
            /// 开空
            let volume = accountInfoModel?.symbolAccount?.availableShortVolume
            self.estimateLab.text = volume
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {
                
                let volumeValue = Float(volume ?? "0")!
                //let size = Float(self.contractModel?.size ?? "0")!
                self.estimateLab.text = String(format: "%0.4f", volumeValue)
            }
        }
    
        let tradingUnitStr = FCTradeSettingconfig.sharedInstance.tradingUnitStr
        var contractAsset = self.marketModel?.asset ?? ""
        if contractAsset.count == 0 {
            contractAsset = tradingUnitStr
        }
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            
            contractAsset = "张"
        }
    
        self.estimateTitleLab.text = "\(self.markerSide == "Bid" ? "可开多" : "可开空")(\(contractAsset))："
        self.amountUnitLab.text = contractAsset
        /// 可用
        self.volumeTitleLab.text = "可用(\(arrayStrings.last ?? ""))："
        self.volumeLab.text = accountInfoModel?.account?.availableMargin
    }
    
    /// 配置深度数据 
    func loadDepthDatas(depthModel: FCKLineRestingModel?) {
        self.depthModel = depthModel

        //最多截取前6个 切换
        if FCTradeSettingconfig.sharedInstance.depthType == "0" {
            /// 默认状态 上下显示 六点
            self.askData = depthModel?.asks?.suffix(6)
            var count = depthModel?.bids?.count ?? 0 <= 6 ? (depthModel?.bids?.count ?? 0) : 6
            count = (count - 1) < 0 ? 0 : (count - 1)
            
            if (depthModel?.bids?.count ?? 0 > count) {
                self.bidData = Array(depthModel?.bids?[0...count] ?? [])
            }
            
        }else {
            
            /// 非默认状态 显示12条
            self.askData = depthModel?.asks?.suffix(12)
            var count = depthModel?.bids?.count ?? 0 <= 11 ? (depthModel?.bids?.count ?? 0) : 11
            count = (count - 1) < 0 ? 0 : (count - 1)
            
            if depthModel?.bids?.count ?? 0 > count {
                self.bidData = Array(depthModel?.bids?[0...count] ?? [])
            }
        }

        /// 头部信息 单位信息设置
        let arrayStrings: [String] = self.accountInfoModel?.symbolAccount?.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
        self.depthpriceTitleL.text = "价格"
        //"价格(\(arrayStrings.last ?? "/"))"

        /// 单位设置
        let tradingUnitStr = FCTradeSettingconfig.sharedInstance.tradingUnitStr
        var contractAsset = self.marketModel?.asset ?? ""
        if contractAsset.count == 0 {
            contractAsset = tradingUnitStr
        }
        
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            contractAsset = "张"
        }
        
        self.depthamountTitleL.text = "数量"
            //"数量(\(contractAsset))"
        
        self.amountUnitLab.text = contractAsset
        
        /// 刷新界面数据
        self.dethPriceLab.text = depthModel?.latestTrade?.price
        self.changeLab.text = "\(depthModel?.latestTrade?.changePercentage ?? "0.00")%"
        if (((depthModel?.latestTrade?.changePercentage ?? "0.00") as NSString).floatValue >= 0) {
            
            //changeView.backgroundColor = COLOR_HexColorAlpha(0x2CB362, alpha: 0.2)
            self.changeLab.textColor = COLOR_RiseColor
        }else {
            self.changeLab.textColor = COLOR_FailColor
            //changeView.backgroundColor = COLOR_HexColorAlpha(0xE0274A, alpha: 0.2)
        }
        
        self.priceEstimateLab.text = "\(depthModel?.latestTrade?.estimatedValue ?? "") \(depthModel?.latestTrade?.estimatedCurrency ?? "")"
        
        /// 指数价格
        self.indexPriceL.text = depthModel?.latestTrade?.indexPrice ?? "0.00"
        
        /// 资金费率费率
        fundsRateL.text = "\(depthModel?.fundingRate ?? "0.00")%"
        
        /// 修改最新价格颜色
        /// up是绿，down是红的，Stable就是不变，是白色的
        if let latestTrade = depthModel?.latestTrade {
            
            if latestTrade.priceSide == "Up" {
                
                self.dethPriceLab.textColor = COLOR_FailColor
            }else if latestTrade.priceSide == "Down" {
                
                self.dethPriceLab.textColor = COLOR_RiseColor
            }else {
                self.dethPriceLab.textColor = COLOR_RiseColor
            }
        }
        
        /// 设置深度精度
        if let precisions = depthModel?.precisions {
            var sourceArray = [String]()
            for  model in precisions {
                sourceArray.append(model.precision)
            }
            
            self.accuracyViewDropDown.dataSource = sourceArray
        }
        
        /// 指数价格 数量 价格
        self.depthTableView.reloadData()
    }
    
    @objc func dethPrceSeletedItem() {
        self.priceTxd.text = dethPriceLab.text ?? ""
    }
    
    @objc func changeMarketModelAction() {
        
        let accountTypeVC = FCContractAccountTypeController()
        accountTypeVC.contractTypeSWitchBlock = {
            [weak self] (str, marginModeType) in
            
            if (marginModeType == .marginMode_Cross) {
                
                self?.marginModeBtn.setTitle("全仓模式", for: .normal)
            }else {
                
                self?.marginModeBtn.setTitle("逐仓模式", for: .normal)
            }
        }
        accountTypeVC.hidesBottomBarWhenPushed = true
        kAPPDELEGATE?.topViewController?.navigationController?.pushViewController(accountTypeVC, animated: true)
    }
    
    @objc func changeLeverageAction() {
        
        let leverageVC = FCContractLeverageController()
        if (self.markerSide == "Bid") {
            leverageVC.leverType = .LeverageType_long // 开多 开空
        }else {
            leverageVC.leverType = .LeverageType_short // 开多 开空
        }
        
        kAPPDELEGATE?.topViewController?.navigationController?.pushViewController(leverageVC, animated: true)
        leverageVC.leveragestrategyBlock = {
            
            /// 判断当前是买盘还是卖盘 "Bid" "Ask"
            if (self.markerSide == "Bid") {
                /// 卖盘 开多杠杆
                self.leverageBtn.setTitle("\(FCTradeSettingconfig.sharedInstance.longLeverage ?? "")X", for: .normal)
            }else {
                /// 卖盘 开空杠杆
                self.leverageBtn.setTitle("\(FCTradeSettingconfig.sharedInstance.shortLeverage ?? "")X", for: .normal)
            }
        }
    }
    
    @objc func showProfitLossViewAction() {
        
        showProfitLossView(isShow:self.profitLossView.isHidden)
    }
    
    @objc func showProfitLossView(isShow:Bool) {
        
        /// 界面是否折叠
        if let showProfitLossItemBlock = self.showProfitLossItemBlock {
            showProfitLossItemBlock(!isShow)
        }
        
        let height = isShow ? 100 : 0
        
        if isShow == false {
            
            self.profitLossView.snp.updateConstraints { (make) in
                make.top.equalTo(profitLossBtn.snp_bottom).offset(0)
                make.height.equalTo(height)
            }
            
            self.leftView.snp.updateConstraints { (make) in
                make.height.equalTo(480)
            }
            
        }else {
            
            self.profitLossView.snp.updateConstraints { (make) in
                make.top.equalTo(profitLossBtn.snp_bottom).offset(20)
                make.height.equalTo(height)
            }
            
            self.leftView.snp.updateConstraints { (make) in
                make.height.equalTo(590)
            }
            
        }
    
        self.profitLossView.isHidden = !isShow
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] () -> () in
            self?.profitLossView.alpha = (self?.profitLossView.isHidden ?? false) ? 0.0 : 1.0
            self?.profitArrowIcon.transform = (self?.profitArrowIcon.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
        })
    }
    
    /// 合约下单
    @objc func placeAnorderAction() {
    
        /**
         var placeOrder: ((_ tradingUnit: String, _ entrustVolume: String, _ entrustPrice: String, _ side: String, _ action: String, _ tradeType: String, _ volumeType: String) -> Void)?
         */
        self.endEditing(true)
        
        var entrustPrice = self.priceTxd.text ?? ""
        let side = self.markerSide
        let action = "Open"
        let tradeType = self.orderType
        
        /// 交易单位
        var tradingUnit = "COIN"
        if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
            
            tradingUnit = "CONT"
        }
        
        /// 交易量
        var entrustVolume = self.amountTxd.text ?? "0.0"
        
        /// 交易量类型
        var volumeType = "Cont"
        
        /// 选择了百分比下单
        if self.slider.value > 0 {
            volumeType = "Percentage"
            entrustVolume = String(format: "%0.4f", self.slider.value)
        }
        
        /// 计划委托下单
        if self.typeLab.text?.contains("计划委托") == true {
            
            /// 最新价成交 
            var triggerSource = "TradePrice"
            if self.tagPriceTxd.text?.count ?? 0 > 0 {
                /// 按触发价触发
                triggerSource = "FairPrice"
            }
            
            /// 选择了对手价，则以深度的第一数据成交
            if ((self.priceUnitLab.text?.contains("对手价")) == true) {
                
                if side == "Bid" {
                    
                    entrustPrice = self.askData?.first?.price ?? "0.00"
                }else {
                    //Ask
                    entrustPrice = self.bidData?.first?.price ?? "0.00"
                }
            }
            
            let stopLossPrice = self.profitLossView.stopLossView.priceTxd.text ?? ""
            let takeProfitPrice = self.profitLossView.stopProfitView.priceTxd.text ?? ""
            let positionId = "" /// 开仓不填
            
            let triggerPrice = self.tagPriceTxd.text ?? ""
            
            self.triggerOrderPlaceBlock?(tradingUnit, Float(entrustVolume) ?? 0, Float(entrustPrice) ?? 0,side, action,tradeType, volumeType, triggerSource, triggerPrice, stopLossPrice, takeProfitPrice, positionId)
            
            return
        }
        
        let triggerUserId = FCUserInfoManager.sharedInstance.userInfo?.userId ?? ""
        let triggerSource = "FairPrice"
        let stopLossPrice = self.profitLossView.stopLossView.priceTxd.text ?? ""
        let takeProfitPrice = self.profitLossView.stopProfitView.priceTxd.text ?? ""
        let triggerClose = ["userId" : triggerUserId,
                            "triggerSource" : triggerSource,
                            "stopLossPrice" : stopLossPrice,
                            "takeProfitPrice" : takeProfitPrice,
                            "entrustVolume" : Float(entrustVolume) ?? 0.0,
                            "volumeType" : volumeType,
                            "tradingUnit" : tradingUnit,
                            "entrustTradeType" : self.orderType,
                            "action": "Close"] as [String : Any]
        
        /// 合约下单
        self.placeOrder?(tradingUnit, entrustVolume, entrustPrice, side, action, tradeType, volumeType,triggerClose)
    }
    
    @objc func planEntrustSelected() {
        
        self.planEntrustDrop.show()
    }
    
    @objc func changeaccuracyAction() {
        
        UIView.animate(withDuration: 0.3, animations: {[weak self] () -> () in
            
            self?.dropTriangleImgView.transform = (self?.dropTriangleImgView.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
        })
        
        self.accuracyViewDropDown.show()
    }
    
    @objc func changeDepthViewAction() {
        
        let selectAlert = FCContractDepthAlertVeiw(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 200))
        let alertView = PCCustomAlert(customView: selectAlert)
        selectAlert.closeAlertBlock = {
            
            alertView?.disappear()
        }
    }
    
    func caculateEstimateValue () {
        
    }
}

extension FCContractOrderView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if (self.askData?.count ?? 0 > indexPath.row) {
                
                let model = self.askData?[indexPath.row];
                self.priceTxd.text = model?.price
            }
            
        } else {
            
            if (self.bidData?.count ?? 0 > indexPath.row) {
                
                let model = self.bidData?[indexPath.row]
                self.priceTxd.text = model?.price
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        /// 卖盘
        let headerView = UIView.init(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 1))
        headerView.backgroundColor = COLOR_HexColor(0x141416)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if FCTradeSettingconfig.sharedInstance.depthType == "1" {
            
            /// 买盘
            return section == 0  ? self.dethFooter : UIView()
            
        }else if (FCTradeSettingconfig.sharedInstance.depthType == "2") {
            
            /// 卖盘
            return section == 0  ? self.dethFooter : UIView()
        }else {
            
            return section == 0  ? self.dethFooter : UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if FCTradeSettingconfig.sharedInstance.depthType == "1" {
            
            /// 买盘
            return section == 0  ? 70 : 8
            
        }else if (FCTradeSettingconfig.sharedInstance.depthType == "2") {
            
            /// 卖盘
            return section == 0  ? 70 : 8
        }else {
            
            return 70
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if FCTradeSettingconfig.sharedInstance.depthType == "1" {
            
            /// 买盘
            return section == 0  ? 0 : 12
            
        }else if (FCTradeSettingconfig.sharedInstance.depthType == "2") {
            
            /// 卖盘
            return section == 0  ? 12 : 0
        }else {
            
            if section == 0 {
                
                return self.askData?.count ?? 0 > 6 ? 6 :  self.askData?.count ?? 0
                
            }else {
                
                return self.bidData?.count ?? 0 > 6 ? 6 :  self.bidData?.count ?? 0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 21
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell? = nil
        if indexPath.section == 0 {//卖
            
            if ((self.askData?.count ?? 0 < 6) && indexPath.row < (6 - (self.askData?.count ?? 0))) {
                //显示占位的cell
                cell =  FCTradeEmptyCell.init(style: .default, reuseIdentifier: "FCTradeEmptyCellReuseId")
            } else {
                let depthCell = FCTradeDepthCell.init(style: .default, reuseIdentifier: "FCTradeDepthCellReuseId")
                //depthCell.loadData(model: self.askData?[indexPath.row], isSell: true)
                if let contractModel = self.contractModel {
                                
                    if indexPath.row < self.askData?.count ?? 0 {
                      
                        depthCell.loadContractData(model: self.askData?[indexPath.row], contractModel: contractModel, isSell: true)
                    }
                    
                }
                cell = depthCell
            }
        } else {//买
            if (self.bidData?.count ?? 0 > indexPath.row && self.askData?.count ?? 0 > indexPath.row) {
                let depthCell = FCTradeDepthCell.init(style: .default, reuseIdentifier: "FCTradeDepthCellReuseId")
                //depthCell.loadData(model: self.bidData?[indexPath.row], isSell: false)
                if let contractModel = self.contractModel {
                    
                    depthCell.loadContractData(model: self.bidData?[indexPath.row], contractModel: contractModel, isSell: false)
                }
              
                cell = depthCell
            } else {
                //显示占位的cell
                cell = FCTradeEmptyCell.init(style: .default, reuseIdentifier: "FCTradeEmptyCellReuseId")
            }
        }
        return cell ?? UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
}

extension FCContractOrderView: UITextFieldDelegate

{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == amountTxd {
            self.slider.setSliderValue(0.0)
            sliderPercentL.text = "0%"
            self.percentValue = 0.0
            ratioView.selectedBtn?.isSelected = false
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string.count == 0 {
            return true
        }
        
        if textField.text?.contains(".") == true && string == "." {
          
            return false
        }
        
        let characterSet = CharacterSet.init(charactersIn: ".0123456789")
        
        if string.rangeOfCharacter(from: characterSet) == nil,
            !string.isEmpty {
            return false
        }
        
        /// 获取精度
        if textField == amountTxd {
            
            let arrayStrings: [String] = self.marketModel?.size.split(separator: ".").compactMap { "\($0)" } ?? []
            let limitCount = (arrayStrings.last)?.count ?? 4
            
            let tempStr = textField.text!.appending(string)
            let strlen = tempStr.count

            let pointRange = (textField.text! as NSString).range(of: ".")
            if pointRange.length > 0 && pointRange.location > 0
            {
                if string == "." {
                    return false
                }

                if strlen > 0 && (strlen - pointRange.location) > limitCount + 1 {
                            
                    return false
                }
            }
        }
    
        return true
    }
}

