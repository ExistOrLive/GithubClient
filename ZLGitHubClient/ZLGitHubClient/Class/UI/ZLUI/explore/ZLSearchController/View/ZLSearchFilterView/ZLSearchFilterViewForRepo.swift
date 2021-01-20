//
//  ZLSearchFilterViewForRepo.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/18.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchFilterViewForRepo: ZLBaseView {
    
    static let minWidth : CGFloat = 300.0
    
    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var createTimeLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var forkLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    
    @IBOutlet weak var firstTimeFileld: UITextField!
    @IBOutlet weak var secondTimeField: UITextField!
    @IBOutlet weak var firstStarNumField: UITextField!
    @IBOutlet weak var secondStarNumField: UITextField!
    @IBOutlet weak var firstForkNumField: UITextField!
    @IBOutlet weak var secondForkNumField: UITextField!
    
    weak var popup : FFPopup?
    
    var resultBlock : ((ZLSearchFilterInfoModel) -> Void)?
    
    static func showSearchFilterViewForRepo(filterInfo:ZLSearchFilterInfoModel?, resultBlock:((ZLSearchFilterInfoModel) -> Void)?){
        guard  let view : ZLSearchFilterViewForRepo = Bundle.main.loadNibNamed("ZLSearchFilterViewForRepo", owner: nil, options: nil)?.first as? ZLSearchFilterViewForRepo else {
            return
        }
        view.frame = CGRect.init(x: 0, y: 0, width: ZLSearchFilterViewForRepo.minWidth, height: ZLSCreenHeight)
        view.setViewDataForSearchFilterViewForRepo(searchFilterModel: filterInfo)
        view.resultBlock = resultBlock
        
        let popup = FFPopup(contetnView: view, showType: .slideInFromRight, dismissType: .slideOutToRight, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: FFPopupLayout.init(horizontal: FFPopup.HorizontalLayout.right, vertical: FFPopup.VerticalLayout.center))
    }
    
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.orderLabel.text = ZLLocalizedString(string: "Order", comment: "排序")
        self.languageLabel.text = ZLLocalizedString(string: "Language", comment: "语言")
        self.createTimeLabel.text = ZLLocalizedString(string: "CreateTime", comment: "创建于")
        self.starLabel.text = ZLLocalizedString(string: "StarNum", comment: "标星")
        self.forkLabel.text = ZLLocalizedString(string: "ForkNum", comment: "复制")
        self.finishButton.setTitle(ZLLocalizedString(string: "FilterFinish", comment: ""), for: .normal)
        
        
        self.firstTimeFileld.delegate = self;
        self.secondTimeField.delegate = self;
        self.firstForkNumField.delegate = self;
        self.secondForkNumField.delegate = self;
        self.firstStarNumField.delegate = self;
        self.secondStarNumField.delegate = self;
        
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(resignAllResponder))
        self.addGestureRecognizer(gestureRecognizer)
        
        self.finishButton.titleLabel?.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 14)
    }
    
    @IBAction func onOrderButtonClicked(_ sender: UIButton) {
        
        ZLSearchFilterPickerView.showRepoOrderPickerView(initTitle:sender.titleLabel?.text, resultBlock: {(result: String) in
            sender.setTitle(result, for: .normal)
        })
    }
    
    
    @IBAction func onLanguageButtonClicked(_ sender: UIButton) {
        
        ZLLanguageSelectView.showLanguageSelectView { (result : String?) in
            sender.setTitle(result ?? "Any", for: .normal)
        }
    }
    
    @objc func resignAllResponder(){
        self.endEditing(true)
    }
    
    func setViewDataForSearchFilterViewForRepo(searchFilterModel: ZLSearchFilterInfoModel?)
    {
        if searchFilterModel == nil {
            return
        }
        
        if searchFilterModel?.order != ""{
            self.orderButton.setTitle(searchFilterModel?.order, for:.normal)
        }
        
        if searchFilterModel?.language != ""{
            self.languageButton.setTitle(searchFilterModel?.language, for: .normal)
        }
        
        self.firstTimeFileld.text = searchFilterModel!.firstCreatedTimeStr
        self.secondTimeField.text = searchFilterModel!.secondCreatedTimeStr
        self.firstStarNumField.text = searchFilterModel!.firstStarNum == 0 ? nil : String(searchFilterModel!.firstStarNum)
        self.secondStarNumField.text = searchFilterModel!.secondStarNum == 0 ? nil : String(searchFilterModel!.secondStarNum)
        self.firstForkNumField.text = searchFilterModel!.firstForkNum == 0 ? nil : String(searchFilterModel!.firstForkNum)
        self.secondForkNumField.text = searchFilterModel!.secondForkNum == 0 ? nil : String(searchFilterModel!.secondForkNum)
    }
    
    
    
    @IBAction func onFinishButtonClicked(_ sender: Any) {
        
        let searchFilterModel = ZLSearchFilterInfoModel.init()
        searchFilterModel.order = self.orderButton.title(for: .normal) ?? ""
        searchFilterModel.language = self.languageButton.title(for: .normal) ?? ""
        searchFilterModel.firstCreatedTimeStr = self.firstTimeFileld.text ?? ""
        searchFilterModel.secondCreatedTimeStr = self.secondTimeField.text ?? ""
        searchFilterModel.firstForkNum = UInt(self.firstForkNumField.text ?? "0") ?? 0
        searchFilterModel.secondForkNum = UInt(self.secondForkNumField.text ?? "0") ?? 0
        searchFilterModel.firstStarNum = UInt(self.firstStarNumField.text ?? "0") ?? 0
        searchFilterModel.secondStarNum = UInt(self.secondStarNumField.text ?? "0") ?? 0
        
        if self.resultBlock != nil {
            self.resultBlock?(searchFilterModel)
        }
        
        self.popup?.dismiss(animated: true)
    }
    
}

//MARK:
extension ZLSearchFilterViewForRepo: UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool
    {
        
        if textField == self.firstTimeFileld || textField == self.secondTimeField{
            
            self.endEditing(true)
            ZLSearchFilterPickerView.showDatePickerView(resultBlock: {(dateStr:String) in
                textField.text = dateStr
            })
            return false
            
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
}
