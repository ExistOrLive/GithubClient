//
//  ZLFeedbackController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLFeedbackController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "feedback", comment: "反馈")
        
        let viewModel = ZLFeedbackViewModel()
        
        guard let feedbackView : ZLFeedbackView = Bundle.main.loadNibNamed("ZLFeedbackView", owner: viewModel, options: nil)?.first as? ZLFeedbackView else {
            return
        }
        self.contentView.addSubview(feedbackView)
        feedbackView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        self.addSubViewModel(viewModel)
        viewModel.bindModel(nil, andView: feedbackView)
    }
}
