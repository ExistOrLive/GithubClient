//
//  ZLGistTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/2.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZMMVVM

class ZLGistTableViewCellData: ZMBaseTableViewCellViewModel {

    var gistModel: ZLGithubGistModel

    init(data: ZLGithubGistModel) {
        self.gistModel = data
        super.init()
    }

    override var zm_cellReuseIdentifier: String {
        return "ZLGistTableViewCell"
    }

    override func zm_onCellSingleTap() {        
        let vc = ZLGistCodeFileListController()
        vc.gistId = gistModel.id_gist
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ZLGistTableViewCellData: ZLGistTableViewCellDelegate {
   
    func onAvatarButtonClicked() {
        guard let login = gistModel.owner.loginName,
              !login.isEmpty,
              let vc = ZLUIRouter.getUserInfoViewController(loginName: login) else {
                  return
              }
        zm_viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    

    func getOwnerAvatar() -> String {
        return self.gistModel.owner.avatar_url ?? ""
    }

    func getOwnerName() -> String {
        return self.gistModel.owner.loginName ?? ""
    }

    func getFirstFileName() -> String? {
        return self.gistModel.files.first?.key as? String
    }

    func getFileCount() -> Int {
        return self.gistModel.files.count
    }

    func getCommentsCount() -> UInt {
        return self.gistModel.comments
    }

    func getDesc() -> String {
        return self.gistModel.desc_Gist
    }

    func isPub() -> Bool {
        return self.gistModel.isPub
    }

    func getCreate_At() -> Date? {
        return self.gistModel.created_at
    }

    func getUpdate_At() -> Date? {
        return self.gistModel.updated_at
    }

}
