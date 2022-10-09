//
//  ZLWorkboardTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

enum ZLWorkboardType {
    case issues
    case pullRequest
    case repos
    case orgs
    case starRepos
    case events
    case discussions
    case fixRepo
}

@objc protocol ZLWorkboardTableViewCellDelegate: NSObjectProtocol {

    func onCellClicked()

    var title: String { get }

    var avatarURL: String { get }

    var isGithubItem: Bool { get }

}

class ZLWorkboardTableViewCell: UITableViewCell {

    lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLCellBack")
        return view
    }()

    lazy var avatarImageView: UIImageView = {
       let imageView = UIImageView()
       imageView.circle = true
       return imageView
    }()

    lazy var titleLabel: UILabel = {
       let label = UILabel()
        label.font = .zlSemiBoldFont(withSize: 14)
        label.textColor = .label(withName: "ZLLabelColor1")
        label.textAlignment = .left
        return label
    }()

    lazy var singleLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .back(withName: "ZLSeperatorLineColor")
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear

        contentView.addSubview(backView)
        backView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15))
        }

        backView.addSubview(avatarImageView)
        avatarImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.centerY.equalToSuperview()
            make.size.equalTo(CGSize(width: 40, height: 40))
        }

        backView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarImageView.snp.right).offset(15)
            make.centerY.equalToSuperview()
        }

        backView.addSubview(singleLineView)
        singleLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.bottom.right.equalToSuperview()
            make.height.equalTo( 1.0 / UIScreen.main.scale )
        }

        let nextTag = UILabel()
        nextTag.font = UIFont.zlIconFont(withSize: 15)
        nextTag.textColor = UIColor(named: "ICON_Common")
        nextTag.text = ZLIconFont.NextArrow.rawValue
        backView.addSubview(nextTag)
        nextTag.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
            make.size.equalTo(CGSize(width: 15, height: 15))
            make.left.equalTo(titleLabel.snp.right).offset(10)
        }
    }

    func fillWithData(cellData: ZLWorkboardTableViewCellDelegate) {

        if cellData.isGithubItem {
            self.avatarImageView.sd_setImage(with: URL.init(string: cellData.avatarURL), placeholderImage: UIImage(named: "default_avatar"))
        } else {
            self.avatarImageView.image = UIImage(named: cellData.avatarURL)
        }
        self.titleLabel.text = cellData.title
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.backView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.backView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.backView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

}
