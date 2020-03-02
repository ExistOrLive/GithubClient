//
//  ZLRepoItemInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/27.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoItemInfoView: ZLBaseView {

    @IBOutlet private weak var codeLabel: UILabel!
    @IBOutlet private weak var pullRequestLabel: UILabel!
    @IBOutlet private weak var branchLabel: UILabel!
    
    
    @IBOutlet weak var codeInfoLabel: UILabel!
    @IBOutlet weak var pullRequestInfoLabel: UILabel!
    @IBOutlet weak var branchInfoLabel: UILabel!
    
    override func awakeFromNib(){
        super.awakeFromNib()
        
        self.codeLabel.text = ZLLocalizedString(string:"code", comment: "代码")
        self.pullRequestLabel.text = ZLLocalizedString(string:"pull request", comment: "合并请求")
        self.branchLabel.text = ZLLocalizedString(string:"branch", comment: "分支")
        
    }

}
