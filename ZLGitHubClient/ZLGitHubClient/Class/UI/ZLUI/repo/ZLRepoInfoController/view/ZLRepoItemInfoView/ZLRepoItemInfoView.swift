//
//  ZLRepoItemInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/27.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoItemInfoView: ZLBaseView {

    
    @IBOutlet private weak var commitLabel: UILabel!
    @IBOutlet private weak var branchLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var actionLabel: UILabel!
    @IBOutlet private weak var pullRequestLabel: UILabel!
    @IBOutlet private weak var contributerLabel: UILabel!
    
    
    @IBOutlet weak var commitInfoLabel: UILabel!
    @IBOutlet weak var branchInfoLabel: UILabel!
    @IBOutlet weak var codeInfoLabel: UILabel!
    @IBOutlet weak var pullRequestInfoLabel: UILabel!
    @IBOutlet weak var languageInfoLabel: UILabel!
    @IBOutlet weak var actionInfoLabel: UILabel!
    @IBOutlet weak var contributerInfoLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()

        self.commitLabel.text = ZLLocalizedString(string: "commit", comment: "提交")
        self.codeLabel.text = ZLLocalizedString(string:"code", comment: "代码")
        self.pullRequestLabel.text = ZLLocalizedString(string:"pull request", comment: "合并请求")
        self.branchLabel.text = ZLLocalizedString(string:"branch", comment: "分支")
        self.languageLabel.text = ZLLocalizedString(string: "Language", comment: "语言")
        self.actionLabel.text = ZLLocalizedString(string: "action", comment: "action")
        self.contributerLabel.text = ZLLocalizedString(string: "contributer", comment: "贡献者")
    }

}
