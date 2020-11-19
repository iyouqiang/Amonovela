
//
//  KLineperiodmoreView.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/7/13.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class KLinePeriodMoreView: UIView {

    var callback: ((_ perriod: String, _ title: String) -> Void)?
    @IBOutlet weak var periodM1Btn: UIButton!
    
    @IBOutlet weak var periodM5Btn: UIButton!
    
    @IBOutlet weak var period6HBtn: UIButton!
    
    @IBOutlet weak var periodW1Btn: UIButton!
    
    @IBOutlet weak var periodMonthBtn: UIButton!
    
    override func awakeFromNib() {
       super.awakeFromNib()
    }
    
    static func linePeriodMoreView() -> KLinePeriodMoreView {
        let view = KLineBundle?.loadNibNamed("KLinePeriodMoreView", owner: self, options: nil)?.last as! KLinePeriodMoreView
        view.frame = CGRect(x: 0, y: 0, width: 236, height: 50)
       return view
    }
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        self.deselectAllBtn()
        var period = ""
        sender.isSelected = true
        switch sender.tag {
                case 1:
                    period = KLinePeriod.min01.rawValue
                    UserDefaults.standard.setValue(true, forKey: KLINEPERIODTIMESHARINGKETY)
                    UserDefaults.standard.synchronize()
                case 2:
                    period = KLinePeriod.min05.rawValue
                    UserDefaults.standard.setValue(false, forKey: KLINEPERIODTIMESHARINGKETY)
                    UserDefaults.standard.synchronize()
                case 3:
                    period = KLinePeriod.hour06.rawValue
                    UserDefaults.standard.setValue(false, forKey: KLINEPERIODTIMESHARINGKETY)
                    UserDefaults.standard.synchronize()
                case 4:
                    period = KLinePeriod.week01.rawValue
                    UserDefaults.standard.setValue(false, forKey: KLINEPERIODTIMESHARINGKETY)
                    UserDefaults.standard.synchronize()
                case 5:
                    period = KLinePeriod.month01.rawValue
                    UserDefaults.standard.setValue(false, forKey: KLINEPERIODTIMESHARINGKETY)
                    UserDefaults.standard.synchronize()
                default:
                    print("defalut")
                }
        
        UserDefaults.standard.set(period, forKey: KLINEPERIODKEY)
        UserDefaults.standard.synchronize()
        self.callback?(period, sender.titleLabel?.text ?? "")
    }
    
   func deselectAllBtn () {
        periodM1Btn.isSelected = false
        periodM5Btn.isSelected = false
        period6HBtn.isSelected = false
        periodW1Btn.isSelected = false
        periodMonthBtn.isSelected = false
    }
    
    func didSelectPriod (callback: @escaping ((String, String) -> Void)) {
        self.callback = callback
    }

}
