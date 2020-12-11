//
//  ZLUserAdditionInfoController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/31.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLUserAdditionInfoController: ZLBaseViewController {

    var type : ZLUserAdditionInfoType?                        //! 附加信息类型 仓库/代码片段等
    var userInfo : ZLGithubUserBriefModel?                  //! 用户信息
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // viewModel
        let viewModel = ZLUserAdditionInfoViewModel()
        
        // view
        guard let baseView = Bundle.main.loadNibNamed("ZLUserAdditionInfoView", owner: viewModel, options: nil)?.first as? ZLUserAdditionInfoView else
        {
            ZLLog_Warn("ZLUserAdditionInfoView load failed")
            self.navigationController?.popViewController(animated: false)
            return;
        }
        self.contentView.addSubview(baseView)
        baseView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.addSubViewModel(viewModel)
        // bind view and viewModel
        if self.type == nil || self.userInfo == nil
        {
            viewModel.bindModel(nil, andView: baseView)
        }
        else
        {
            viewModel.bindModel(["type":self.type!,"userInfo":self.userInfo!], andView: baseView)
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
