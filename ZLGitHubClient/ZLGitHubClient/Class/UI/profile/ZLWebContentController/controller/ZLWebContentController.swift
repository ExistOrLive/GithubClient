//
//  ZLWebContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/28.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLWebContentController: ZLBaseViewController {

    var requestURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "WebView"

        let viewModel = ZLWebContentViewModel()
        self.addSubViewModel(viewModel)

        guard let baseView = Bundle.main.loadNibNamed("ZLWebContentView", owner: viewModel, options: nil)?.first as? ZLWebContentView else {
            ZLLog_Warn("ZLWebContentView load failed,so return")
            return
        }
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        viewModel.bindModel(self.requestURL, andView: baseView)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)

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
