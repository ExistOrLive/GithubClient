//
//  ZLSearchFilterViewModelForRepo.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchFilterViewModelForRepo: ZLBaseViewModel {
    
    var searchFilterview : ZLSearchFilterViewForRepo?
    
    var searchFilterModel : ZLSearchFilterInfoModel?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let view : ZLSearchFilterViewForRepo = targetView as? ZLSearchFilterViewForRepo else
        {
            return
        }
        
        self.searchFilterview = view
        
        guard let model : ZLSearchFilterInfoModel = targetModel as? ZLSearchFilterInfoModel else
        {
            return
        }
        
        self.searchFilterModel = model
        self.setViewDataForSearchFilterViewForRepo(searchFilterModel: model, view: self.searchFilterview!)
        
        
    }
    
    func setViewDataForSearchFilterViewForRepo(searchFilterModel: ZLSearchFilterInfoModel, view:ZLSearchFilterViewForRepo)
    {
        if searchFilterModel.order != ""
        {
           view.orderButton.setTitle(searchFilterModel.order, for:.normal)
        }
        
        if searchFilterModel.language != ""
        {
            view.languageButton.setTitle(searchFilterModel.language, for: .normal)
        }
        
        
    }
    

    @IBAction func onFinishButtonClicked(_ sender: Any) {
        
        self.searchFilterModel = ZLSearchFilterInfoModel.init()
        self.searchFilterModel!.order = self.searchFilterview?.orderButton.title(for: .normal) ?? ""
        self.searchFilterModel!.language = self.searchFilterview?.languageButton.title(for: .normal) ?? ""
        self.searchFilterModel!.firstCreatedTimeStr = self.searchFilterview?.firstTimeFileld.text ?? ""
        self.searchFilterModel!.secondCreatedTimeStr = self.searchFilterview?.secondTimeField.text ?? ""
        self.searchFilterModel!.firstForkNum = UInt(self.searchFilterview?.firstForkNumField.text ?? "0") ?? 0
        self.searchFilterModel!.secondForkNum = UInt(self.searchFilterview?.secondForkNumField.text ?? "0") ?? 0
        self.searchFilterModel!.firstStarNum = UInt(self.searchFilterview?.firstStarNumField.text ?? "0") ?? 0
        self.searchFilterModel!.secondStarNum = UInt(self.searchFilterview?.secondStarNumField.text ?? "0") ?? 0
        self.searchFilterModel!.size = Double(self.searchFilterview?.sizeFiled.text ?? "0.0") ?? 0.0
        
        self.super?.getEvent(ZLSearchItemsViewEventType.repoFilterResult, fromSubViewModel: self)
        
        
    }
}
