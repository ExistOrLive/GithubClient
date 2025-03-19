//
//  ZLSettingController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/9/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLSettingController: ZMViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "setting", comment: "设置")

        let tableView = UITableView.init(frame: CGRect.init(), style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ZLSettingItemTableViewCell.self, forCellReuseIdentifier: "ZLSettingItemTableViewCell")
        tableView.register(ZLSettingItemTableViewCell1.self, forCellReuseIdentifier: "ZLSettingItemTableViewCell1")
        tableView.register(ZLSettingLogoutTableViewCell.self, forCellReuseIdentifier: "ZLSettingLogoutTableViewCell")
        self.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        let viewModel = ZLSettingViewModel(tableView: tableView)
        self.zm_addSubViewModel(viewModel)
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
