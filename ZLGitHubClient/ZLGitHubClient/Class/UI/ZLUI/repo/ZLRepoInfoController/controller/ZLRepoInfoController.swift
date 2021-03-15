//
//  ZLRepoInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

 class ZLRepoInfoController: ZLBaseViewController {

    @objc var repoInfoModel: ZLGithubRepositoryModel?
    
    private weak var baseView : ZLRepoInfoView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let repoInfoModel = self.repoInfoModel {
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
            viewModel.bindModel(repoInfoModel, andView: baseView)
        }
    }
    
    override func onBackButtonClicked(_ button: UIButton!) {
        super.onBackButtonClicked(button)
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
