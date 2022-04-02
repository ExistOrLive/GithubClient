//
//  ZLGistTableViewCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/2.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLGistTableViewCellData: ZLGithubItemTableViewCellData {

    var gistModel: ZLGithubGistModel

    init(data: ZLGithubGistModel) {
        self.gistModel = data
        super.init()
    }

    override func getCellReuseIdentifier() -> String {
        return "ZLGistTableViewCell"
    }

    override func getCellHeight() -> CGFloat {
        return 180
    }

    override func onCellSingleTap() {
        if let url = URL(string: self.gistModel.html_url) {
            ZLUIRouter.navigateVC(key: ZLUIRouter.WebContentController,
                                  params: ["requestURL": url])
        }
    }

    override func bindModel(_ targetModel: Any?, andView targetView: UIView) {
        guard let cell: ZLGistTableViewCell = targetView as? ZLGistTableViewCell else {
            return
        }
        cell.fillWithData(cellData: self)
        cell.delegate = self
    }

}

extension ZLGistTableViewCellData {

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

extension ZLGistTableViewCellData: ZLGistTableViewCellDelegate {

}
