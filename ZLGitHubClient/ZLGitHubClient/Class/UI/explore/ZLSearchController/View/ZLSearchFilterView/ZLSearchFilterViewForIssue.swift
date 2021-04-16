//
//  ZLSearchFilterViewForIssue.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLSearchFilterViewForIssue: UIView {

    static let minWidth : CGFloat = 300.0
    
    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var stateLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var stateButton: UIButton!
    
    @IBOutlet weak var finishButton: UIButton!
    
    weak var popup : FFPopup?
    
    var resultBlock : ((ZLSearchFilterInfoModel) -> Void)?
    
    static func showSearchFilterViewForIssue(filterInfo:ZLSearchFilterInfoModel?, resultBlock:((ZLSearchFilterInfoModel) -> Void)?){
        guard  let view : ZLSearchFilterViewForIssue = Bundle.main.loadNibNamed("ZLSearchFilterViewForIssue", owner: nil, options: nil)?.first as? ZLSearchFilterViewForIssue else {
            return
        }
        view.frame = CGRect.init(x: 0, y: 0, width: ZLSearchFilterViewForIssue.minWidth, height: ZLSCreenHeight)
        view.setViewDataForSearchFilterViewForIssue(searchFilterModel: filterInfo)
        view.resultBlock = resultBlock
        
        let popup = FFPopup(contetnView: view, showType: .slideInFromRight, dismissType: .slideOutToRight, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: FFPopupLayout.init(horizontal: FFPopup.HorizontalLayout.right, vertical: FFPopup.VerticalLayout.center))
    }
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        self.orderLabel.text = ZLLocalizedString(string: "Order", comment: "排序")
        self.languageLabel.text = ZLLocalizedString(string: "Language", comment: "语言")
        self.stateLabel.text = ZLLocalizedString(string: "State", comment: "状态")
        
        self.stateButton.setTitle("Open", for: .normal)
        self.stateButton.setTitle("Closed", for: .selected)
        
        self.finishButton.setTitle(ZLLocalizedString(string: "FilterFinish", comment: ""), for: .normal)
        
                
        let gestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(resignAllResponder))
        self.addGestureRecognizer(gestureRecognizer)
        
        self.finishButton.titleLabel?.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 14)
    }
    
    @IBAction func onOrderButtonClicked(_ sender: UIButton) {
        ZLSearchFilterPickerView.showPROrderPickerView(initTitle:sender.titleLabel?.text, resultBlock: {(result: String) in
            sender.setTitle(result, for: .normal)
        })
    }
    
    
    @IBAction func onLanguageButtonClicked(_ sender: UIButton) {
        ZLLanguageSelectView.showLanguageSelectView { (result : String?) in
            sender.setTitle(result ?? "Any", for: .normal)
        }
    }
    
    @IBAction func onStateButtonClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @objc func resignAllResponder()
    {
        self.endEditing(true)
    }
    
    func setViewDataForSearchFilterViewForIssue(searchFilterModel:ZLSearchFilterInfoModel?)
    {
        if searchFilterModel == nil {
            return
        }
        
        if searchFilterModel?.order != nil {
            if searchFilterModel?.order == "created" && searchFilterModel?.isAsc == false {
                self.orderButton.setTitle("Newest", for: .normal)
            } else if searchFilterModel?.order == "created" && searchFilterModel?.isAsc == true  {
                self.orderButton.setTitle("Oldest", for: .normal)
            } else if searchFilterModel?.order == "comments" && searchFilterModel?.isAsc == false {
                self.orderButton.setTitle("Most commented", for: .normal)
            } else if searchFilterModel?.order == "comments" && searchFilterModel?.isAsc == true {
                self.orderButton.setTitle("Least commented", for: .normal)
            } else if searchFilterModel?.order == "updated" && searchFilterModel?.isAsc == false {
                self.orderButton.setTitle("Recently updated", for: .normal)
            } else if searchFilterModel?.order == "updated" && searchFilterModel?.isAsc == true {
                self.orderButton.setTitle("Least recently updated", for: .normal)
            }
        }
        if searchFilterModel?.language != ""{
            self.languageButton.setTitle(searchFilterModel?.language, for:.normal)
        }
        
        self.stateButton.isSelected = searchFilterModel?.issueOrPRClosed ?? false
    }
    
    
    @IBAction func onFinishButtonClicked(_ sender: Any) {
        
        let searchFilterModel = ZLSearchFilterInfoModel()
        let str = self.orderButton.title(for: .normal) ?? ""
        switch(str){
        case "Newest":do{
            searchFilterModel.isAsc = false
            searchFilterModel.order = "created"
        }
        case "Oldest":do{
            searchFilterModel.isAsc = true
            searchFilterModel.order = "created"
        }
        case "Most commented":do{
            searchFilterModel.isAsc = false
            searchFilterModel.order = "comments"
        }
        case "Least commented":do{
            searchFilterModel.isAsc = true
            searchFilterModel.order = "comments"
        }
        case "Recently updated":do{
            searchFilterModel.isAsc = false
            searchFilterModel.order = "updated"
        }
        case "Least recently updated":do{
            searchFilterModel.isAsc = true
            searchFilterModel.order = "updated"
        }
        default:do{
            searchFilterModel.order = nil
        }
        }
        searchFilterModel.language = self.languageButton.title(for: .normal) ?? ""
        
        searchFilterModel.issueOrPRClosed = self.stateButton.isSelected
        
        if self.resultBlock != nil {
            self.resultBlock?(searchFilterModel)
        }
        
        self.popup?.dismiss(animated: true)
    }
    
    
}
