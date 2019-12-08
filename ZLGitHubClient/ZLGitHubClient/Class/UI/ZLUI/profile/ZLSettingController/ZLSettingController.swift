//
//  ZLSettingController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSettingController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.viewModel = ZLSettingViewModel.init(viewController: self)
        
        guard let baseView : ZLSettingView = Bundle.main.loadNibNamed("ZLSettingView", owner:self.viewModel , options: nil)?.first as? ZLSettingView else
        {
            ZLLog_Error("ZLSettingView load failed")
            return
        }
        
        baseView.frame = ZLScreenBounds
        self.view.addSubview(baseView)
        
        self.viewModel.bindModel(nil, andView: baseView)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
