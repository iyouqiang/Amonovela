//
//  FCPlaceOrderView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/8/9.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa

class FCSpotOrderView: UIView {
    
    let disposeBag = DisposeBag()
    var marketModel: FCMarketModel?
    var depthModel: FCKLineRestingModel?
    var markerSide: String = "Bid"
    var orderType: String = "Limit"
    var marketOrderTitleL: UILabel!
    
    var askData: [FCKLineDepthModel]?
    var bidData: [FCKLineDepthModel]?
    
    var tradeAsset: FCAssetModel?  //交易币资产
    var baseAsset: FCAssetModel? //基础币资产
    
    var placeOrder: ((_ price: String, _ amount: String, _ orderType: String, _ markerSide: String) -> Void)?
    
    //Header
    lazy var symbolBtn: UIButton = {
        let button = fc_buttonInit(imgName: "kline_drawer", title: "--/--", fontSize: 17, titleColor: COLOR_White, bgColor: COLOR_BGColor)
        return button
    }()
    
    lazy var changeLab: UILabel = {
        let lab = fc_labelInit(text: "0.00%", textColor: COLOR_RiseColor, textFont: 13, bgColor: COLOR_Clear)
        return lab
    }()
    
    lazy var changeView: UIView = {
        let changeView = UIView.init(frame: .zero)
        changeView.backgroundColor = COLOR_HexColorAlpha(0x39CC43, alpha: 0.2)
        changeView.layer.cornerRadius = 8
        changeView.layer.masksToBounds = true
        return changeView
    }()
    
    lazy var klineBtn: UIButton = {
        let button = fc_buttonInit(imgName: "trade_kline", title: "", fontSize: 17, titleColor: COLOR_White, bgColor: COLOR_BGColor)
        return button
    }()
    
    //Left
    let leftView: UIView = UIView.init(frame: .zero)
    lazy var bidBtn: UIButton = {
        let bidBtn = fc_buttonInit(imgName: "", title: "买入", fontSize: 16, titleColor: COLOR_White, bgColor: COLOR_Clear)
        let tintImage = UIImage(named: "kline_buyBtnBg")
        let selectImg = tintImage?.imageWithTintColor(color: COLOR_RiseColor)
        let normalImg = tintImage?.imageWithTintColor(color: COLOR_HexColor(0x3E4046))
        bidBtn.setTitleColor(COLOR_CharTipsColor, for: .normal)
        bidBtn.setTitleColor(COLOR_White, for: .selected)
        bidBtn.isSelected = true
        bidBtn.setBackgroundImage(normalImg, for: .normal)
        bidBtn.setBackgroundImage(selectImg, for: .selected)
        return bidBtn
    }()
    lazy var askBtn: UIButton = {
        let askBtn = fc_buttonInit(imgName: "", title: "卖出", fontSize: 16, titleColor: COLOR_White, bgColor: COLOR_Clear)
        let tintImage = UIImage(named: "kline_sellBtnBg")
        let selectImg = tintImage?.imageWithTintColor(color: COLOR_FailColor)
        let normalImg = tintImage?.imageWithTintColor(color: COLOR_HexColor(0x3E4046))
        askBtn.setTitleColor(COLOR_CharTipsColor, for: .normal)
        askBtn.setTitleColor(COLOR_White, for: .selected)
        askBtn.setBackgroundImage(normalImg, for: .normal)
        askBtn.setBackgroundImage(selectImg, for: .selected)
        return askBtn
    }()
    
    lazy var typeLab: UILabel = {
        let typeLab = fc_labelInit(text: "限价委托", textColor: COLOR_White, textFont: 16, bgColor: COLOR_BGColor)
        return typeLab
    }()
    
    lazy var arrowImgView: UIImageView = {
        let arrowImgView = UIImageView.init(frame: .zero)
        arrowImgView.image = UIImage(named: "arrow_down")
        return arrowImgView
    }()
    
    lazy var typeBtn: UIButton = {
        let typeBtn = UIButton.init(type: .custom)
        typeBtn.backgroundColor = COLOR_Clear
        return typeBtn
    }()
    
    lazy var typeView: UIView = {
        let typeView = UIView.init(frame: .zero)
        typeView.backgroundColor = COLOR_BGColor
        typeView.layer.cornerRadius = 5
        typeView.layer.borderWidth = 0.5
        typeView.layer.borderColor = COLOR_InputBorder.cgColor
        
        return typeView
    }()
    
    lazy var dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = ["限价委托", "市价委托"]
        dropDown.anchorView = self.typeBtn
        // dropDown.selectRow(0)  //默认选中
        dropDown.textFont = UIFont.init(_customTypeSize: 16)
        dropDown.textColor = COLOR_PrimeTextColor
        dropDown.cellHeight = 36
        dropDown.bottomOffset = CGPoint(x: 0, y: 36)
        dropDown.backgroundColor = COLOR_HexColor(0x232529)
        dropDown.separatorColor = .clear
        dropDown.shadowOpacity = 0
        
        //dropDown.separatorInsetLeft = true //分割线左对齐
        return dropDown
    }()
    
    lazy var priceTxd: UITextField = {
        let priceTxd = fc_textfiledInit(placeholder: "价格", holderColor: COLOR_CharTipsColor, textColor: COLOR_InputText, fontSize: 16, borderStyle: .roundedRect)
        priceTxd.setValue(5, forKey: "paddingLeft")
        priceTxd.rightViewMode = .always
        priceTxd.backgroundColor = COLOR_BGColor
        priceTxd.layer.borderWidth = 0.5
        priceTxd.layer.borderColor = COLOR_InputBorder.cgColor
        priceTxd.layer.cornerRadius = 5
        priceTxd.tintColor = COLOR_InputText
        
        /// 市价委托显示提示
        marketOrderTitleL = fc_labelInit(text: "以当前市场最优价格下单", textColor: COLOR_CharTipsColor, textFont: UIFont.systemFont(ofSize: 14), bgColor: .clear)
        marketOrderTitleL.textAlignment = .center
        marketOrderTitleL.backgroundColor = COLOR_BGColor
        marketOrderTitleL.layer.borderWidth = 0.5
        marketOrderTitleL.layer.borderColor = COLOR_InputBorder.cgColor
        marketOrderTitleL.layer.cornerRadius = 5
        marketOrderTitleL.tintColor = COLOR_InputText
        marketOrderTitleL.isHidden = true
        
        return priceTxd
    }()
    
    lazy var priceDownBtn: UIButton = {
        let downBtn = fc_buttonInit(imgName: "trade_priceDown")
        return downBtn
    }()
    
    lazy var priceUpBtn: UIButton = {
        let upBtn = fc_buttonInit(imgName: "trade_priceUp")
        return upBtn
    }()
    
    lazy var estimateLab: UILabel = {
        let estimateLab = fc_labelInit(text: "-.--", textColor: COLOR_MinorTextColor , textFont: 12, bgColor: COLOR_BGColor)
        estimateLab.isHidden = true
        estimateLab.numberOfLines = 0
        return estimateLab
    }()
    
    lazy var amountTxd: UITextField = {
        let amountTxd = fc_textfiledInit(placeholder: "数量", holderColor: COLOR_CharTipsColor, textColor: COLOR_InputText, fontSize: 16, borderStyle: .roundedRect)
        amountTxd.setValue(5, forKey: "paddingLeft")
        amountTxd.rightViewMode = .always
        amountTxd.backgroundColor = COLOR_BGColor
        amountTxd.layer.borderWidth = 0.5
        amountTxd.layer.borderColor = COLOR_InputBorder.cgColor
        amountTxd.layer.cornerRadius = 5
        amountTxd.tintColor = COLOR_InputText
        return amountTxd
    }()
    
    lazy var amountUnitLab: UILabel = {
        let amountUnitLab = fc_labelInit(text: "---", textColor: COLOR_CharTipsColor, textFont: 16, bgColor: COLOR_BGColor)
        
        amountUnitLab.textAlignment = .center
        amountUnitLab.numberOfLines = 0
        return amountUnitLab
    }()
    
    
    lazy var amountLab: UILabel = {
        let amountLab = fc_labelInit(text: "-.--", textColor: COLOR_MinorTextColor , textFont: 12, bgColor: COLOR_BGColor)
        return amountLab
    }()
    
    lazy var slider: PCSlider = {
        let slider = PCSlider.init(frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 30) * 4.0 / 7.0, height: 30), scaleLineNumber: 4)
        slider?.setSliderValue(0.0)
        return slider!
    }()
    
    lazy var percentLab: UILabel = {
        let percentLab = fc_labelInit(text: "0%", textColor: COLOR_MinorTextColor , textFont: 12, bgColor: COLOR_BGColor)
        percentLab.numberOfLines = 0
        return percentLab
    }()
    
    
    lazy var volumeLab: UILabel = {
        let volumeLab = fc_labelInit(text: "0.00 USDT", textColor: COLOR_InputText, textFont: 15, bgColor: COLOR_BGColor)
        volumeLab.numberOfLines = 0
        return volumeLab
    }()
    
    lazy var orderBtn: UIButton = {
        let orderBtn = fc_buttonInit(imgName: nil, title: "买入", fontSize: 16, titleColor: COLOR_White, bgColor: COLOR_RiseColor)
        orderBtn.layer.cornerRadius = 2
        orderBtn.layer.masksToBounds = true
        return orderBtn
    }()
    
    //Right
    let rightView: UIView = UIView.init(frame: .zero)
    
    lazy var dethTableView: UITableView = {
        let dethTableView = UITableView.init(frame: .zero, style: .plain)
        dethTableView.isScrollEnabled = false
        //dethTableView.separatorStyle = .
        dethTableView.separatorInset = .zero
        dethTableView.separatorColor = COLOR_HexColorAlpha(0x141416, alpha: 0.7)
        dethTableView.backgroundColor = COLOR_BGColor
        return dethTableView
    }()
    
    lazy var dethHeader: UIView = {
        let dethHeader = UIView.init(frame: .zero)
        let priceTitle = fc_labelInit(text: "价格", textColor: COLOR_CharTipsColor, textFont: 12, bgColor: COLOR_Clear)
        let amountTitle = fc_labelInit(text: "数量", textColor: COLOR_CharTipsColor, textFont: 12, bgColor: COLOR_Clear)
        dethHeader.addSubview(priceTitle)
        dethHeader.addSubview(amountTitle)
        
        priceTitle.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        amountTitle.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.left.greaterThanOrEqualTo(priceTitle.snp_right).offset(10)
        }
        
        return dethHeader
    }()
    
    lazy var dethFooter: UIView = {
        let dethFooter = UIView.init(frame: .zero)
        dethFooter.addSubview(dethPriceLab)
        dethFooter.addSubview(priceEstimateLab)
        dethPriceLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(12)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-12)
        }
        priceEstimateLab.snp.makeConstraints { (make) in
            make.top.equalTo(dethPriceLab.snp_bottom).offset(5)
            make.left.equalToSuperview()
            make.right.lessThanOrEqualToSuperview().offset(-12)
            //            make.bottom.lessThanOrEqualTo(-12)
        }
        return dethFooter
    }()
    
    lazy var dethPriceLab: UILabel = {
        let dethPriceLab = fc_labelInit(text: "-.--", textColor: COLOR_RiseColor, textFont: 16, bgColor: COLOR_Clear)
        return dethPriceLab
    }()
    
    lazy var priceEstimateLab: UILabel = {
        let priceEstimateLab = fc_labelInit(text: "≈-.--", textColor: COLOR_MinorTextColor, textFont: 12, bgColor: COLOR_Clear)
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
        loadRightView()
    }
    
    func loadHeader () {
        let header = UIView.init(frame: .zero)
        self.addSubview(header)
        
        changeView.addSubview(self.changeLab)
        header.addSubview(changeView)
        header.addSubview(self.symbolBtn)
        header.addSubview(self.klineBtn)
        
        
        header.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
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
        }
        
        changeLab.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview().offset(2)
            make.right.equalToSuperview().offset(-2)
            make.height.equalTo(16)
            make.height.equalToSuperview()
        }
        
        self.klineBtn.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-12)
        }
    
        
        //        symbolBtn.rx.tap.subscribe { [weak self] (event) in
        //
        //        }
        //
        //        klineBtn.rx.tap.subscribe {[weak self] (evetn) in
        //
        //
        //        }
    }
    
    func loadLeftView () {
        self.addSubview(leftView)
        
        //买卖
        leftView.addSubview(bidBtn)
        leftView.addSubview(askBtn)
        
        bidBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalToSuperview()
            make.height.equalTo(36)
        }
        
        askBtn.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(5)
            make.left.equalTo(bidBtn.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(36)
            make.width.equalTo(bidBtn)
        }
        
        bidBtn.rx.tap.subscribe { [weak self](event) in
            self?.bidBtn.isSelected = true
            self?.askBtn.isSelected = false
            self?.markerSide = "Bid"
            self?.orderBtn.backgroundColor = COLOR_RiseColor
            self?.orderBtn.setTitle("买入", for: .normal)
            self?.loadAmountData(markerSide: "Bid")
        }.disposed(by: self.disposeBag)
        
        askBtn.rx.tap.subscribe { [weak self](event) in
            self?.bidBtn.isSelected = false
            self?.askBtn.isSelected = true
            self?.markerSide = "Ask"
            self?.orderBtn.backgroundColor = COLOR_FailColor
            self?.orderBtn.setTitle("卖出", for: .normal)
            self?.loadAmountData(markerSide: "Ask")
        }.disposed(by: self.disposeBag)
        
        //下单类型
        typeView.addSubview(typeLab)
        typeView.addSubview(arrowImgView)
        typeView.addSubview(typeBtn)
        leftView.addSubview(typeView)
        
        typeLab.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.height.equalToSuperview()
            make.top.equalToSuperview()
            make.right.lessThanOrEqualTo(arrowImgView.snp.left)
        }
        
        arrowImgView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 6, height: 6))
        }
        
        typeBtn.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        typeView.snp.makeConstraints { (make) in
            make.top.equalTo(askBtn.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        
        // 交互
        typeBtn.rx.tap.subscribe { (event) in
            self.dropDown.show()
        }.disposed(by: self.disposeBag)
        
        
        self.dropDown.selectionAction = { [weak self] (index: Int, item: String) in
            self?.orderType = index == 0 ? "Market" : "Limit"
            self?.typeLab.text = index == 0 ? "限价委托" : "市价委托"
            
            self?.marketOrderTitleL.isHidden = index == 0 ? true : false
        }
        
        // 价格
        let txdRightView = UIView.init(frame: .zero)
        let border = UIView.init(frame: .zero)
        border.backgroundColor = COLOR_InputBorder
        let seperator = UIView.init(frame: .zero)
        seperator.backgroundColor = COLOR_InputBorder
        
        txdRightView.addSubview(border)
        txdRightView.addSubview(seperator)
        txdRightView.addSubview(priceDownBtn)
        txdRightView.addSubview(priceUpBtn)
        priceTxd.rightView = txdRightView
        leftView.addSubview(estimateLab)
        leftView.addSubview(priceTxd)
        leftView.addSubview(marketOrderTitleL)
        
        border.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.width.equalTo(0.5)
        }
        
        priceDownBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.right.equalTo(seperator.snp.left).offset(-10)
        }
        
        priceUpBtn.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 24, height: 24))
            make.left.equalTo(seperator.snp.right).offset(10)
        }
        
        marketOrderTitleL.snp.makeConstraints { (make) in
            make.edges.equalTo(priceTxd)
        }
        
        seperator.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(0.5)
            make.height.equalTo(20)
        }
        
        txdRightView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: 88, height: 36))
        }
        
        estimateLab.snp.makeConstraints { (make) in
            make.top.equalTo(priceTxd.snp_bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        priceTxd.snp.makeConstraints { (make) in
            make.top.equalTo(typeView.snp.bottom).offset(8)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        self.priceDownBtn.rx.tap.subscribe { (event) in
            var priceValue = Double(self.priceTxd.text ?? "") ?? 0.0
            if(priceValue > 0.1) {
                priceValue = priceValue - 0.1
                self.priceTxd.text = String(format:"%.2f", priceValue)
            }
            
        }.disposed(by: self.disposeBag)
        
        
        self.priceUpBtn.rx.tap.subscribe { (event) in
            var priceValue = Double(self.priceTxd.text ?? "") ?? 0.0
            if(priceValue > 0.0) {
                priceValue = priceValue + 0.1
                self.priceTxd.text = String(format:"%.2f", priceValue)
            }
            
        }.disposed(by: self.disposeBag)
        
        
        
        // 数量
        
        let unitView = UIView.init(frame: .zero)
        unitView.addSubview(amountUnitLab)
        amountTxd.rightView = unitView
        leftView.addSubview(amountTxd)
        leftView.addSubview(amountLab)
        leftView.addSubview(slider)
        leftView.addSubview(percentLab)
        
        amountUnitLab.snp.makeConstraints { (make) in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10))
            make.width.greaterThanOrEqualTo(45)
        }
        
        amountTxd.snp.makeConstraints { (make) in
            make.top.equalTo(estimateLab.snp_bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(36)
        }
        
        amountLab.snp.makeConstraints { (make) in
            make.top.equalTo(amountTxd.snp_bottom).offset(5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        
        slider.snp.makeConstraints { (make) in
            make.top.equalTo(amountLab.snp_bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
        
        percentLab.snp.makeConstraints { (make) in
            make.top.equalTo(slider.snp_bottom)
            make.left.greaterThanOrEqualToSuperview()
            make.right.equalToSuperview()
        }
        
        amountTxd.rx.text.orEmpty.asObservable().subscribe(onNext: { (text) in
            // let value = Double(text) ?? 0.0
            let baseAsset = Double(self.baseAsset?.estimatedValue ?? "0") ?? 0.0
            let tradeAsset = Double(self.tradeAsset?.available ?? "0") ?? 0.0
            
            if (baseAsset == 0.0 && self.markerSide == "Bid" || tradeAsset == 0.0 && self.markerSide == "Ask" )  {
                //self.slider.setSliderValue(1)
            } else if (self.markerSide == "Bid") {
                //self.slider.setSliderValue( min(Float(value / baseAsset), 1.0) )
            } else {
                //self.slider.setSliderValue( min(Float(value / tradeAsset), 1.0) )
            }
            
        }).disposed(by: self.disposeBag)
        
        slider.monitorSliderValue { (value) in
            
            self.percentLab.text = String(format: "%.0f%%", value * 100)
            
            //((mTradeInTradeCoinCountSb.progress * currentBaseSymbolAsset!!.available) / currentTradePrice)
            
            let currentTradePrice = Double(self.priceTxd.text ?? "0.00") ?? 1.0
            
            let baseAsset = Double(self.baseAsset?.available ?? "0") ?? 0.0
            let tradeAsset = Double(self.tradeAsset?.available ?? "0") ?? 0.0
            if(self.markerSide == "Bid") {
                self.amountTxd.text = String(format: "%f", (Double(value) * baseAsset)/currentTradePrice)
                self.volumeLab.text = String(format: "%.2f USDT", Double(value) * baseAsset)
            } else {
                self.amountTxd.text = String(format: "%f", (Double(value) * tradeAsset)/currentTradePrice)
                self.volumeLab.text = String(format: "%.2f USDT", Double(value) * tradeAsset)
            }
        }
        
        // 交易额&提交
        let volumeTitleLab = fc_labelInit(text: "交易额", textColor: COLOR_CharTipsColor, textFont: 15, bgColor: COLOR_BGColor)
        leftView.addSubview(volumeTitleLab)
        leftView.addSubview(volumeLab)
        leftView.addSubview(orderBtn)
        
        volumeTitleLab.snp.makeConstraints { (make) in
            make.top.equalTo(percentLab.snp_bottom).offset(20)
            make.left.equalToSuperview()
        }
        
        volumeLab.snp.makeConstraints { (make) in
            make.top.equalTo(percentLab.snp_bottom).offset(20)
            make.right.equalToSuperview()
            make.left.greaterThanOrEqualTo(volumeTitleLab.snp_left).offset(15)
        }
        
        orderBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.greaterThanOrEqualTo(volumeTitleLab.snp_bottom).offset(12)
            make.top.greaterThanOrEqualTo(volumeLab.snp_bottom).offset(12)
            make.height.equalTo(40)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        
        leftView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(45)
            make.left.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        orderBtn.rx.tap.subscribe { (event) in
            self.placeOrder?(self.priceTxd.text ?? "", self.amountTxd.text ?? "", self.orderType, self.markerSide)
        }.disposed(by: self.disposeBag)
    }
    
    // 加载右边深度图
    func loadRightView () {
        self.addSubview(dethTableView)
        // dethTableView.backgroundColor = .yellow
        dethTableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(45)
            make.left.equalTo(leftView.snp.right).offset(15)
            make.right.equalToSuperview()
            make.width.equalTo(leftView).multipliedBy(0.75)
            make.height.equalTo(350)
            make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        dethTableView.delegate = self
        dethTableView.dataSource = self
    }
    
    func loadMarketModel(model: FCMarketModel?) {
        
        //显示初始价格
        if (model?.symbol != self.marketModel?.symbol) {
            self.priceTxd.text = model?.latestPrice
            self.estimateLab.text = "≈\(model?.estimatedValue ?? "") \(model?.estimatedCurrency ?? "")"
        }
        
        self.marketModel = model
        let title = model?.symbol?.replacingOccurrences(of: "-", with: "/") ?? "--/--"
        self.symbolBtn.setTitle(title, for: .normal)
        self.changeLab.text = "\(model?.changePercent ?? "-.--")%"
        
        // 刷新深度图
        self.dethPriceLab.text = model?.latestPrice ?? "-.--"
        self.priceEstimateLab.text = "≈\(model?.estimatedValue ?? "") \(model?.estimatedCurrency ?? "")"
    }
    
    func loadAssetsData (tradeAsset: FCAssetModel?, baseAsset: FCAssetModel?) {

        self.tradeAsset = tradeAsset
        self.baseAsset = baseAsset
        self.loadAmountData(markerSide: self.markerSide)
    }
    
    func loadAmountData(markerSide: String) {
        
        self.amountUnitLab.text = tradeAsset?.asset
        
        if (self.markerSide == "Bid") {
            //self.amountTxd.text = baseAsset?.available
            self.amountLab.text = "可用 \(baseAsset?.available ?? "0") \(baseAsset?.asset ?? "")"
        } else {
            //self.amountTxd.text = tradeAsset?.available
            self.amountLab.text = "可用 \(tradeAsset?.available ?? "0") \(tradeAsset?.asset ?? "")"
        }
    }
    
    func loadDethDatas(depthModel: FCKLineRestingModel?) {
        self.depthModel = depthModel
        
        //最多截取前6个
        self.askData = depthModel?.asks?.suffix(6)
        if depthModel?.bids?.count ?? 0 > 5 {
            self.bidData = Array(depthModel?.bids?[0...5] ?? [])
        }
        
        self.dethTableView.reloadData()
    }
    
    func caculateEstimateValue () {
        
    }
}

extension FCSpotOrderView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {//卖
            
            let model = self.askData?[indexPath.row];
            self.priceTxd.text = model?.price
            
        } else {
            
            let model = self.bidData?[indexPath.row]
            self.priceTxd.text = model?.price
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return section == 0 ? self.dethHeader : UIView.init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return section == 0  ? self.dethFooter : UIView.init(frame: .zero)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 25
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
                depthCell.loadData(model: self.askData?[indexPath.row], isSell: true)
                cell = depthCell
            }
        } else {//买
            if (self.bidData?.count ?? 0 > indexPath.row && self.askData?.count ?? 0 > indexPath.row) {
                let depthCell = FCTradeDepthCell.init(style: .default, reuseIdentifier: "FCTradeDepthCellReuseId")
                depthCell.loadData(model: self.bidData?[indexPath.row], isSell: false)
                cell = depthCell
            } else {
                //显示占位的cell
                cell = FCTradeEmptyCell.init(style: .default, reuseIdentifier: "FCTradeEmptyCellReuseId")
            }
        }
        return cell ?? UITableViewCell.init(style: .default, reuseIdentifier: "")
    }
    
    
}
