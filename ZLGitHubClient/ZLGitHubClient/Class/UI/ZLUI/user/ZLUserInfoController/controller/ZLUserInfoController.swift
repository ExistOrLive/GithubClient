//
//  ZLUserInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserInfoController: ZLBaseViewController {
    
    @objc var userInfoModel : ZLGithubUserModel!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if self.userInfoModel == nil {
            ZLToastView.showMessage(ZLLocalizedString(string: "User is invalid", comment: ""))
            return
        }
        
        self.title = ZLLocalizedString(string: "User", comment: "用户")

        let viewModel = ZLUserInfoViewModel()
        guard let baseView : ZLUserInfoView = Bundle.main.loadNibNamed("ZLUserInfoView", owner: viewModel, options: nil)?.first as? ZLUserInfoView else{
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
        // bind view and viewModel
        viewModel.bindModel(self.userInfoModel, andView: baseView)
        
        analytics.log(.viewItem(name: userInfoModel.loginName))

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
