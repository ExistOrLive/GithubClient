//
//  ZLAboutContentView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/5.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLAboutContentView: ZLBaseView {

    @IBOutlet weak var versionLabel: UILabel!
    
    @IBOutlet weak var contributorsLabel: UILabel!
    
    @IBOutlet weak var repoLabel: UILabel!
    
    override func awakeFromNib() {
        self.contributorsLabel.text = ZLLocalizedString(string: "contributors", comment: "贡献者")
        self.repoLabel.text = ZLLocalizedString(string: "repository", comment: "版本库")
    }
    
    
}
