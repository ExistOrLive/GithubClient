//
//  ZLUserAdditionInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objcMembers class ZLUserAdditionInfoController: ZLBaseViewController {

    @objc var type : ZLUserAdditionInfoType = .repositories                       //! 附加信息类型 仓库/代码片段等
    @objc var login: String?                                        // login
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewModel
        let viewModel = ZLUserAdditionInfoViewModel()
        
        // view
        let baseView = ZLGithubItemListView()
        baseView.setTableViewHeader()
        baseView.setTableViewFooter()
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(self.contentView.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.contentView.safeAreaLayoutGuide.snp.right)
        }
        
        self.addSubViewModel(viewModel)
        // bind view and viewModel
        if self.login == nil{
            viewModel.bindModel(nil, andView: baseView)
        }
        else{
            viewModel.bindModel((self.type,self.login!), andView: baseView)
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
