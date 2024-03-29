//
//  ZLUserAdditionInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLBaseUI

@objcMembers class ZLUserAdditionInfoController: ZLBaseViewController {

    var type: ZLUserAdditionInfoType = .repositories                       // ! 附加信息类型 仓库/代码片段等
    var login: String?                                        // login

    override func viewDidLoad() {
        super.viewDidLoad()

        // viewModel
        let viewModel = ZLUserAdditionInfoViewModel()

        // view
        let baseView = ZLGithubItemListView()
        baseView.setTableViewHeader()
        baseView.setTableViewFooter()
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
        }

        self.addSubViewModel(viewModel)
        // bind view and viewModel
        if let login = self.login {
            viewModel.bindModel((self.type, login), andView: baseView)
        } else {
            viewModel.bindModel(nil, andView: baseView)
        }

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
