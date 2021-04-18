//
//  ZLIssueHeaderTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

class ZLIssueHeaderTableViewCellData: ZLGithubItemTableViewCellData {
    
    let data : IssueInfoQuery.Data
    
    init(data : IssueInfoQuery.Data){
        self.data = data
        super.init()
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLIssueHeaderTableViewCell"
    }
    
    override func getCellHeight() -> CGFloat {
        return UITableView.automaticDimension
    }
    
    
    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        super.bindModel(targetModel, andView: targetView)
        if let cell : ZLIssueHeaderTableViewCell = targetView as? ZLIssueHeaderTableViewCell {
            cell.fillWithData(data:self)
        }
    }
}

extension ZLIssueHeaderTableViewCellData : ZLIssueHeaderTableViewCellDelegate {
    
    func getIssueAuthorAvatarURL() -> String {
        return data.repository?.owner.avatarUrl ?? ""
    }
    
    func getIssueRepoFullName() -> NSAttributedString {
        let text = NSMutableAttributedString(string: data.repository?.nameWithOwner ?? "", attributes: [NSAttributedString.Key.foregroundColor:UIColor(cgColor: UIColor(named: "ZLLabelColor1")!.cgColor), NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 14)!])
        
        text.yy_setTextHighlight(NSRange(location: 0, length: data.repository?.nameWithOwner.count ?? 0), color: UIColor(cgColor: UIColor(named: "ZLLabelColor1")!.cgColor), backgroundColor: UIColor(cgColor: UIColor(named: "ZLLabelColor1")!.cgColor)) { [weak self](view, string, range, frame) in
            
            if let fullName = self?.data.repository?.nameWithOwner, let vc = ZLUIRouter.getRepoInfoViewController(repoFullName: fullName){
                self?.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
        return text
    }
    
    func getIssueNumber() -> Int {
        return data.repository?.issue?.number ?? 0
    }

    func getIssueState() -> String {
        return data.repository?.issue?.state.rawValue ?? ""
    }
    
    func getIssueTitle() -> String {
        return data.repository?.issue?.title ?? ""
    }
    
    func onIssueAvatarClicked(){
        if let name = data.repository?.owner.login, let vc = ZLUIRouter.getUserInfoViewController(loginName: name){
            self.viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
