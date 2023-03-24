//
//  ZLRepoIssuesController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/14.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

class ZLRepoIssuesController: ZLBaseViewController {

    var repoFullName: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "issues", comment: "")

        let viewModel = ZLRepoIssuesViewModel()

        let repoIssuesView = ZLRepoIssuesView()
        self.contentView.addSubview(repoIssuesView)
        repoIssuesView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

        self.addSubViewModel(viewModel)
        viewModel.bindModel(repoFullName, andView: repoIssuesView)
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
