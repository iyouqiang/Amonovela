//
//  KLinePeriodView.swift
//  KLine-Chart
//
//  Created by He on 2020/3/3.
//  Copyright © 2020 hjs. All rights reserved.
//

import UIKit

//import Toast_Swift

open class KLinePeriodView: UIView {
    
    
    @IBOutlet weak var centerXConstraint: NSLayoutConstraint!
    
    /// 时间
    @IBOutlet weak var PeriodTimeSharingplanBtn: UIButton! // tag == 1 分时
    @IBOutlet weak var period15fenButton: UIButton!  // tag == 2
    @IBOutlet weak var period1hourButton: UIButton! // tag == 3
    @IBOutlet weak var period4hourButton: UIButton! // tag == 4
    @IBOutlet weak var period1dayButton: UIButton!  // tag == 5
    
    /// 事件
    @IBOutlet weak var periodMoreButton: UIButton! // tag == 6
    @IBOutlet weak var periodIndexButton: UIButton! // tag == 7
    @IBOutlet weak var periodFullScreenButton: UIButton! // tag == 8
    @IBOutlet weak var moreIndicator: UIImageView!
    @IBOutlet weak var indexIndicator: UIImageView!
    
    var morePopover: KLinePopover?
    var moreContentView: KLinePeriodMoreView?
    var indexPopover: KLinePopover?
    var indexContenView: KLineIndicatorsView?
    var currentPeriod: String = KLinePeriod.hour01.rawValue
    
    var currentButton: UIButton?
    
    open override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.currentButton = self.PeriodTimeSharingplanBtn
        self.currentButton?.isSelected = true
        loadMoreDropDown()
        loadIndexDropDown()

        /// 主附图初始化
        loadDefaultSelectedPeriod()
        loadMainAuxiliarychartView()
    }
    
    open override var frame: CGRect {
        
        didSet {
            
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.period1hourButton != nil {
            self.centerXConstraint.constant = (self.currentButton?.center.x ?? 0) - self.period1hourButton.center.x
        }
        
        if currentButton != nil {
            self.centerXConstraint.constant =  (self.currentButton?.center.x ?? 0) - self.period1hourButton.center.x
        }
    }
    
    public static func linePeriodView() -> KLinePeriodView {
        let view = KLineBundle?.loadNibNamed("KLinePeriodView", owner: self, options: nil)?.last as! KLinePeriodView
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 30)
        view.backgroundColor = ChartColors.bgColor
        view.layer.shadowColor =  UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 0, height: 10)
        view.layer.shadowOpacity = 0.5
        view.layer.shadowRadius = 5
        return view
    }
    
    @IBAction func buttonClick(_ sender: UIButton) {
        
        self.currentButton = sender
        var period = self.currentPeriod

        switch sender.tag {
        case 1:
            period = KLinePeriod.min01.rawValue
            self.moreContentView?.deselectAllBtn()
            UserDefaults.standard.set(period, forKey: KLINEPERIODKEY)
            UserDefaults.standard.synchronize()
        case 2:
            period = KLinePeriod.min15.rawValue
            self.moreContentView?.deselectAllBtn()
            UserDefaults.standard.set(period, forKey: KLINEPERIODKEY)
            UserDefaults.standard.synchronize()
        case 3:
            period = KLinePeriod.hour01.rawValue
            self.moreContentView?.deselectAllBtn()
            UserDefaults.standard.set(period, forKey: KLINEPERIODKEY)
            UserDefaults.standard.synchronize()
        case 4:
            period = KLinePeriod.hour04.rawValue
            self.moreContentView?.deselectAllBtn()
            UserDefaults.standard.set(period, forKey: KLINEPERIODKEY)
            UserDefaults.standard.synchronize()
        case 5:
            period = KLinePeriod.day01.rawValue
            self.moreContentView?.deselectAllBtn()
            UserDefaults.standard.set(period, forKey: KLINEPERIODKEY)
            UserDefaults.standard.synchronize()
        case 6:
            // period = "more"
            self.morePopover?.show(self.moreContentView!, fromView:
                self.periodMoreButton)
            
        case 7:
            // period = "fullscreen"
            // self.superview?.makeToast("敬请期待", duration: 0.5, position: .center)
            period = "index"
            self.indexPopover?.show(self.indexContenView!, fromView: self.periodIndexButton)
            
        //case 8:
            // period = "fullscreen"
            //self.superview?.makeToast("敬请期待", duration: 0.5, position: .center)
            //PCCustomAlert.showAppInConstructionAlert()
            
        default:
            print("defalut")
        }
        
        if (sender.tag <= 5 && sender.isSelected == false)  || sender.tag == 1 {
            
            deselectAllPeriodBtns()
            sender.isSelected = true
            fixBottomLineCenterX(sender: sender)
            self.currentPeriod = period
            KLineStateManger.manager.setPeriod(period)
            if period == KLinePeriod.min01.rawValue {
                KLineStateManger.manager.setisLine(true) // 分时图
            } else {
                KLineStateManger.manager.setisLine(false)
            }
        }
    }
    
    func loadDefaultSelectedPeriod () {
        
        //  self.period1hourButton.isSelected = true
        //  self.centerXConstraint.constant =  self.period1hourButton.center.x - self.period15fenButton.center.x
        
        /**
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
         */
        
        if let period = UserDefaults.standard.object(forKey: KLINEPERIODKEY) {
            
            let periodStr = period as! String
            
            if periodStr == "1" {
                
                if (UserDefaults.standard.bool(forKey: KLINEPERIODTIMESHARINGKETY) == true) {
                    
                    self.moreContentView?.deselectAllBtn()
                    self.moreContentView?.periodM1Btn.isSelected = true
                    self.setMorePeriodMoreViewStae(period: periodStr, title: "M1")
                }else {
                    
                    self.currentButton = self.PeriodTimeSharingplanBtn
                    buttonClick(self.PeriodTimeSharingplanBtn)
                }
                
            }else if (periodStr == "3") {
                
            }else if (periodStr == "5") {
                
                self.moreContentView?.deselectAllBtn()
                self.moreContentView?.periodM5Btn.isSelected = true
                self.setMorePeriodMoreViewStae(period: periodStr, title: "M5")
                
            }else if (periodStr == "15") {
                
                /// 15 分钟
                self.currentButton = self.period15fenButton
                buttonClick(self.period15fenButton)
                
            }else if (periodStr == "30") {
                
            }else if (periodStr == "60") {
                
                /// 1小时
                self.currentButton = self.period1hourButton
                buttonClick(self.period1hourButton)

            }else if (periodStr == "120") {
                
            }else if (periodStr == "240") {
                
                /// 4小时
                self.currentButton = self.period4hourButton
                buttonClick(self.period4hourButton)
                                
            }else if (periodStr == "360") {
                
                /// 6小时
                self.moreContentView?.deselectAllBtn()
                self.moreContentView?.period6HBtn.isSelected = true
                self.setMorePeriodMoreViewStae(period: periodStr, title: "6H")
                
            }else if (periodStr == "720") {
                
            }else if (periodStr == "1D") {
                
                /// 1天
                self.currentButton = self.period1dayButton
                buttonClick(self.period1dayButton)
                                
            }else if (periodStr == "1W") {
                
                /// 1周
                self.moreContentView?.deselectAllBtn()
                self.moreContentView?.periodW1Btn.isSelected = true

                self.setMorePeriodMoreViewStae(period: periodStr, title: "1周")
                
            }else if (periodStr == "1M") {
                
                /// 一月
                self.moreContentView?.deselectAllBtn()
                self.moreContentView?.periodM1Btn.isSelected = true
                self.setMorePeriodMoreViewStae(period: periodStr, title: "1月")
                
            }else {
                
            }
            
            return
        }
        
        buttonClick(self.PeriodTimeSharingplanBtn)
    }
    
    func loadMainAuxiliarychartView() {
        
        if let tagStr = UserDefaults.standard.object(forKey: MAINCHARTINDEXKEY) as? String {
            
            switch Int(tagStr) {

            case 1:
                
                self.indexContenView?.maButton.isSelected = true
                self.indexContenView?.bollButton.isSelected = false
                KLineStateManger.manager.setMainState(MainState.ma)
                setIndexContenViewState(state: .ma, title: "MA")
                break
            case 2:
                
                self.indexContenView?.maButton.isSelected = false
                self.indexContenView?.bollButton.isSelected = true
                KLineStateManger.manager.setMainState(MainState.boll)
                setIndexContenViewState(state: .boll, title: "BOLL")
                break
            default:
                setIndexContenViewState(state: .none, title: "指标")
                UserDefaults.standard.removeObject(forKey: MAINCHARTINDEXKEY)
                UserDefaults.standard.synchronize()
                break
            }
        }
        
        if let tagStr = UserDefaults.standard.object(forKey: AUXILIARYCHARTKEY) as? String {
            
            self.indexContenView?.macdButton.isSelected = false
            self.indexContenView?.kdjButton.isSelected = false
            self.indexContenView?.rsiButton.isSelected = false
            self.indexContenView?.wrButton.isSelected = false
            
            switch Int(tagStr) {
            case 1:
                self.indexContenView?.macdButton.isSelected = true
                KLineStateManger.manager.setSecondaryState(.macd)
            case 2:
                self.indexContenView?.kdjButton.isSelected = true
            KLineStateManger.manager.setSecondaryState(.kdj)
            case 3:
                self.indexContenView?.rsiButton.isSelected = true
            KLineStateManger.manager.setSecondaryState(.rsi)
            case 4:
                self.indexContenView?.wrButton.isSelected = true
            KLineStateManger.manager.setSecondaryState(.wr)
            default:
                UserDefaults.standard.removeObject(forKey: AUXILIARYCHARTKEY)
                UserDefaults.standard.synchronize()
                break
            }
        }
    }

    
    
    func loadMoreDropDown () {
        
        let moreView = KLinePeriodMoreView.linePeriodMoreView()
        self.moreContentView = moreView
        let popover = KLinePopover()
        popover.arrowSize = .zero
        popover.verticalOffset = 10
        popover.popoverColor = COLOR_KLineColor(0x23252A)
        self.morePopover = popover
        
        moreView.didSelectPriod {[weak self] (period: String, title: String) in
            
            self?.setMorePeriodMoreViewStae(period: period, title: title)
        }
    }
    
    func setMorePeriodMoreViewStae(period : String, title : String) {
        
        self.currentButton = self.periodMoreButton
        self.morePopover?.dismiss()
        self.deselectAllPeriodBtns()
        self.periodMoreButton.isSelected = true
        self.moreIndicator.image = UIImage(named: "more_selected")
        self.periodMoreButton.setTitle(title, for: .normal)
        self.currentPeriod = period
        self.fixBottomLineCenterX(sender: self.periodMoreButton)
        // 加载对应的k线
        KLineStateManger.manager.setPeriod(period)
        KLineStateManger.manager.setisLine(false)
    }
    
    func setIndexContenViewState(state: MainState, title: String) {
        
        self.periodIndexButton.setTitle(title, for: .normal)
        
        if state == .none {
            
            //self?.indexIndicator.image = UIImage(contentsOfFile: KLineBundle?.path(forResource: "more_normal@2x", ofType: "png") ?? "")
            self.indexIndicator.image = UIImage(named: "more_normal")
            self.periodIndexButton.isSelected = false
        } else {
            //self?.indexIndicator.image = UIImage(contentsOfFile: KLineBundle?.path(forResource: "more_selected@2x", ofType: "png") ?? "")
                //UIImage(named: "more_selected")
            self.indexIndicator.image = UIImage(named: "more_selected")
            self.periodIndexButton.isSelected = true
        }
    }
    
    func loadIndexDropDown () {
        self.indexPopover = KLinePopover()
        self.indexPopover?.arrowSize = .zero
        self.indexPopover?.verticalOffset = 10
        self.indexPopover?.popoverColor = COLOR_KLineColor(0x23252A)
        self.indexContenView = KLineIndicatorsView.indicatorsView()
        
        self.indexContenView?.didSelectItem(callback: { [weak self] (state: MainState, title: String) in
            self?.indexPopover?.dismiss()
            self?.periodIndexButton.setTitle(title, for: .normal)
            self?.setIndexContenViewState(state: state, title: title)
        })
        self.indexContenView?.didSelectViceItem(callback: { [weak self] in
            self?.indexPopover?.dismiss()
        })
    }
    
    func fixBottomLineCenterX (sender: UIButton?) {
        
        self.centerXConstraint.constant =  (sender?.center.x ?? 0) - self.period1hourButton.center.x
        
        //self.centerXConstraint.constant = sender?.center.x ?? self.period1hourButton.center.x
    }
    
    func deselectAllPeriodBtns () {
        self.period15fenButton.isSelected = false
        self.period1hourButton.isSelected = false
        self.period4hourButton.isSelected = false
        self.period1dayButton.isSelected = false
        self.periodMoreButton.isSelected = false
        self.PeriodTimeSharingplanBtn.isSelected = false
        self.periodMoreButton.setTitle("更多", for: .normal)
        
        //self.moreIndicator.image =  UIImage(contentsOfFile: KLineBundle?.path(forResource: "more_normal@2x", ofType: "png") ?? "")
        self.moreIndicator.image  = UIImage(named: "more_normal")
    }
}
