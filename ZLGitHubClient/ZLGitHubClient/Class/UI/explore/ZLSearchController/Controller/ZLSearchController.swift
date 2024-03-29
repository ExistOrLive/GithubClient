//
//  ZLSearchController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService

class ZLSearchController: ZLBaseViewController {

    @objc var searchKey: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setZLNavigationBarHidden(true)

        // 创建ViewModel
        let viewModel = ZLSearchViewModel()
        self.addSubViewModel(viewModel)

        // 创建ZLSearchView
        let baseView: ZLSearchView = ZLSearchView()
        self.view.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        // 绑定view viewModel VC
        viewModel.bindModel(searchKey, andView: baseView)

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
