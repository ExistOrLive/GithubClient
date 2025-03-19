//
//  ZLAppearanceController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLGitRemoteService

class ZLLanguageController: ZMViewController, ZLLanguageViewDelegate {

    var selectIndex: Int {
        (LANMODULE?.currentLanguageType() ?? ZLLanguageType.auto).rawValue + 1
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = ZLLocalizedString(string: "Language", comment: "")
        let languageView = ZLLanguageView()
        contentView.addSubview(languageView)
        languageView.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.top.bottom.equalTo(self.contentView)
        }
        languageView.fillWithData(data: self)
    }

    func onButtonClicked(index: Int) {
        guard let languageChoice = ZLLanguageType(rawValue: index - 1) else {
            return
        }
        LANMODULE?.setLanguageType(languageChoice, error: nil)
        navigationController?.popViewController(animated: true)
    }

}
