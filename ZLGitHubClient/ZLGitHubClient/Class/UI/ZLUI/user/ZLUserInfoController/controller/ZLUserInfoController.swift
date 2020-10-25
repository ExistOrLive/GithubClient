//
//  ZLUserInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/11.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserInfoController: ZLBaseViewController {
    
    private var userInfoModel : ZLGithubUserModel?

    required init()
    {
        self.userInfoModel = nil;
        super.init(nibName: nil, bundle: nil)
    }
    
    convenience init(loginName: String, type : ZLGithubUserType)
    {
        self.init()
        self.userInfoModel = ZLGithubUserModel()
        self.userInfoModel?.loginName = loginName
        self.userInfoModel?.type = type
    }
    
    convenience init(userInfoModel: ZLGithubUserModel)
    {
        self.init()
        self.userInfoModel = userInfoModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        self.title = ZLLocalizedString(string: "User", comment: "用户")

        self.viewModel = ZLUserInfoViewModel.init(viewController: self)
        
        guard let baseView : ZLUserInfoView = Bundle.main.loadNibNamed("ZLUserInfoView", owner: self.viewModel, options: nil)?.first as? ZLUserInfoView else
        {
            return
        }
        
        let scrollView = UIScrollView.init()
        scrollView.backgroundColor = UIColor.clear
        self.contentView.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(baseView)
        scrollView.isScrollEnabled = true
        baseView.snp.makeConstraints { (make) in
            make.edges.equalTo(scrollView)
            make.width.equalTo(self.contentView.snp_width)
        }
        
        // bind view and viewModel
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
