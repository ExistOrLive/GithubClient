//
//  ZLExploreViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI

class ZLExploreViewController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        setZLNavigationBarHidden(true)
        contentView.addSubview(exploreView)
        exploreView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        addSubViewModel(exploreViewModel)
        exploreViewModel.bindModel(nil, andView: exploreView)
    }
        
    // MARK: ZLExploreView
    lazy var exploreView: ZLExploreBaseView = {
        return ZLExploreBaseView() 
    }()
    
    lazy var exploreViewModel: ZLExploreBaseViewModel = {
        return ZLExploreBaseViewModel() 
    }()
}
