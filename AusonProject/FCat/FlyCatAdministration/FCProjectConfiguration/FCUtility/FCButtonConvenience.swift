

//
//  FCButtonConvenience.swift
//  FlyCatAdministration
//
//  Created by Frank on 2018/9/10.
//  Copyright © 2018年 Yochi. All rights reserved.
//

import Foundation

enum FCBtnInsetType {
    case FCBtnInsetTypeImgLeft
    case FCBtnInsetTypeImgRight
    case FCBtnInsetTypeImgTop
    case FCBtnInsetTypeImgBottom
}

func fc_buttonInit(imgName : String?, title : String? = "", fontSize : CGFloat? = 12, titleColor : UIColor? = COLOR_ThemeBtnTextColor, bgColor : UIColor? = COLOR_Clear) -> UIButton {
    
    let button = UIButton.init(type: .custom)
    button.setTitle(title, for: .normal)
    
    //button.titleLabel?.font = UIFont(name: "PingFangSC", size: fontSize!)
    button.titleLabel?.font = UIFont.init(_customTypeSize: fontSize!)
    button.setTitleColor(titleColor, for: .normal)
    button.backgroundColor = bgColor
    
    if imgName != nil {
        
        let img = UIImage.init(named: imgName!)
        button .setImage(img, for: .normal)
    }
    
    
    return button
}

extension UIButton {
    
    func fc_buttonConfig(imgName : String?, title : String? = "", fontSize : CGFloat? = 12, titleColor : UIColor? = COLOR_ThemeBtnTextColor, bgColor : UIColor? = COLOR_Clear) {
        self.setTitle(title, for: .normal)
        self.titleLabel?.font = UIFont.init(_customTypeSize: fontSize!)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = bgColor
        
        if imgName != nil {
            let img = UIImage.init(named: imgName!)
            self.setImage(img, for: .normal)
        }
    }

    func setTitleAndImageInset(insetType: FCBtnInsetType, imgLabInset: CGFloat = 5, imgWidth: CGFloat = 0)  {
        
        // 1. 得到imageView和titleLabel的宽、高
        let imageWith  = imgWidth > 0 ? imgWidth : self.imageView?.frame.size.width
        //        let imageHeight  = self.imageView?.frame.size.height
        
        var labelWidth : CGFloat = 0.0;
        //        var labelHeight : CGFloat = 0.0;
        //
        labelWidth = (self.titleLabel?.intrinsicContentSize.width)!;
        //        labelHeight = (self.titleLabel?.intrinsicContentSize.height)!;
        
        
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        var imageEdgeInsets = UIEdgeInsets.init();
        var labelEdgeInsets = UIEdgeInsets.init();
        
        let space : CGFloat = imgLabInset;//图片和文字的间距
        
        switch insetType {
            
        case .FCBtnInsetTypeImgLeft:
            
            imageEdgeInsets = UIEdgeInsets(top: 0, left: -space/2.0, bottom: 0, right: space/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: space/2.0, bottom: 0, right: -space/2.0);
            break
            
        case .FCBtnInsetTypeImgRight:
            
            imageEdgeInsets = UIEdgeInsets(top: 0, left: labelWidth+space/2.0, bottom: 0, right: -labelWidth-space/2.0);
            labelEdgeInsets = UIEdgeInsets(top: 0, left: -(imageWith!+space)/2.0, bottom: 0, right: imageWith!+space/2.0)
            
            break
            
            //        case .FCBtnInsetTypeImgTop: break
            
            //        case .FCBtnInsetTypeImgBottom: break
            
        default:
            
            print("")
        }
        
        
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets;
        self.imageEdgeInsets = imageEdgeInsets;
    }
}
