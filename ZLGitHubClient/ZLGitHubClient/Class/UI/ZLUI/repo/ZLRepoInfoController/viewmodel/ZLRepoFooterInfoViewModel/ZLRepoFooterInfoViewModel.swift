//
//  ZLRepoFooterInfoViewModel.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/2.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoFooterInfoViewModel: ZLBaseViewModel {
    
    // model
    private var repoInfoModel : ZLGithubRepositoryModel?
    
    // view
    private var repoFooterInfoView : ZLRepoFooterInfoView?


    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        
        guard let repoInfoModel : ZLGithubRepositoryModel = targetModel as? ZLGithubRepositoryModel else {
            return
        }
        self.repoInfoModel = repoInfoModel
        
        guard let repoFooterInfoView : ZLRepoFooterInfoView = targetView as? ZLRepoFooterInfoView else
        {
            return
        }
        self.repoFooterInfoView = repoFooterInfoView
        
        
        self.loadREADME()
    }
    
    
    func loadREADME()
    {
        guard let fullName = self.repoInfoModel?.full_name else
        {
            return;
        }
        
        ZLRepoServiceModel.shared().getRepoReadMeInfo(withFullName:fullName , serialNumber: NSString.generateSerialNumber(), completeHandle: { (resultModel : ZLOperationResultModel) in
            
            self.repoFooterInfoView?.progressView.setProgress(0.3, animated: true)
            
            if resultModel.result == false
            {
                let errorModel : ZLGithubRequestErrorModel = resultModel.data as! ZLGithubRequestErrorModel
                self.repoFooterInfoView?.loadMarkdown(markDown: errorModel.message, baseUrl: nil)
            }
            else
            {
                let readModel : ZLGithubRepositoryReadMeModel = resultModel.data as! ZLGithubRepositoryReadMeModel
                guard let data : Data = Data.init(base64Encoded: readModel.content, options: .ignoreUnknownCharacters) else
                {
                    self.repoFooterInfoView?.loadMarkdown(markDown: "parse error",baseUrl: nil)
                    return
                }
                
                let readMeStr = String.init(data: data, encoding: .utf8)
                self.repoFooterInfoView?.loadMarkdown(markDown: readMeStr ?? "", baseUrl:"")
            }
        })
    }

}
