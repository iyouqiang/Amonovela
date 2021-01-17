//
//  FCContractPositionCell.swift
//  FlyCatAdministration
//
//  Created by Yochi on 2020/8/27.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit

class FCContractPositionCell: UITableViewCell {
    
    @IBOutlet weak var positionBgView: UIView!
    @IBOutlet weak var avgPriceL: UILabel!
    @IBOutlet weak var avgPriceNameL: UILabel!
    @IBOutlet weak var symbolTitleL: UILabel!
    @IBOutlet weak var currencyL: UILabel!
    @IBOutlet weak var liquidatedPriceNameL: UILabel!
    @IBOutlet weak var liquidatedPriceL: UILabel!
    @IBOutlet weak var pnlRateL: UILabel!
    @IBOutlet weak var marginL: UILabel!
    @IBOutlet weak var realisedPNLL: UILabel!
    @IBOutlet weak var leverageL: UILabel!
    @IBOutlet weak var volumeL: UILabel!
    
    @IBOutlet weak var adjustSegLIne: UIView!
    @IBOutlet weak var adjustmentBtn: UIButton!
    @IBOutlet weak var closePositionBtn: UIButton!
    @IBOutlet weak var profitLossBtn: UIButton!

    @IBOutlet weak var profitTitleL: UILabel!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var bottomBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var availableVolumeL: UILabel!
    
    @IBOutlet weak var closePositionTitleL: UILabel!
    @IBOutlet weak var earnestMoneyL: UILabel!
    @IBOutlet weak var flagTitleL: UILabel!
    @IBOutlet weak var positionTitleL: UILabel!
    
    @IBOutlet weak var bgViewBtn: UIButton!
    @IBOutlet weak var rateTitleL: UILabel!
    var accountInfoModel: FCPositionAccountInfoModel?
    
    var sharePosionInfoBlock: ((_ accountInfo: FCPositionInfoModel) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.positionBgView.backgroundColor = COLOR_CellBgColor
        
        //self.shareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 8)
        
        self.adjustmentBtn.layer.cornerRadius = 2
        adjustmentBtn.layer.shadowColor = UIColor.black.cgColor
        adjustmentBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        adjustmentBtn.layer.shadowRadius = 2;
        adjustmentBtn.layer.shadowOpacity = 0.3;
        
        var imageIcon = UIImage(named: "revokeOrder")
        imageIcon = imageIcon?.stretchableImage(withLeftCapWidth: 20, topCapHeight: 15)
        //adjustmentBtn.setBackgroundImage(imageIcon, for: .normal)
        self.closePositionBtn.layer.cornerRadius = 2
        closePositionBtn.layer.shadowColor = UIColor.black.cgColor
        closePositionBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        closePositionBtn.layer.shadowRadius = 2;
        closePositionBtn.layer.shadowOpacity = 0.3;
        //closePositionBtn.setBackgroundImage(imageIcon, for: .normal)
        
        self.profitLossBtn.layer.cornerRadius = 2
        profitLossBtn.layer.shadowColor = UIColor.black.cgColor
        profitLossBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        profitLossBtn.layer.shadowRadius = 2;
        profitLossBtn.layer.shadowOpacity = 0.3;
        //profitLossBtn.setBackgroundImage(imageIcon, for: .normal)
        
        bgViewBtn.layer.cornerRadius = 2
        bgViewBtn.layer.shadowColor = UIColor.black.cgColor
        bgViewBtn.layer.shadowOffset = CGSize(width: 3, height: 3)
        bgViewBtn.layer.shadowRadius = 2;
        bgViewBtn.layer.shadowOpacity = 0.3;
        bgViewBtn.setBackgroundImage(imageIcon, for: .normal)
        /**********/
        
        avgPriceL.font = UIFont(_DINProBoldTypeSize: 16)
        avgPriceNameL.font = UIFont(_PingFangSCTypeSize: 13)
        symbolTitleL.font = UIFont(_DINProBoldTypeSize: 15)
        currencyL.font = UIFont(_DINProBoldTypeSize: 16)
        liquidatedPriceNameL.font = UIFont(_PingFangSCTypeSize: 13)
        liquidatedPriceL.font = UIFont(_DINProBoldTypeSize: 16)
        pnlRateL.font = UIFont(_DINProBoldTypeSize: 13)
        marginL.font = UIFont(_DINProBoldTypeSize: 13)
        realisedPNLL.font = UIFont(_DINProBoldTypeSize: 13)
        leverageL.font = UIFont(_DINProBoldTypeSize: 13)
        volumeL.font = UIFont(_DINProBoldTypeSize: 13)
        availableVolumeL.font = UIFont(_DINProBoldTypeSize: 13)
        
        closePositionTitleL.font = UIFont(_PingFangSCTypeSize: 13)
        earnestMoneyL.font = UIFont(_PingFangSCTypeSize: 13)
        flagTitleL.font = UIFont(_PingFangSCTypeSize: 13)
        positionTitleL.font = UIFont(_PingFangSCTypeSize: 13)
        shareBtn.semanticContentAttribute = .forceRightToLeft
        shareBtn.titleLabel?.font = UIFont(_PingFangSCTypeSize: 14)
        //shareBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 10)
    }
    
    /**
     adlRiskLevel = 4;
     availableMargin = "35.3584";
     availableVolume = 6000;
     avgPrice = "11507.73";
     commissionRate = "0.001";
     contractSize = "0.0001";
     currency = "";
     latestPrice = "11534.87";
     leverage = 100X;
     liquidatedPrice = "11460.26";
     margin = "86.6316";
     marginMode = Isolated;
     marginRatio = "1.25";
     marketTakeLevel = 2;
     pnlRate = "24.26";
     positionId = 3385;
     positionSide = Long;
     priceDigitalNum = 2;
     realisedPNL = "75.8607";
     symbol = "BTC-USDT";
     unrealisedPNL = "16.7501";
     updateTm = "";
     volume = 6000;
     */
    
    @IBAction func shareAction(_ sender: Any) {
        
        guard let positionModel = self.positionModel else {
            return
        }
        
        self.sharePosionInfoBlock?(positionModel)
    }
    
    var positionModel: FCPositionInfoModel? {
        
        didSet {
            
            guard let positionModel = positionModel else {
                return
            }
            if positionModel.pnlShare?.symbolName?.count == 0 {
                self.shareBtn.isHidden = true
            }else {
                self.shareBtn.isHidden = false
            }
            var btnWidth = (kSCREENWIDTH - 15 * 4)/3.0
            if positionModel.marginMode == "Cross" {
                btnWidth = (kSCREENWIDTH - 15 * 2)/2.0
                self.adjustmentBtn.isHidden = true
                self.adjustSegLIne.isHidden = true
                self.bottomBtnWidth.constant = btnWidth
            }else {
                self.bottomBtnWidth.constant = btnWidth
                self.adjustmentBtn.isHidden = false
                self.adjustSegLIne.isHidden = false
            }
            self.symbolTitleL.text = positionModel.symbolName
                //"\(positionModel.symbol ?? "")永续"
            let positionSide = positionModel.positionSide ?? ""
            let leverage = positionModel.leverage ?? ""
            //Long表示多仓，Short表示空仓
            if positionSide == "Long" {
                self.leverageL.text = "做多 \(leverage)"
                self.leverageL.textColor = COLOR_RiseColor
            }else if (positionSide == "Short") {
                self.leverageL.text = "做空 \(leverage)"
                self.leverageL.textColor = COLOR_FailColor
            }else {
                self.leverageL.text = ""
            }
            
            var marginModelStr = "（全）"
            if positionModel.marginMode == "Isolated" {
                
                marginModelStr = "（逐）"
            }
            
            let tempStr = self.leverageL.text ?? ""
            self.leverageL.text = tempStr
                //tempStr + marginModelStr
            
            //self.leverageL.setAttributeColor(COLOR_InputText, range: NSRange(location: ((self.leverageL.text?.count ?? 0) - marginModelStr.count), length: marginModelStr.count))
            
            /// 持仓均价
            let symbolArray = positionModel.symbol?.split(separator: "-")
            let symbolStr = symbolArray?.last ?? ""
            //let sheetStr = symbolArray?.first ?? ""
            var sheetStr = FCTradeSettingconfig.sharedInstance.tradingUnitStr
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_COIN {
                
                sheetStr = positionModel.contractAsset ?? ""
            }
            
            self.avgPriceNameL.text = "持仓均价(\(symbolStr))"
            self.avgPriceL.text = positionModel.avgPrice ?? ""
            self.currencyL.text = positionModel.fairPrice ?? "0.00"
            self.liquidatedPriceL.text = positionModel.liquidatedPrice ?? ""
            
            let realisedPNL = positionModel.unrealisedPNL ?? ""
            let realisedPNLFloat = (realisedPNL as NSString).floatValue
            self.realisedPNLL.text =  realisedPNL
            if realisedPNLFloat > 0 {
                
                self.realisedPNLL.textColor = COLOR_RiseColor
            }else if (realisedPNLFloat < 0) {
                
                self.realisedPNLL.textColor = COLOR_FailColor
            }else {
             
                self.realisedPNLL.textColor = COLOR_InputText
            }
            
            /// 保证金 
            self.marginL.text = positionModel.margin ?? ""
            /// 收益率
            let pnlRate = positionModel.pnlRate ?? ""
            let rpnlRateFloat = (pnlRate as NSString).floatValue
            self.pnlRateL.text =  "\(pnlRate)%"
            
            /*
            if rpnlRateFloat > 0 {
                           
                self.pnlRateL.textColor = COLOR_RiseColor
            }else if (rpnlRateFloat < 0) {
                           
                self.pnlRateL.textColor = COLOR_FailColor
            }else {
                        
                self.pnlRateL.textColor = COLOR_InputText
            }
             */
            
            /// 可平量
            let contractSizeFloat = ((positionModel.contractSize ?? "") as NSString).doubleValue
            let availableVolumeFloat = ((positionModel.availableVolume ?? "") as NSString).doubleValue
            let volumeFloat = ((positionModel.volume ?? "") as NSString).doubleValue
            
            if FCTradeSettingconfig.sharedInstance.tradeTradingUnit == .TradeTradingUnitType_CONT {
              
                self.availableVolumeL.text = "\(positionModel.availableVolume ?? "") " + sheetStr
                self.volumeL.text = "\(positionModel.volume ?? "") " + sheetStr
                return
            }
            
            self.availableVolumeL.text = String(format: "%.4f ", availableVolumeFloat) + sheetStr
            self.volumeL.text = String(format: "%.4f ", volumeFloat) + sheetStr
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func closePositionAction(_ sender: Any) {
        
        let positionView = FCClosePositionView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 450))
        positionView.positionModel = self.positionModel
        
       let alertView = PCCustomAlert(customView: positionView)
        positionView.closeAlertBlock = {
            alertView?.disappear()
        }
    }
    
    @IBAction func profitLossAction(_ sender: Any) {
         
        let profitView = FCProfitLossSettingView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 430))
        profitView.positionModel = self.positionModel
        
       let alertView = PCCustomAlert(customView: profitView)
        profitView.closeAlertBlock = {
            alertView?.disappear()
        }
    }
    
    @IBAction func adjustmentAction(_ sender: Any) {

        guard let positionModel = self.positionModel  else {
            self.makeToast("获取持仓数据中")
            return
        }
        
        guard let account = self.accountInfoModel?.account else {
            self.makeToast("获取持仓数据中")
            return
        }
        let adjustVC = FCAdjustmentMarginController(positionModel:positionModel, accountInfoModel:  account)
        //adjustVC.accountInfoModel = self.accountInfoModel?.account
        //adjustVC.positionModel = self.positionModel
        adjustVC.hidesBottomBarWhenPushed = true
        kAPPDELEGATE?.topViewController?.navigationController?.pushViewController(adjustVC, animated: true)
    }
}
