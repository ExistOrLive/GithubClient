//
//  ZLEditProfileController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import IQKeyboardManager

class ZLEditProfileController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "EditProfile", comment: "编辑主页")

        let viewModel = ZLEditProfileViewModel()
        self.addSubViewModel(viewModel)

        self.contentView.addSubview(editProfileView)
        editProfileView.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
        })
        viewModel.bindModel(nil, andView: editProfileView)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }

    // MARK: Lazy View
    lazy var editProfileView: ZLEditProfileContentView = {
       let view = ZLEditProfileContentView()
        return view
    }()
    

}
