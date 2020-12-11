//
//  ZLSearchController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // 创建ViewModel
        let viewModel = ZLSearchViewModel()
        self.addSubViewModel(viewModel)
        
        // 创建ZLSearchView
        guard let baseView: ZLSearchView = Bundle.main.loadNibNamed("ZLSearchView", owner: viewModel, options: nil)?.first as? ZLSearchView else
        {
            ZLLog_Warn("load ZLSearchView failed")
            return
        }
        baseView.frame = ZLScreenBounds
        self.view.addSubview(baseView)
        
        // 绑定view viewModel VC
        viewModel.bindModel(nil, andView: baseView)
    
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
