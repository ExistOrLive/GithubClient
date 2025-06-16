//
//  ZLGistFileTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/6/15.
//  Copyright © 2025 ZM. All rights reserved.
//


import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLGistFileTableViewCellData: ZMBaseTableViewCellViewModel {

    var fileModel: ZLGithubGistFileModel

    init(data: ZLGithubGistFileModel) {
        self.fileModel = data
        super.init()
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLGistFileTableViewCell"
    }

    override func zm_onCellSingleTap() {
        
        let vc = ZLGistCodePreviewController()
        vc.fileModel = fileModel
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZLGistFileTableViewCellData: ZLGistFileTableViewCellDelegate {
   
    var fileName: String {
        fileModel.filename
    }
    
    var fileLanguage: String {
        fileModel.language
    }
}
