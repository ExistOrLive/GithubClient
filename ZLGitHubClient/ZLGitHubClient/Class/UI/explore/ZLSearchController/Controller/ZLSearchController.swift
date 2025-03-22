//
//  ZLSearchController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLUIUtilities

class ZLSearchController: ZMViewController {

    @objc var searchKey: String?
    
    lazy var viewModel: ZLSearchViewModel =  {
        let viewModel = ZLSearchViewModel(searchKey: self.searchKey)
        return viewModel
    }()
    
    lazy var searchView: ZLSearchView = {
        ZLSearchView()
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        zm_addSubViewModel(viewModel)
        searchView.zm_fillWithData(data: viewModel)
    }
    
    override func setupUI() {
        super.setupUI()
        isZmNavigationBarHidden = true
        self.contentView.addSubview(searchView)
        searchView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
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
