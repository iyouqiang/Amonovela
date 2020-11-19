//
//  FCCountDownButtom.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/14.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCCountDownButton: UIButton {
    
    var timer: DispatchSourceTimer?
    var normalTitle: String = ""
    var resendTitle: String = ""
    var countdownTitle: String = ""
    var durantion: Int = 60
    var fgTimeInterval: Int = 59
    var pageStepTime: DispatchTimeInterval = .seconds(1)
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(normalTitle: String?, countdownTitle: String?, resendTitle: String?, duration: Int?) {
        super.init(frame: .zero)
        self.normalTitle = normalTitle ?? "获取验证码"
        self.resendTitle = resendTitle ?? "重新发送" 
        self.countdownTitle = countdownTitle ?? "后重试"
        self.durantion = duration ?? 60
        
        self.fc_buttonConfig(imgName: "", title: self.normalTitle, fontSize: 15, titleColor: COLOR_BtnTitleColor, bgColor: COLOR_Clear)
    }
    
    
    func setupTimer () {
        self.fgTimeInterval = self.durantion
        self.isUserInteractionEnabled = false
        self.setTitleColor(COLOR_MinorTextColor, for: .normal)
        self.titleLabel?.text = "\(self.fgTimeInterval)s后重试"
        timer = DispatchSource.makeTimerSource(queue: .main)
        timer?.schedule(deadline: .now() + pageStepTime, repeating: pageStepTime)
        timer?.setEventHandler {
            
            DispatchQueue.main.async(execute: {
                
                self.fgTimeInterval -= 1
                
                if self.fgTimeInterval <= 0 {
                    
                    self.deinitTimer()
                    self.isUserInteractionEnabled = true
                    self.setTitleColor(COLOR_BtnTitleColor, for: .normal)
                    self.setTitle(self.resendTitle, for: .normal)
                    return
                }
                
                self.setTitle("\(self.fgTimeInterval)s后重试", for: .normal)
            })
        }
        // 启动定时器
        timer?.resume()
    }
    
    func reapplyVerificationCode() {
        
        deinitTimer()
        self.fgTimeInterval = 60
        self.isUserInteractionEnabled = true
        self.setTitleColor(COLOR_BtnTitleColor, for: .normal)
        self.setTitle(self.resendTitle, for: .normal)
    }
    
    func deinitTimer () {
        if let time = self.timer {
            time.cancel()
            timer = nil
        }
    }
}
