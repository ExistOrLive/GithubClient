//
//  ZLAppearanceController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/31.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLAppearanceController: ZLBaseViewController, ZLAppearanceViewDelegate {

    var selectIndex: Int {
        if #available(iOS 13.0, *) {
            return ZLUISharedDataManager.currentUserInterfaceStyle.rawValue
        }
        return 0
    }

    func onButtonClicked(index: Int) {

        if #available(iOS 13.0, *) {
            let interfaceStyle: UIUserInterfaceStyle  = UIUserInterfaceStyle.init(rawValue: index) ?? UIUserInterfaceStyle.unspecified
            ZLUISharedDataManager.currentUserInterfaceStyle = interfaceStyle
            UIApplication.shared.delegate?.window??.overrideUserInterfaceStyle = interfaceStyle
            NotificationCenter.default.post(name: ZLUserInterfaceStyleChange_Notification, object: nil)
        }
        self.navigationController?.popViewController(animated: true)
    }

    override func viewDidLoad() {

        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "Appearance", comment: "")

        let view = ZLAppearanceView()
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.contentView)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
        }

        view.fillWithData(data: self)
    }

}
