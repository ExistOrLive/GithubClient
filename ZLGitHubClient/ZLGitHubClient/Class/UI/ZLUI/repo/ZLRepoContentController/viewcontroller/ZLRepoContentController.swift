//
//  ZLRepoContentController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoContentController: ZLBaseNavigationController {
    
    let repoFullName : String
    let branch : String
    
    init(repoFullName : String, branch : String)
    {
        self.repoFullName = repoFullName
        self.branch = branch
        
        let subContentController = ZLRepoSubContentController.init(repoFullName: repoFullName,
                                                                   path: "",
                                                                   branch: branch)
        super.init(rootViewController: subContentController)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
