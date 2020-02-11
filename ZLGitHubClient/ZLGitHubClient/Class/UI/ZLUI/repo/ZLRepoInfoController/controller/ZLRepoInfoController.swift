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
    
    required init() {
        super.init(nibName: nil, bundle: nil);
        self.repoInfoModel = nil;
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

        self.viewModel = ZLRepoInfoViewModel.init(viewController: self)
        
        guard let baseView: ZLRepoInfoView = Bundle.main.loadNibNamed("ZLRepoInfoView", owner: self.viewModel, options: nil)?.first as? ZLRepoInfoView else
        {
            ZLLog_Warn("ZLRepoInfoView can not be loaded");
            return;
        }
        baseView.frame = ZLScreenBounds
        self.view.addSubview(baseView)
        
        self.viewModel.bindModel(self.repoInfoModel, andView: baseView)
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
