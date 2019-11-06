//
//  ZLSearchFilterViewModelForUser.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchFilterViewModelForUser: ZLBaseViewModel {
    
    weak var searchFilterview : ZLSearchFilterViewForUser?
    
    var searchFilterModel : ZLSearchFilterInfoModel?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        // 设置View
        guard let view : ZLSearchFilterViewForUser = targetView as? ZLSearchFilterViewForUser else
        {
            return
        }
        self.searchFilterview = view
        
        // 设置model
        guard let model: ZLSearchFilterInfoModel = targetModel as? ZLSearchFilterInfoModel else
        {
            return
        }
        self.searchFilterModel = model;
        
        // 根据model初始化view
        self.setViewDataForSearchFilterViewForUser(searchFilterModel: model, view: self.searchFilterview!)
    }
    
    
    func setViewDataForSearchFilterViewForUser(searchFilterModel:ZLSearchFilterInfoModel,view: ZLSearchFilterViewForUser)
    {
        if searchFilterModel.order != ""
        {
            self.searchFilterview?.orderButton.setTitle(searchFilterModel.order, for: .normal)
        }
        if searchFilterModel.language != ""
        {
            self.searchFilterview?.languageButton.setTitle(searchFilterModel.language, for:.normal)
        }
        
        self.searchFilterview?.firstTimeFileld.text = searchFilterModel.firstCreatedTimeStr
        self.searchFilterview?.secondTimeField.text = searchFilterModel.secondCreatedTimeStr
        self.searchFilterview?.firstFollowerNumField.text = String(searchFilterModel.firstFollowersNum)
        self.searchFilterview?.secondPubRepoNumField.text = String(searchFilterModel.secondFollowersNum)
        self.searchFilterview?.firstPubRepoNumField.text = String(searchFilterModel.firstPubReposNum)
        self.searchFilterview?.secondPubRepoNumField.text = String(searchFilterModel.secondPubReposNum)
    }
    
    @IBAction func onFinishButtonClicked(_ sender: UIButton) {
           
           self.searchFilterModel = ZLSearchFilterInfoModel.init()
           self.searchFilterModel!.order = self.searchFilterview?.orderButton.title(for: .normal) ?? ""
           self.searchFilterModel!.language = self.searchFilterview?.languageButton.title(for: .normal) ?? ""
           self.searchFilterModel!.firstCreatedTimeStr = self.searchFilterview?.firstTimeFileld.text ?? ""
           self.searchFilterModel!.secondCreatedTimeStr = self.searchFilterview?.secondTimeField.text ?? ""
           self.searchFilterModel!.firstFollowersNum = UInt(self.searchFilterview?.firstFollowerNumField.text ?? "0") ?? 0
           self.searchFilterModel!.secondFollowersNum = UInt(self.searchFilterview?.secondFollowerNumField.text ?? "0") ?? 0
           self.searchFilterModel!.firstPubReposNum = UInt(self.searchFilterview?.firstPubRepoNumField.text ?? "0") ?? 0
           self.searchFilterModel!.secondPubReposNum = UInt(self.searchFilterview?.secondPubRepoNumField.text ?? "0") ?? 0
           
           self.super?.getEvent(ZLSearchItemsViewEventType.userFilterResult, fromSubViewModel: self)
           
           sender.superview?.superview?.removeFromSuperview();
       }

}
