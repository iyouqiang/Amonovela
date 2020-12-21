//
//  FCPhoneComponent.swift
//  FlyCatAdministration
//
//  Created by MacX on 2020/6/7.
//  Copyright © 2020 Yochi. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class FCPhoneComponent: UIView, UITextFieldDelegate {
    
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
    var dropDown: DropDown?
    var phoneTxd: UITextField!
    var rightView: UIView!
    var rightBtn: UIButton!
    var imgBtn: UIButton!
    var countryList: FCountryCodeModel!
    let disposeBag = DisposeBag()
    var textFieldDidBeginEditingBlock:(() -> Void)?
    var bottomLine: UIView!
    var coutryCode: String = ""
    var phone: String = ""
    var topTitleL: UILabel!
    var topRegionL: UILabel!
    var isHighlight = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        getCountryListData()
        loadSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func loadSubviews() {
        
        self.phoneTxd = fc_textfiledInit(placeholder: "请输入手机号", holderColor: COLOR_MinorTextColor, textColor: UIColor.white, fontSize: 15, borderStyle: UITextField.BorderStyle.none)
        self.phoneTxd.keyboardType = .phonePad
        //let leftView = UIImageView.init(image: UIImage(named: "mine_phone"))
        //self.phoneTxd.leftView = leftView
        self.phoneTxd.leftViewMode = .always
        setupRightView()
        self.phoneTxd.leftView = rightView
        self.phoneTxd.rightViewMode = .always
        self.phoneTxd.clearButtonMode = .whileEditing
        self.phoneTxd.delegate = self
        self.phoneTxd.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        bottomLine = UIView.init(frame: .zero)
        bottomLine.backgroundColor = COLOR_LineColor
        
        topTitleL = UILabel()
        topTitleL.isHidden = true
        topTitleL.textColor = COLOR_MinorTextColor
        topTitleL.textAlignment = .left
        topTitleL.font = self.phoneTxd.font
        topTitleL.backgroundColor = .clear
        topTitleL.text = phoneTxd.placeholder;
        self.addSubview(topTitleL)
        self.addSubview(self.phoneTxd)
        self.addSubview(bottomLine)
        
        topTitleL.snp.makeConstraints { (make) in
            make.left.equalTo(50)
            make.bottom.equalTo(0)
        }
        
        self.phoneTxd.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(40)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.top.equalTo(self.phoneTxd.snp.bottom).offset(-0.5)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.equalTo(0.5)
            make.bottom.equalToSuperview()
        }
        
        setupDropDownView()
    }
    
    private func setupRightView () {
        
        topRegionL = UILabel()
        topRegionL.textColor = COLOR_MinorTextColor
        topRegionL.textAlignment = .left
        topRegionL.font = self.phoneTxd.font
        topRegionL.backgroundColor = .clear
        topRegionL.text = "地区"
        self.addSubview(topRegionL)
        
        self.coutryCode = self.countryList.defaultCountryCode?.code ?? ""
        let rightBtn: UIButton = fc_buttonInit(imgName: "arrow_down", title: self.countryList.defaultCountryCode?.code, fontSize: 15, titleColor: UIColor.white, bgColor: COLOR_BGColor)
          rightBtn.contentHorizontalAlignment = .left
          rightBtn.semanticContentAttribute = .forceRightToLeft
          rightBtn.rx.tap.subscribe { (onNext) in
             self.dropDown?.show()
          }.disposed(by: disposeBag)
        self.rightBtn = rightBtn
        
//        let imgBtn = UIButton(type: .custom)
//        imgBtn.setImage(UIImage(named: ""), for: .normal)
//        imgBtn.rx.tap.subscribe {  (onNext) in
//           self.dropDown?.show()
//        }.disposed(by: disposeBag)
//        self.imgBtn = imgBtn
        
        self.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 44))
        self.rightView.addSubview(rightBtn)
        //self.rightView.addSubview(imgBtn)
        
        topRegionL.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(-40)
        }
        
        rightBtn.snp.makeConstraints { (make) in
            
            make.edges.equalToSuperview()
            make.width.equalTo(60)
        }
        
//        imgBtn.snp.makeConstraints { (make) in
//            make.top.equalToSuperview()
//            make.right.equalToSuperview()
//            make.left.equalTo(rightBtn.snp.right)
//            make.width.equalTo(0)
//            make.bottom.equalToSuperview()
//        }
    }
    
    @objc private func textFieldChange(textField: UITextField) {
        
        if textField.text?.count ?? 0 > 0 {
            
            UIView.animate(withDuration: 0.2) {
                
                self.topTitleL.snp_updateConstraints { (make) in
                    make.bottom.equalTo(-40)
                }
                self.layoutIfNeeded()
            }
            topTitleL.isHidden = false
            self.bottomLine?.backgroundColor = isHighlight ? COLOR_MainThemeColor : COLOR_MinorTextColor
            topRegionL.textColor = self.bottomLine?.backgroundColor
            topTitleL.textColor = self.bottomLine?.backgroundColor
        }else {
            
            UIView.animate(withDuration: 0.2) {
                
                self.topTitleL.snp_updateConstraints { (make) in
                    make.bottom.equalTo(0)
                }
                self.layoutIfNeeded()
            }
            topTitleL.isHidden = true
            self.bottomLine?.backgroundColor = COLOR_MinorTextColor
            topTitleL.textColor = self.bottomLine?.backgroundColor
            topRegionL.textColor = self.bottomLine?.backgroundColor
        }
    }
    
    private func setupDropDownView(){
                
        self.dropDown = DropDown()
        self.dropDown?.dataSource = getDropDownDataSource()
        self.dropDown?.anchorView = self.phoneTxd
        self.dropDown?.bottomOffset = CGPoint(x: 0, y: 40)
        self.dropDown?.selectRow(0)  //默认选中
        self.dropDown?.textFont = UIFont.init(_PingFangSCTypeSize: 12)
        self.dropDown?.textColor = COLOR_MinorTextColor
        self.dropDown?.cellHeight = 40
        self.dropDown?.selectedTextColor = UIColor.white
        self.dropDown?.backgroundColor = COLOR_CellBgColor
        self.dropDown?.selectionBackgroundColor = COLOR_CellBgColor
        self.dropDown?.separatorColor = .clear
        //self.dropDown?.separatorInsetLeft = true //分割线左对齐
        
        self.dropDown?.selectionAction = { [unowned self] (index: Int, item: String) in
            self.rightBtn.setTitle(self.countryList.countryCodes?[index].code ?? "", for: .normal)
            self.coutryCode = self.countryList.countryCodes?[index].code ?? ""
        }
    }
    
    @objc private func dropDownShow() {
        
        self.dropDown?.show()
    }
    
    private func getCountryListData () {
        let countryListData =  FCDictionaryService.sharedInstance.queryCacheByKey(key: FCDictionaryService.FC_COUNTRYCODE_LIST) as? [String : Any]
        
        self.countryList = FCountryCodeModel.stringToObject(jsonData: countryListData)
            
        /// 为获取到国家吗
        if self.countryList.countryCodes == nil {
            
            let defaultCountryCode = FCCountryCodeItem()
            defaultCountryCode.code = "+86"
            defaultCountryCode.name = "中国"
            
            let item1 = FCCountryCodeItem()
            item1.name = "中国"
            item1.code = "+86"
            
            let item2 = FCCountryCodeItem()
            item2.name = "South Korea"
            item2.code = "+82"
            
            let item3 = FCCountryCodeItem()
            item3.name = "中国台湾"
            item3.code = "+886"

            let item4 = FCCountryCodeItem()
            item4.name = "中国香港"
            item4.code = "+852"
            
            let item5 = FCCountryCodeItem()
            item5.name = "日本"
            item4.code = "+81"

           let countryCodes = [item1,item2,item3,item4,item5]
            
            self.countryList.defaultCountryCode = defaultCountryCode
            self.countryList.countryCodes = countryCodes
        }
    }
    
    private func getDropDownDataSource () -> [String] {
        var dataSource: [String] = []
        for item: FCCountryCodeItem in self.countryList.countryCodes ?? [] {
            let string = (item.code ?? "") + " " + (item.name ?? "")
            dataSource.append(string)
        }
        
        return dataSource
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let toBeStr = textField.text
        let rag = toBeStr?.toRange(range)
        let tempStr = textField.text?.replacingCharacters(in:rag!, with: string)
        
        return (tempStr?.isMatch("[0-9]{0,11}$"))!
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
            
        if let textFieldDidBeginEditingBlock = self.textFieldDidBeginEditingBlock {
            textFieldDidBeginEditingBlock()
        }
    }
    
}
