//
//  ZLProfileHeaderView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/15.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

enum ZLProfileHeaderViewButtonType: Int {
    case repositories = 0
    case gists
    case followers
    case following
    case editProfile
    case allUpdate
}

@objc protocol ZLProfileHeaderViewDelegate: NSObjectProtocol {
    func onProfileHeaderViewButtonClicked(button: UIButton)
}

class ZLProfileHeaderView: ZLBaseView {

    weak var delegate: ZLProfileHeaderViewDelegate?

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var createTimeLabel: UILabel!
    @IBOutlet weak var EditProfileButton: UIButton!

    @IBOutlet weak var repositoryNum: UILabel!
    @IBOutlet weak var gistNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var latestModifiedView: UIView!

    @IBOutlet weak var repositoriesButton: UIButton!
    @IBOutlet weak var gistsButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var latestUpdateLabel: UILabel!
    @IBOutlet weak var allUpdateButton: UIButton!

    @IBOutlet weak var contributionView: ZLUserContributionsView!

    override func awakeFromNib() {

        super.awakeFromNib()
        self.headImageView.layer.cornerRadius = 30.0
        self.latestModifiedView.layer.cornerRadius = 10.0

        self.EditProfileButton.setTitle(ZLIconFont.Edit.rawValue, for: .normal)
        self.EditProfileButton.setTitleColor(UIColor.white, for: .normal)
        self.EditProfileButton.titleLabel?.font = UIFont.zlIconFont(withSize: 25)

        self.allUpdateButton.titleLabel?.font = UIFont.zlIconFont(withSize: 11)

        self.justReloadView()
    }

    @IBAction func onProfileHeaderViewButtonClicked(_ sender: Any) {

        if self.delegate?.responds(to: #selector(ZLProfileHeaderViewDelegate.onProfileHeaderViewButtonClicked(button:))) ?? false,
           let button = sender as? UIButton {
            self.delegate?.onProfileHeaderViewButtonClicked(button: button)
        }
    }

    func justReloadView() {

        self.repositoriesButton.setTitle(ZLLocalizedString(string: "repositories", comment: "仓库"), for: UIControl.State.normal)
        self.gistsButton.setTitle(ZLLocalizedString(string: "gists", comment: "代码片段"), for: UIControl.State.normal)
        self.followersButton.setTitle(ZLLocalizedString(string: "followers", comment: "粉丝"), for: UIControl.State.normal)
        self.followingButton.setTitle(ZLLocalizedString(string: "following", comment: "关注"), for: UIControl.State.normal)

        self.latestUpdateLabel.text = ZLLocalizedString(string: "lastest update", comment: "最近修改")
        self.allUpdateButton.setTitle("\(ZLLocalizedString(string: "all update", comment: "查看全部修改")) \(ZLIconFont.NextArrow.rawValue)", for: .normal)
    }
}
