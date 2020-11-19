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
    
    @IBOutlet weak var adjustmentBtn: UIButton!
    @IBOutlet weak var closePositionBtn: UIButton!

    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var bottomBtnWidth: NSLayoutConstraint!
    @IBOutlet weak var profitLossBtn: UIButton!
    @IBOutlet weak var availableVolumeL: UILabel!
    var accountInfoModel: FCPositionAccountInfoModel?
    
    var sharePosionInfoBlock: ((_ accountInfo: FCPositionInfoModel) -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.positionBgView.backgroundColor = COLOR_CellBgColor
        self.adjustmentBtn.layer.cornerRadius = 5
        self.adjustmentBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        self.adjustmentBtn.layer.borderWidth = 0.7
        
        self.closePositionBtn.layer.cornerRadius = 5
        self.closePositionBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        self.closePositionBtn.layer.borderWidth = 0.7
        
        self.profitLossBtn.layer.cornerRadius = 5
        self.profitLossBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
        self.profitLossBtn.layer.borderWidth = 0.7
        
//        self.shareBtn.layer.cornerRadius = 5
//        self.shareBtn.layer.borderColor = COLOR_TabBarTintColor.cgColor
//        self.shareBtn.layer.borderWidth = 0.7
        
        //self.shareBtn.isHidden = true
        
        //self.shareBtn.tintColor = .white
        //self.shareBtn.setTitle("", for: .normal)
        //self.shareBtn.setImage(UIImage(named: "shareIcon"), for: .normal)
        self.shareBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
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
                btnWidth = (kSCREENWIDTH - 15 * 3)/2.0
                self.adjustmentBtn.isHidden = true
                self.bottomBtnWidth.constant = btnWidth
            }else {
                self.bottomBtnWidth.constant = btnWidth
                self.adjustmentBtn.isHidden = false
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
            self.leverageL.text = tempStr + marginModelStr
            
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
            if rpnlRateFloat > 0 {
                           
                self.pnlRateL.textColor = COLOR_RiseColor
            }else if (rpnlRateFloat < 0) {
                           
                self.pnlRateL.textColor = COLOR_FailColor
            }else {
                        
                self.pnlRateL.textColor = COLOR_InputText
            }
            
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
        
        let positionView = FCClosePositionView(frame: CGRect(x: 0, y: 0, width: kSCREENWIDTH, height: 430))
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
