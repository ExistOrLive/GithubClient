//
//  ZLOrgInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/9.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLOrgInfoController: ZLBaseViewController {
    
    @objc var loginName: String?
    @objc var orgInfoModel: ZLGithubOrgModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if loginName == nil && orgInfoModel?.loginName == nil  {
            ZLToastView.showMessage(ZLLocalizedString(string: "org is invalid, name is nil", comment: ""))
            return
        }
        
        self.title = ZLLocalizedString(string: "organization", comment: "组织")

        let viewModel = ZLOrgInfoViewModel()
        guard let baseView : ZLOrgInfoView = Bundle.main.loadNibNamed("ZLOrgInfoView", owner: nil, options: nil)?.first as? ZLOrgInfoView else{
            return
        }
        
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = UIColor.clear
        self.contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
        }
        
        scrollView.addSubview(baseView)
        scrollView.isScrollEnabled = true
        baseView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(scrollView.snp_width)
        }
        self.addSubViewModel(viewModel)
        
        if let orgModel = orgInfoModel {
            viewModel.bindModel(orgModel, andView: baseView)
            analytics.log(.viewItem(name: orgModel.loginName!))
        } else if let login = loginName{
            let orgModel = ZLGithubOrgModel()
            orgModel.loginName = login
            viewModel.bindModel(orgModel, andView: baseView)
            analytics.log(.viewItem(name: login))
        }
    }
    


}
