
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

        let viewModel = ZLEditProfileViewModel()
        self.addSubViewModel(viewModel)
        
        guard let baseView: ZLEditProfileView = Bundle.main.loadNibNamed("ZLEditProfileView", owner: viewModel, options: nil)?.first as? ZLEditProfileView else
        {
            ZLLog_Warn("ZLRepoInfoView can not be loaded");
            return;
        }
        
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
        })
        viewModel.bindModel(self.userInfoModel, andView: baseView)
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
