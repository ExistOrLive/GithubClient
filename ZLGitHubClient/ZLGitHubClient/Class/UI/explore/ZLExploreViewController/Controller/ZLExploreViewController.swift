//
//  ZLExploreViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities

class ZLExploreViewController: ZMViewController {

    override func setupUI() {
        super.setupUI()
        isZmNavigationBarHidden = true
        contentView.addSubview(exploreView)
        exploreView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exploreView.zm_fillWithData(data: exploreViewModel)
    }
        
    // MARK: ZLExploreView
    lazy var exploreView: ZLExploreBaseView = {
        return ZLExploreBaseView() 
    }()
    
    lazy var exploreViewModel: ZLExploreBaseViewModel = {
        let viewModel = ZLExploreBaseViewModel()
        self.zm_addSubViewModel(viewModel)
        return viewModel
    }()
}
