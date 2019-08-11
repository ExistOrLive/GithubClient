//
//  ZLExploreBaseViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLExploreBaseViewModel: ZLBaseViewModel {
    
    var baseView : ZLExploreBaseView?
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        if !(targetView is ZLExploreBaseView)
        {
            ZLLog_Warn("targetView is not ZLExploreBaseView,so return")
            return
        }
        self.baseView = targetView as? ZLExploreBaseView
    }
    

    @IBAction func onSearchButtonClicked(_ sender: Any) {
       let vc = ZLSearchController()
       vc.hidesBottomBarWhenPushed = true
       self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
}
