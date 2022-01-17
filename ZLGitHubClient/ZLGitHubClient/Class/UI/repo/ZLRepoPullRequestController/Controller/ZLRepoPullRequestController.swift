//
//  ZLRepoPullRequestController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/15.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoPullRequestController: ZLBaseViewController {

    var repoFullName: String?

    override func viewDidLoad() {

        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "pull request", comment: "合并请求")

        let viewModel = ZLRepoPullRequestViewModel()

        let pullRequestView = ZLRepoPullRequestView()
        self.contentView.addSubview(pullRequestView)
        pullRequestView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

        self.addSubViewModel(viewModel)
        viewModel.bindModel(self.repoFullName, andView: pullRequestView)
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
