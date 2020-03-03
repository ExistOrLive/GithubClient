
//
//  ZLEditProfileController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/26.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLEditProfileController: ZLBaseViewController {
    
    var userInfoModel : ZLGithubUserModel?              //! 用户信息
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "EditProfile", comment: "编辑主页")

        self.viewModel = ZLEditProfileViewModel.init(viewController: self)
        
        guard let baseView: ZLEditProfileView = Bundle.main.loadNibNamed("ZLEditProfileView", owner: self.viewModel, options: nil)?.first as? ZLEditProfileView else
        {
            ZLLog_Warn("ZLRepoInfoView can not be loaded");
            return;
        }
        
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        self.viewModel.bindModel(self.userInfoModel, andView: baseView)
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
