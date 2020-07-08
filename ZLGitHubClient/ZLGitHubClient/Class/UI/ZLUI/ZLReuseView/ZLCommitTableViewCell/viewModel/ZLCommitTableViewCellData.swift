//
//  ZLCommitTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLCommitTableViewCellData: ZLGithubItemTableViewCellData {
    
    let commitModel : ZLGithubCommitModel
     
     init(commitModel : ZLGithubCommitModel)
     {
         self.commitModel = commitModel
         super.init()
     }
     
     
     override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
         guard let cell : ZLCommitTableViewCell = targetView as? ZLCommitTableViewCell else {
             return
         }
         cell.fillWithData(cellData: self)
         cell.delegate = self
     }
     
     override func getCellHeight() -> CGFloat
     {
         return 110.0
     }
     
     override func getCellReuseIdentifier() -> String
     {
         return "ZLCommitTableViewCell"
     }
    
    override func onCellSingleTap() {
        let vc = ZLWebContentController.init()
        vc.requestURL = URL.init(string: self.commitModel.html_url)
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }

}


extension ZLCommitTableViewCellData
{
    func getCommiterAvaterURL() -> String?
    {
        return self.commitModel.committer.avatar_url
    }
    
    func getCommitTitle() -> String?
    {
        return self.commitModel.commit_message
    }
    
    func getCommitSha() -> String?
    {
        return String(self.commitModel.sha.prefix(7))
    }
    
    
    func getAssistInfo() -> String?
    {
        return "\(self.commitModel.committer.loginName) \(ZLLocalizedString(string: "committed", comment: "提交于")) \((self.commitModel.commit_at as NSDate? ?? NSDate.init()).dateLocalStrSinceCurrentTime() as String) "
    }
    
}

extension ZLCommitTableViewCellData : ZLCommitTableViewCellDelegate{
}
