//
//  ZLRepoInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

 class ZLRepoInfoController: ZLBaseViewController {

    @objc var fullName: String?
    @objc var repoInfoModel: ZLGithubRepositoryModel?
    
    private weak var baseView : ZLRepoInfoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !(repoInfoModel?.full_name != nil &&
                repoInfoModel!.full_name!.contains(find: "/")) &&
            !(fullName != nil &&
                fullName!.contains(find: "/")){
            ZLToastView.showMessage("invalid full name")
            return
        }
        
        let baseView = ZLRepoInfoView.init(frame: CGRect())
        self.baseView = baseView
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
        })
        
        let viewModel = ZLRepoInfoViewModel()
        self.addSubViewModel(viewModel)
        
        if repoInfoModel?.full_name != nil &&
            repoInfoModel!.full_name!.contains(find: "/") {
            
            viewModel.bindModel(repoInfoModel, andView: baseView)
            analytics.log(.viewItem(name: repoInfoModel!.full_name!))
            
        } else if fullName != nil &&
                    fullName!.contains(find: "/") {
            
            let repoInfoModel = ZLGithubRepositoryModel()
            repoInfoModel.full_name = fullName
            viewModel.bindModel(repoInfoModel, andView: baseView)
            analytics.log(.viewItem(name: fullName!))
        } 
        
    }
}
