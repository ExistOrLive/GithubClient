//
//  ZLFeedbackController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

class ZLFeedbackController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = ZLLocalizedString(string: "feedback", comment: "反馈")

        let viewModel = ZLFeedbackViewModel()

        let feedbackView: ZLFeedbackView = ZLFeedbackView()
        self.contentView.addSubview(feedbackView)
        feedbackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })

        self.addSubViewModel(viewModel)
        viewModel.bindModel(nil, andView: feedbackView)
    }
}
