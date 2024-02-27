//
//  ZLRepositoryTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/30.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import ZLUIUtilities
import ZLUtilities

protocol ZLRepositoryTableViewCellDelegate: NSObjectProtocol {

    func onRepoAvaterClicked()

    func getOwnerAvatarURL() -> String?

    func getRepoFullName() -> String?

    func getRepoName() -> String?

    func getOwnerName() -> String?

    func getRepoMainLanguage() -> String?

    func getRepoDesc() -> String?

    func isPriva() -> Bool

    func starNum() -> Int

    func forkNum() -> Int

    func hasLongPressAction() -> Bool

    func longPressAction(view: UIView)
}

extension ZLRepositoryTableViewCellDelegate {

    func onRepoAvaterClicked() {}

    func getOwnerAvatarURL() -> String? { nil }

    func getRepoFullName() -> String? { nil }

    func getRepoName() -> String? { nil }

    func getOwnerName() -> String? { nil }

    func getRepoMainLanguage() -> String? { nil }

    func getRepoDesc() -> String? { nil }

    func isPriva() -> Bool { false }

    func starNum() -> Int { 0 }

    func forkNum() -> Int { 0 }

    func hasLongPressAction() -> Bool { false }

    func longPressAction(view: UIView) { }

}

class ZLRepositoryTableViewCell: UITableViewCell {

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()

    lazy var avatarButton: UIButton = {
        let button = UIButton(type: .custom)
        button.cornerRadius = 25
        button.clipsToBounds = true
        return button
    }()

    lazy  var repostitoryNameLabel: UILabel = {
        let label = UILabel()
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.zlSemiBoldFont(withSize: 17)
        label.textColor = UIColor(named: "ZLLabelColor1")
        return label
    }()

    lazy  var languageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlMediumFont(withSize: 14)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5
        label.font = UIFont.zlRegularFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var starLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.RepoStar.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var forkLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.RepoFork.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var privateLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.RepoPrivate.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var starNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var forkNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()

    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()

    weak var delegate: ZLRepositoryTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {

        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make  in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }

        containerView.addSubview(avatarButton)
        containerView.addSubview(repostitoryNameLabel)
        containerView.addSubview(ownerNameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(languageLabel)

        avatarButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        avatarButton.addTarget(self, action: #selector(onAvatarSingleTapAction), for: .touchUpInside)

        repostitoryNameLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarButton)
            make.left.equalTo(avatarButton.snp.right).offset(15)
            make.right.equalToSuperview().offset(-20)
        }

        ownerNameLabel.snp.makeConstraints { make in
            make.top.equalTo(repostitoryNameLabel.snp.bottom).offset(10)
            make.left.equalTo(repostitoryNameLabel)
        }

        languageLabel.snp.makeConstraints { make in
            make.top.equalTo(repostitoryNameLabel.snp.bottom).offset(10)
            make.left.equalTo(ownerNameLabel.snp.right).offset(20)
        }

        descriptionLabel.snp.makeConstraints { make in
            make.left.equalTo(repostitoryNameLabel)
            make.top.equalTo(ownerNameLabel.snp.bottom).offset(20)
            make.right.equalToSuperview().offset(-20)
        }

        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.clear
        containerView.addSubview(bottomView)
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(20)
            make.left.equalTo(repostitoryNameLabel)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(20)
        }

        bottomView.addSubview(privateLabel)
        bottomView.addSubview(starLabel)
        bottomView.addSubview(starNumLabel)
        bottomView.addSubview(forkLabel)
        bottomView.addSubview(forkNumLabel)

        forkNumLabel.snp.makeConstraints { make in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }

        forkLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.right.equalTo(forkNumLabel.snp.left).offset(-3)
        }

        starNumLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
            make.right.equalTo(forkLabel.snp.left).offset(-20)
        }

        starLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.right.equalTo(starNumLabel.snp.left).offset(-3)
        }

        privateLabel.snp.makeConstraints { make in
            make.right.equalTo(starLabel.snp.left).offset(-20)
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
        }

        containerView.addGestureRecognizer(longPressGesture)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.containerView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }

}

extension ZLRepositoryTableViewCell: ZLViewUpdatableWithViewData {
    
    func justUpdateView() {
        
    }
    
    func fillWithViewData(viewData data: ZLRepositoryTableViewCellDelegate)  {
        delegate = data
        avatarButton.loadAvatar(login: data.getOwnerName() ?? "",
                                avatarUrl: data.getOwnerAvatarURL() ?? "")
        repostitoryNameLabel.text = data.getRepoName()
        languageLabel.text = data.getRepoMainLanguage()
        descriptionLabel.text = data.getRepoDesc()
        forkNumLabel.text = data.forkNum() < 1000 ? "\(data.forkNum())" : String(format: "%.1f", Double(data.forkNum())/1000.0) + "k"
        starNumLabel.text = data.starNum() < 1000 ? "\(data.starNum())" : String(format: "%.1f", Double(data.starNum())/1000.0) + "k"
        ownerNameLabel.text = data.getOwnerName()
        privateLabel.isHidden = !data.isPriva()

        longPressGesture.isEnabled = data.hasLongPressAction()
    }
}

extension ZLRepositoryTableViewCell {
    @objc func onAvatarSingleTapAction() {
        delegate?.onRepoAvaterClicked()
    }

    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        delegate?.longPressAction(view: self)
    }
}
