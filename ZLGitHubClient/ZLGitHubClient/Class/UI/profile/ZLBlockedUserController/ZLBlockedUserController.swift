//
//  ZLBlockedUserController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/10/12.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLBlockedUserController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "Blocked User", comment: "屏蔽的用户")
        
        let view = ZLGithubItemListView.init();
        view.setTableViewHeader()
        
        self.contentView.addSubview(view);
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview();
        }
        
        
        let viewModel = ZLBlockedUserViewModel()
        self.addSubViewModel(viewModel)
        viewModel.bindModel(nil, andView: view)
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
