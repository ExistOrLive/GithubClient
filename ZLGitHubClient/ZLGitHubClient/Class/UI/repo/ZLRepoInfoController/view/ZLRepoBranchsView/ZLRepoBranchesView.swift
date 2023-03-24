//
//  ZLRepoBranchesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/18.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension
import ZLGitRemoteService

class ZLRepoBranchesView: NSObject {

    static func showRepoBranchedView(repoFullName: String,
                                     currentBranch: String,
                                     handle: ((String) -> Void)?) {
        ZLProgressHUD.show()
        
        ZLRepoServiceShared()?
            .getRepositoryBranchesInfo(withFullName: repoFullName,
                                       serialNumber: NSString.generateSerialNumber(),
                                       completeHandle: { (model: ZLOperationResultModel) in

            ZLProgressHUD.dismiss()

            if model.result == false {
                guard let errorModel: ZLGithubRequestErrorModel = model.data as?  ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage("query branches status[\(errorModel.statusCode)] message[\(errorModel.message)]")
                return
            }

            guard let branches: [ZLGithubRepositoryBranchModel] = model.data as? [ZLGithubRepositoryBranchModel] else {
                return
            }

            ZLRepoBranchesView.showWith(currentBranch: currentBranch,
                                        branches: branches,
                                        handle: handle)
        })
    }

    static func showWith(currentBranch: String,
                         branches: [ZLGithubRepositoryBranchModel],
                         handle: ((String) -> Void)?) {
        
        guard let view = ZLMainWindow else { return }
        
        let branchTitles = branches.map { $0.name }
        
        ZMSingleSelectTitlePopView.showCenterSingleSelectTickBox(to: view,
                                                                 title: ZLLocalizedString(string: "branch", comment: "分支"),
                                                                 selectableTitles: branchTitles,
                                                                 selectedTitle: currentBranch,
                                                                 contentMaxHeight: 320)
        { index, result in
            handle?(result)
        }
    }
}

