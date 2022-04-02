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

        let baseView = ZLWebContentView()
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        viewModel.bindModel(self.requestURL, andView: baseView)
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
