//
//  ZLProfileViewController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/21.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

class ZLProfileViewController: ZLBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    func setupUI() {
        setZLNavigationBarHidden(true)
        view.addSubview(profileView)
        profileView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        addSubViewModel(profileViewModel)
        profileViewModel.bindModel(nil, andView: profileView)
    }
    
    //MARK: Lazy View
    private lazy var profileView: UIView = {
        if let view = Bundle.main.loadNibNamed("ZLProfileBaseView", owner: profileViewModel, options: nil)?.first as? UIView {
            return view
        } else {
            return UIView()
        }
    }()
    
    private lazy var profileViewModel: ZLProfileBaseViewModel = {
        ZLProfileBaseViewModel()
    }()
}
