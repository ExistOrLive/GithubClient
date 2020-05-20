//
//  ZLRepoItemInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/27.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc enum ZLRepoItemType : Int
{
    case commit = 1
    case branch = 2
    case language = 3
    case code = 4
    case action = 5
    case pullRequest = 6
}

@objc protocol ZLRepoItemInfoViewDelegate : NSObjectProtocol
{
    func onZLRepoItemInfoViewEvent(type : ZLRepoItemType)
}


class ZLRepoItemInfoView: ZLBaseView {

    weak var delegate : ZLRepoItemInfoViewDelegate?
    
    @IBOutlet private weak var commitLabel: UILabel!
    @IBOutlet private weak var branchLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var pullRequestLabel: UILabel!
    
    
    @IBOutlet weak var commitInfoLabel: UILabel!
    @IBOutlet weak var branchInfoLabel: UILabel!
    @IBOutlet weak var codeInfoLabel: UILabel!
    @IBOutlet weak var pullRequestInfoLabel: UILabel!
    @IBOutlet weak var languageInfoLabel: UILabel!
    @IBOutlet weak var actionInfoLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()

        self.commitLabel.text = ZLLocalizedString(string: "commit", comment: "提交")
        self.codeLabel.text = ZLLocalizedString(string:"code", comment: "代码")
        self.pullRequestLabel.text = ZLLocalizedString(string:"pull request", comment: "合并请求")
        self.branchLabel.text = ZLLocalizedString(string:"branch", comment: "分支")
        self.languageLabel.text = ZLLocalizedString(string: "Language", comment: "语言")
        self.actionLabel.text = ZLLocalizedString(string: "action", comment: "action")
    }
    
    
    @IBAction func onButtonClicked(_ sender: UIButton) {
        
        if self.delegate?.responds(to: #selector(ZLRepoItemInfoViewDelegate.onZLRepoItemInfoViewEvent(type:))) ?? false
        {
            let type = ZLRepoItemType.init(rawValue: sender.tag)
            
            if type != nil
            {
               self.delegate?.onZLRepoItemInfoViewEvent(type: type!)
            }
            
        }
    }
    
}
