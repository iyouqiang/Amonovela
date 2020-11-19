//
//  FCMarketCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2018/9/6.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import UIKit

class FCMarketCell: UITableViewCell {

    @IBOutlet weak var marketBgView: UIView!
    @IBOutlet weak var exchangeL: UILabel!
    
    @IBOutlet weak var titleL: UILabel!
    
    @IBOutlet weak var turnoverL: UILabel!
    
    @IBOutlet weak var priceL: UILabel!
    
    @IBOutlet weak var CNYL: UILabel!
    
    @IBOutlet weak var changepercentL: UILabel!
    
    typealias LongPressBlock = (Bool, NSIndexPath) -> Void
    
    var longPressBlock: LongPressBlock?
    
    var indexPath: NSIndexPath?
    
    lazy var longPress: UILongPressGestureRecognizer = {
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction))
        return longPress
    }()
    
    func configureCell(_ model: FCMarketModel, isOptional: Bool) {
        
        if isOptional {
         
            self.addGestureRecognizer(self.longPress)
        }
        
        let arrayStrings: [String] = model.symbol?.split(separator: "-").compactMap { "\($0)" } ?? []
        
        if model.name.count > 0 {
            
            self.titleL.text = model.name
            self.exchangeL.text = ""
        }else {
            
            self.titleL.text = arrayStrings.first
            self.exchangeL.text = "/\(arrayStrings.last ?? "")"
        }
        
        self.turnoverL.text = "24H 量 \(model.volume)"
        self.priceL.text = model.latestPrice
        self.CNYL.text = model.estimatedValue
        //self.changepercentL.text = "\(model.changePercent)%"
        let percentValue = Double(model.changePercent) ?? 0.0
        if percentValue == 0.0 {
            
            self.changepercentL.backgroundColor = COLOR_BGRiseColor
            self.changepercentL.textColor = COLOR_RiseColor
            
        } else if percentValue < 0.0 {
            self.changepercentL.text = "\(model.changePercent)%"
            self.changepercentL.backgroundColor = COLOR_BGFailColor
            self.changepercentL.textColor = COLOR_FailColor
        } else {
            self.changepercentL.text = "+\(model.changePercent)%"
            self.changepercentL.backgroundColor = COLOR_BGRiseColor
            self.changepercentL.textColor = COLOR_RiseColor
        }
        
        #if BS_TARGETCXP
      
        self.changepercentL.textColor = .white
        
        #endif
    }
    
    @objc func longPressAction(longPress: UILongPressGestureRecognizer) {
        
        if longPress.state == .began {
            
            PCAlertManager.showCustomAlertView("温馨提示", message: "是否将\(self.titleL.text!)从自选中移除", btnFirstTitle: "取消", btnFirstBlock: {
                
                if let longBlock = self.longPressBlock {
                    
                    longBlock(false, self.indexPath!)
                }
                
            }, btnSecondTitle: "确定") {
                
                if let longBlock = self.longPressBlock {
                    
                    longBlock(true, self.indexPath!)
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.marketBgView.backgroundColor = COLOR_CellBgColor
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /**
     -(void)layoutSubviews {
     [super layoutSubviews];
     for (UIView *subView in self.subviews) {
     if([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
     //这里修改盛放按钮的view的背景颜色(这里一般设置为和你的底色相同的颜色用于遮盖掉原来的大红色)
     subView.backgroundColor = [UIColor hexColorStr:commonBGcolor];
     //这里修改按钮的frame 及 颜色(这里是你要设置成的按钮颜色)
     UIView *confirmView=(UIView *)[subView.subviews firstObject];
     CGRect confFrame = confirmView.frame;
     confFrame.size.height = 77;
     confFrame.origin.y = 5;
     confirmView.frame = confFrame;
     confirmView.layer.backgroundColor = [UIColor hexColorStr:WX_ZSB_StyleColor].CGColor;
     confirmView.layer.cornerRadius = 5;
     //这里修改字的大小、颜色,这个方法可以修改文字样式
     for(UIView *sub in confirmView.subviews) {
     if ([sub isKindOfClass:NSClassFromString(@"UIButtonLabel")]) {
     UILabel *deleteLabel=(UILabel *)sub;
     //改删除按钮的字体大小
     deleteLabel.font=[UIFont boldSystemFontOfSize:20];
     //改删除按钮的文字
     aliyunzixun@xxx.com"删除";
     }
     }
     break;
     }
     */
    
//    override func layoutSubviews() {
//
//        for subview in self.subviews {
//
//           if String(describing: subview).range(of: "UITableViewCellDeleteConfirmationView") != nil {
//
//            subview.backgroundColor = COLOR_InputColor
//
//            for sub in subview.subviews {
//
//                 if String(describing: sub).range(of: "_UITableViewCellActionButton") != nil {
//
//                    if let button = sub as? UIButton {
//                        button.titleLabel?.textColor = COLOR_PrimeTextColor
//                        button.backgroundColor = COLOR_InputColor
//                        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
}

