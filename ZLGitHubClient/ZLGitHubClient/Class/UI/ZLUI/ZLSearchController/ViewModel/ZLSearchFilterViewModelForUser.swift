//
//  ZLSearchFilterViewModelForUser.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchFilterViewModelForUser: ZLBaseViewModel {
    
    var searchFilterview : ZLSearchFilterViewForUser?
    
    var searchFilterModel : ZLSearchFilterInfoModel?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let view : ZLSearchFilterViewForUser = targetView as? ZLSearchFilterViewForUser else
        {
            return
        }
        
        self.searchFilterview = view
        
        
    }
    
    @IBAction func onFinishButtonClicked(_ sender: Any) {
        
        self.searchFilterModel = ZLSearchFilterInfoModel.init()
        self.searchFilterModel!.order = self.searchFilterview?.orderButton.title(for: .normal) ?? ""
        self.searchFilterModel!.language = self.searchFilterview?.languageButton.title(for: .normal) ?? ""
     
        
        
    }

}
