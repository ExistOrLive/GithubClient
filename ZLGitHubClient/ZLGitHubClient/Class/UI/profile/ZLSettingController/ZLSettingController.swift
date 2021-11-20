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

        self.title = ZLLocalizedString(string: "setting", comment: "设置")
        
        let tableView = UITableView.init(frame: CGRect.init(), style: .grouped)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.register(ZLSettingItemTableViewCell.self, forCellReuseIdentifier: "ZLSettingItemTableViewCell")
        tableView.register(ZLSettingItemTableViewCell1.self, forCellReuseIdentifier: "ZLSettingItemTableViewCell1")
        tableView.register(UINib.init(nibName: "ZLSettingLogoutTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLSettingLogoutTableViewCell")
        self.contentView.addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        let viewModel = ZLSettingViewModel()
        self.addSubViewModel(viewModel)
        viewModel.bindModel(nil, andView:tableView)
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
