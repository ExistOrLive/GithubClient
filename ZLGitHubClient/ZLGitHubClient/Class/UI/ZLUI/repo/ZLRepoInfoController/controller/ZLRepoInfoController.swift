//
//  ZLRepoInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/19.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLRepoInfoController: ZLBaseViewController {

    private var repoInfoModel: ZLGithubRepositoryModel?
    
    private weak var baseView : ZLRepoInfoView?
    
    required init() {
        self.repoInfoModel = nil;
        super.init(nibName: nil, bundle: nil);
    }
    
    convenience  init(repoInfoModel:ZLGithubRepositoryModel)
    {
        self.init()
        self.repoInfoModel = repoInfoModel;
    }
    
    convenience init(repoFullName: String)
    {
        self.init()
        let repoInfoModel = ZLGithubRepositoryModel.init()
        repoInfoModel.full_name = repoFullName
        self.repoInfoModel = repoInfoModel
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let baseView = ZLRepoInfoView.init(frame: CGRect())
        self.baseView = baseView
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        let viewModel = ZLRepoInfoViewModel()
        self.addSubViewModel(viewModel)
        viewModel.bindModel(self.repoInfoModel, andView: baseView)
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
