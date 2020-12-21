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
    var percentValue = 0.0
    var ratioView: FCBtnSelectedView!
    var accuracyBtn: UIButton!
    var dropTriangleImgView: UIImageView!
    var depthswitchBtn: UIButton!
    var precision = "step0"
    
    /// 资产刷新block
    var availableBalanceRefreshBlock: (() -> Void)?
    
    var placeOrder: ((_ price: String, _ amount: String, _ orderType: String, _ markerSide: String, _ volumeType: String) -> Void)?
    
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
        
        let lab = fc_labelInit(text: "0.00%", textColor: COLOR_RiseColor, textFont: UIFont(_DINProBoldTypeSize: 13), bgColor: .clear)
        
        return lab
    }()
    
    lazy var changeView: UIView = {
        let changeView = UIView.init(frame: .zero)
        changeView.backgroundColor = .clear
        //changeView.backgroundColor = COLOR_HexColorAlpha(0x39CC43, alpha: 0.2)
        changeView.layer.cornerRadius = 5
        changeView.layer.masksToBounds = true
        return changeView
    }()
    
    lazy var klineBtn: UIButton = {
        let button = fc_buttonInit(imgName: "trade_kline", title: "", fontSize: 17, titleColor: UIColor.white, bgColor: .clear)
        return button
    }()
    
    // Left
    let leftView: UIView = UIView.init(frame: .zero)
    lazy var bidBtn: UIButton = {
        let bidBtn = fc_buttonInit(imgName: "", title: "买入", fontSize: 14, titleColor: UIColor.white, bgColor: UIColor.clear)
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
        let askBtn = fc_buttonInit(imgName: "", title: "卖出", fontSize: 14, titleColor: UIColor.white, bgColor: UIColor.clear)
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
    
    lazy var arrowImgView: UIImageView = {
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
        
        //typeView.layer.cornerRadius = 5
        //typeView.layer.borderWidth = 0.5
        //typeView.layer.borderColor = COLOR_InputBorder.cgColor
        
        return typeView
    }()
    
    lazy var dropDown: DropDown = {
        let dropDown = DropDown()
        dropDown.dataSource = ["限价委托", "市价委托"]
        dropDown.anchorView = self.typeBtn
        // dropDown.selectRow(0)  // 默认选中
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
        //dropDown.separatorInsetLeft = true //分割线左对齐
        return dropDown
    }()
    
    lazy var priceTxd: UITextField = {
        
        let priceTxd = fc_textfiledInit(placeholder: "价格", holderColor: COLOR_CharTipsColor, textColor: .white, fontSize: 16, borderStyle: .roundedRect)
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
        marketOrderTitleL = fc_labelInit(text: "以当前市场最优价格下单", textColor: COLOR_CellTitleColor, textFont: UIFont(_PingFangSCTypeSize: 14), bgColor: .clear)
        marketOrderTitleL.textAlignment = .center
        marketOrderTitleL.backgroundColor = COLOR_BGColor
        marketOrderTitleL.layer.borderWidth = 0.7
        marketOrderTitleL.layer.borderColor = COLOR_HexColor(0x293247).cgColor
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
    //
    lazy var availableBalanceBtn: UIButton = {
        
        let availableBalanceBtn = fc_buttonInit(imgName: "balancerefreshIcon", title: "可用余额", fontSize: 13, titleColor: COLOR_CellTitleColor, bgColor: .clear)
        availableBalanceBtn.addTarget(self, action: #selector(availableBalanceAction), for: .touchUpInside)
        availableBalanceBtn.contentHorizontalAlignment = .left
        availableBalanceBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        availableBalanceBtn.semanticContentAttribute = .forceRightToLeft
        return availableBalanceBtn
    }()
    
    lazy var estimateLab: UILabel = {
        let estimateLab = fc_labelInit(text: "0.00", textColor: COLOR_MinorTextColor , textFont: 12, bgColor: COLOR_BGColor)
        estimateLab.isHidden = true
        estimateLab.numberOfLines = 0
        return estimateLab
    }()
    
    lazy var amountTxd: UITextField = {
        let amountTxd = fc_textfiledInit(placeholder: "数量", holderColor: COLOR_CharTipsColor, textColor: .white, fontSize: 16, borderStyle: .roundedRect)
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
    
    lazy var amountUnitLab: UILabel = {
        
        let amountUnitLab = fc_labelInit(text: "---", textColor: COLOR_CellTitleColor, textFont: 14, bgColor: .clear)
        
        amountUnitLab.textAlignment = .center
        amountUnitLab.numberOfLines = 0
        return amountUnitLab
    }()
    
    lazy var amountLab: UILabel = {
        let amountLab = fc_labelInit(text: "0.00", textColor: .white, textFont: UIFont(_DINProBoldTypeSize: 13), bgColor: .clear)
        return amountLab
    }()
    
    lazy var slider: PCSlider = {
        let slider = PCSlider.init(frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 30) * 4.0 / 7.0, height: 30), scaleLineNumber: 4)
        slider?.setSliderValue(0.0)
        slider?.isHidden = true
        return slider!
    }()
    
    lazy var percentLab: UILabel = {
        let percentLab = fc_labelInit(text: "0%", textColor: COLOR_MinorTextColor , textFont: 12, bgColor: COLOR_BGColor)
        percentLab.numberOfLines = 0
        percentLab.isHidden = true
        return percentLab
    }()
    
    lazy var volumeLab: UILabel = {
        //let volumeLab = fc_labelInit(text: "0.00 USDT", textColor: COLOR_InputText, textFont: 13, bgColor: .clear)
        let volumeLab = fc_labelInit(text: "0.00 USDT", textColor: .white, textFont: UIFont(_DINProBoldTypeSize: 13), bgColor: .clear)
        volumeLab.numberOfLines = 0
        return volumeLab
    }()
    
    lazy var orderBtn: UIButton = {
        let orderBtn = fc_buttonInit(imgName: nil, title: "买入", fontSize: 16, titleColor: UIColor.white, bgColor: COLOR_RiseColor)
        orderBtn.layer.cornerRadius = 2
        orderBtn.layer.masksToBounds = true
        return orderBtn
    }()
    
    //
    let rightView: UIView = UIView.init(frame: .zero)
    
    lazy var dethTableView: UITableView = {
        let dethTableView = UITableView.init(frame: .zero, style: .grouped)
        dethTableView.delegate = self
        dethTableView.dataSource = self
        dethTableView.isScrollEnabled = false
        dethTableView.separatorStyle = .none
        dethTableView.separatorInset = .zero
        dethTableView.separatorColor = COLOR_BGColor//COLOR_HexColor(0x141416)
        dethTableView.backgroundColor = COLOR_BGColor
        return dethTableView
    }()
    
    lazy var dethHeader: UIView = {
        let dethHeader = UIView.init(frame: .zero)
        let priceTitle = fc_labelInit(text: "价格", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: UIColor.clear)
        let amountTitle = fc_labelInit(text: "数量", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: UIColor.clear)
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
        //let dethPriceLab = fc_labelInit(text: "0.00", textColor: COLOR_RiseColor, textFont: 16, bgColor: UIColor.clear)
        let dethPriceLab = fc_labelInit(text: "0.00", textColor: COLOR_RiseColor, textFont: UIFont(_DINProBoldTypeSize: 15), bgColor: .clear)
        return dethPriceLab
    }()
    
    lazy var priceEstimateLab: UILabel = {
        //let priceEstimateLab = fc_labelInit(text: "≈-.--", textColor: COLOR_MinorTextColor, textFont: 12, bgColor: UIColor.clear)
        let priceEstimateLab = fc_labelInit(text: "≈0.00", textColor: COLOR_CellTitleColor, textFont: UIFont(_DINProBoldTypeSize: 12), bgColor: .clear)
        return priceEstimateLab
    }()
    
    lazy var accuracyViewDropDown: DropDown = {
        let dropMoreSettingDown = DropDown()
        dropMoreSettingDown.shadowOpacity = 0
        dropMoreSettingDown.selectionAction = {
            (index: Int, title: String) in
            
            if let precisions = self.depthModel?.precisions {
                
                if precisions.count > index {
                    
                    let model = precisions[index]
                    self.precision = model.step
                }
            }
            
            UIView.animate(withDuration: 0.3, animations: {[weak self] () -> () in
                
                self?.dropTriangleImgView.transform = (self?.dropTriangleImgView.transform)!.rotated(by: 180 * CGFloat(Double.pi/180))
            })
            
            self.accuracyBtn.setTitle(title, for: .normal)
        }
        
        dropMoreSettingDown.dataSource = ["1", "0.01", "0.1", "10"]
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
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    func loadLeftView () {
        
        self.addSubview(leftView)
        self.addSubview(dethTableView)
        self.addSubview(accuracyView)
        
        accuracyView.snp.makeConstraints { (make) in
            make.bottom.equalTo(leftView.snp_bottom)
            make.height.equalTo(24)
            make.left.equalTo(dethTableView.snp_left)
            make.width.equalTo(dethTableView.snp_width)
        }
        
        dethTableView.snp.makeConstraints { (make) in
            
            make.height.equalTo(350)
            make.top.equalToSuperview().offset(60)
            make.left.equalToSuperview().offset(15)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        leftView.snp.makeConstraints { (make) in
            
            make.top.equalToSuperview().offset(60)
            make.left.equalTo(dethTableView.snp.right).offset(15)
            make.right.equalToSuperview().offset(-15)
            make.width.equalTo(dethTableView).multipliedBy(1.4)
            make.height.equalTo(390)
            make.bottom.lessThanOrEqualToSuperview()
        }
        
        //买卖 可用
        leftView.addSubview(bidBtn)
        leftView.addSubview(askBtn)
        
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
            make.left.equalToSuperview()
            make.height.equalToSuperview()
            make.top.equalToSuperview()
        }
        
        arrowImgView.snp.makeConstraints { (make) in
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
            self?.orderType = index == 0 ? "Market" : "Limit"
            self?.typeLab.text = index == 0 ? "限价委托" : "市价委托"
            self?.marketOrderTitleL.isHidden = index == 0 ? true : false
        }
        
        // 价格 
        let txdRightView = UIView.init(frame: .zero)
        let border = UIView.init(frame: .zero)
        border.backgroundColor = COLOR_HexColor(0x293247)
        let seperator = UIView.init(frame: .zero)
        seperator.backgroundColor = COLOR_HexColor(0x293247)
        
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
            make.width.equalTo(0.7)
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
            make.width.equalTo(0.7)
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
        let unitView = UIView.init(frame: CGRect(x: 0, y: 0, width: 60, height: 36))
        unitView.addSubview(amountUnitLab)
        amountTxd.rightView = unitView
        leftView.addSubview(amountTxd)
        leftView.addSubview(amountLab)
        leftView.addSubview(availableBalanceBtn)
        leftView.addSubview(slider)
        leftView.addSubview(percentLab)
        
        // 交易额&提交
        let volumeTitleLab = fc_labelInit(text: "交易额", textColor: COLOR_CellTitleColor, textFont: 13, bgColor: .clear)
        leftView.addSubview(volumeTitleLab)
        leftView.addSubview(volumeLab)
        leftView.addSubview(orderBtn)
        
        ratioView = FCBtnSelectedView(frame: CGRect(x: 0, y: 0, width: (kSCREENWIDTH - 60) * 0.6, height: 24))
        ratioView.cornerRadius = 5
        ratioView.titleColor = COLOR_LineColor
        ratioView.borderColor = COLOR_LineColor
        ratioView.clipsToBounds = true
        ratioView.titleArray = ["25%", "50%", "75%", "100%"]
        leftView.addSubview(ratioView)
        
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
            self?.percentLab.text = String(format: "%.0f%%", (self?.percentValue ?? 0) * 100)
            
            //((mTradeInTradeCoinCountSb.progress * currentBaseSymbolAsset!!.available) / currentTradePrice)
            
            let currentTradePrice = Double(self?.priceTxd.text ?? "0.00") ?? 1.0
            
            let baseAsset = Double(self?.baseAsset?.available ?? "0") ?? 0.0
            let tradeAsset = Double(self?.tradeAsset?.available ?? "0") ?? 0.0
            if(self?.markerSide == "Bid") {
                self?.amountTxd.text = String(format: "%f", (value * baseAsset)/currentTradePrice)
                self?.volumeLab.text = String(format: "%.2f USDT", value * baseAsset)
            } else {
                self?.amountTxd.text = String(format: "%f", (value * tradeAsset)/currentTradePrice)
                self?.volumeLab.text = String(format: "%.2f USDT", value * tradeAsset)
            }
        }
        
        ratioView.snp_makeConstraints { (make) in
            
            make.left.equalTo(0)
            make.top.equalTo(amountTxd.snp_bottom).offset(30)
            make.height.equalTo(24)
            make.right.equalToSuperview()
        }
        
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
            //make.top.equalTo(amountTxd.snp_bottom).offset(5)
            //make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(30)
            make.bottom.equalTo(orderBtn.snp_top).offset(-5)
        }
        
        availableBalanceBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(30)
            make.centerY.equalTo(amountLab.snp_centerY)
            make.width.equalTo(200)
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
            
            self.amountTxd.endEditing(true)
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
        
        volumeTitleLab.snp.makeConstraints { (make) in
            make.bottom.equalTo(amountLab.snp_top)
            make.left.equalToSuperview()
        }
        
        volumeLab.snp.makeConstraints { (make) in
            make.centerY.equalTo(volumeTitleLab.snp_centerY)
            make.right.equalToSuperview()
        }
        
        orderBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            //make.top.greaterThanOrEqualTo(volumeTitleLab.snp_bottom).offset(12)
            //make.top.greaterThanOrEqualTo(volumeLab.snp_bottom).offset(12) //
            make.height.equalTo(37)
            make.bottom.equalToSuperview()
            //make.bottom.lessThanOrEqualToSuperview().offset(-20)
        }
        
        orderBtn.rx.tap.subscribe { (event) in
            
            /// 选择了百分比下单
            var volumeType = "Value"
            var entrustVolume = self.amountTxd.text ?? ""
            
            /*
            if self.slider.value > 0 {
                volumeType = "Percentage"
                entrustVolume = String(format: "%0.4f", self.slider.value)
            }
             */
            if self.percentValue > 0 {
                
                volumeType = "Percentage"
                entrustVolume = String(format: "%0.4f", self.percentValue)
            }
            
            self.placeOrder?(self.priceTxd.text ?? "", entrustVolume, self.orderType, self.markerSide, volumeType)
            
        }.disposed(by: self.disposeBag)
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
        
        if (((model?.changePercent ?? "0") as NSString).floatValue >= 0) {
            
            //changeView.backgroundColor = COLOR_HexColorAlpha(0x2CB362, alpha: 0.1)
            self.changeLab.textColor = COLOR_RiseColor
        }else {
            self.changeLab.textColor = COLOR_FailColor
            //changeView.backgroundColor = COLOR_HexColorAlpha(0xE0274A, alpha: 0.1)
        }

        // 刷新深度图
        self.dethPriceLab.text = model?.latestPrice ?? "-.--"
        //self.priceEstimateLab.text = "≈\(model?.estimatedValue ?? "") \(model?.estimatedCurrency ?? "")"
        self.priceEstimateLab.text = model?.estimatedValue ?? "0.00"
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
            self.amountLab.text = "\(baseAsset?.available ?? "0.00") \(baseAsset?.asset ?? "")"
        } else {
            //self.amountTxd.text = tradeAsset?.available
            self.amountLab.text = "\(tradeAsset?.available ?? "0.00") \(tradeAsset?.asset ?? "")"
        }
    }
    
    func loadDethDatas(depthModel: FCKLineRestingModel?) {
        self.depthModel = depthModel
        
        /// 设置深度精度
        if let precisions = depthModel?.precisions {
            var sourceArray = [String]()
            for  model in precisions {
                sourceArray.append(model.precision)
            }
            self.accuracyViewDropDown.dataSource = sourceArray
        }
        
        //最多截取前6个 切换
        if FCTradeSettingconfig.sharedInstance.depthType == "0" {
            /// 默认状态 上下显示 六点
            self.askData = depthModel?.asks?.suffix(6)
            
            var count = depthModel?.bids?.count ?? 0 <= 6 ? (depthModel?.bids?.count ?? 0) : 6
            count = (count - 1) < 0 ? 0 : (count - 1)
            
            self.bidData = Array(depthModel?.bids?[0...count] ?? [])
        }else {
            
            /// 非默认状态 显示12条
            self.askData = depthModel?.asks?.suffix(12)
            
            var count = depthModel?.bids?.count ?? 0 <= 11 ? (depthModel?.bids?.count ?? 0) : 11
            count = (count - 1) < 0 ? 0 : (count - 1)
            
            self.bidData = Array(depthModel?.bids?[0...count] ?? [])
        }
        
        self.dethTableView.reloadData()
    }
    
    @objc func dethPrceSeletedItem() {
        self.priceTxd.text = dethPriceLab.text ?? ""
    }
    
   @objc func availableBalanceAction() {
        
    if let availableBalanceRefreshBlock = self.availableBalanceRefreshBlock {
        
            availableBalanceRefreshBlock()
        }
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

extension FCSpotOrderView: UITableViewDelegate, UITableViewDataSource {
    
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
        return section == 0 ? self.dethHeader : headerView
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
        
        return section == 0  ? 25 : 0.1
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
                if indexPath.row < self.askData?.count ?? 0 {
                    
                    depthCell.loadData(model: self.askData?[indexPath.row], isSell: true)
                }
                
                cell = depthCell
            }
        } else {//买
            if (self.bidData?.count ?? 0 > indexPath.row && self.askData?.count ?? 0 > indexPath.row) {
                let depthCell = FCTradeDepthCell.init(style: .default, reuseIdentifier: "FCTradeDepthCellReuseId")
                if indexPath.row < self.bidData?.count ?? 0 {
                    
                    depthCell.loadData(model: self.bidData?[indexPath.row], isSell: false)
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

extension FCSpotOrderView: UITextFieldDelegate

{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        if textField == amountTxd {
            self.slider.setSliderValue(0.0)
            percentLab.text = "0%"
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
    
        return true
    }
}



