//
//  KLineInfoView.swift
//  KLine-Chart
//
//  Created by He on 2020/3/2.
//  Copyright © 2020 hjs. All rights reserved.
//

import UIKit

class KLineInfoView: UIView {
    
    @IBOutlet weak var timeLable: UILabel!
    
    @IBOutlet weak var openLable: UILabel!
    
    @IBOutlet weak var highLable: UILabel!

    @IBOutlet weak var lowLabel: UILabel!
    
    @IBOutlet weak var clsoeLabel: UILabel!
    
    @IBOutlet weak var IncreaseLabel: UILabel!
    
    @IBOutlet weak var amplitudeLabel: UILabel!
    
    @IBOutlet weak var amountLable: UILabel!
    
    var model: KLineModel? {
        didSet {
            guard let _model = model else {
                return
            }
            timeLable.text = calculateDateText(timestamp: _model.id, dateFormat: "yy-MM-dd HH:mm")
            openLable.text = KLineStateManger.manager.precisionSpecification(value: _model.open)
                //String(format: "%.2f", _model.open)
            highLable.text = KLineStateManger.manager.precisionSpecification(value: _model.high)
                //String(format: "%.2f", _model.high)
            lowLabel.text = KLineStateManger.manager.precisionSpecification(value: _model.low)
                //String(format: "%.2f", _model.low)
            clsoeLabel.text = KLineStateManger.manager.precisionSpecification(value: _model.close)
                //String(format: "%.2f", _model.close)
            let upDown = _model.close - _model.open
            var symbol = "-"
            if upDown > 0 {
                symbol = "+"
                self.IncreaseLabel.textColor = ChartColors.upColor
                self.amplitudeLabel.textColor = ChartColors.upColor
            } else {
                self.IncreaseLabel.textColor = ChartColors.dnColor
                self.amplitudeLabel.textColor = ChartColors.dnColor
            }
            let upDownPercent = upDown / _model.open * 100;
            
            IncreaseLabel.text = symbol + KLineStateManger.manager.precisionSpecification(value: abs(upDown))
                //symbol + String(format: "%.2f", abs(upDown))
            
            amplitudeLabel.text = symbol + KLineStateManger.manager.precisionSpecification(value: abs(upDownPercent)) + "%"
                //symbol + String(format: "%.2f", abs(upDownPercent)) + "%"
            
            amountLable.text = KLineStateManger.manager.precisionSpecification(value: _model.vol)
                //String(format: "%.2f", _model.vol)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        //self.backgroundColor = ChartColors.bgColor
        self.layer.borderWidth = 1
        self.layer.borderColor = ChartColors.gridColor.cgColor
    }
    
    static func lineInfoView() -> KLineInfoView {
        let view = KLineBundle?.loadNibNamed("KLineInfoView", owner: self, options: nil)?.last as! KLineInfoView
        view.frame = CGRect(x: 0, y: 0, width: 120, height: 145)
       return view
    }
}
