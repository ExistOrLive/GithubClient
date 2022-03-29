//
//  ZLPullRequestTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import YYText

@objc protocol ZLPullRequestTableViewCellDelegate: NSObjectProtocol {

    func getPullRequestRepoFullName() -> String?

    func getPullRequestTitle() -> String?

    func getPullRequestAssistInfo() -> String?

    func getPullRequestState() -> ZLGithubPullRequestState

    func isPullRequestMerged() -> Bool

    func onClickPullRequestRepoFullName()
    
    func hasLongPressAction() -> Bool

    func longPressAction(view: UIView)
}

class ZLPullRequestTableViewCell: UITableViewCell {

    weak var  delegate: ZLPullRequestTableViewCellDelegate?

    // MARK: Sub View
    lazy var statusTag: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 20)
        return label
    }()

    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()

    private lazy var repoNameTitleLabel: YYLabel = {
       let label = YYLabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ZLKeyWindowWidth - 90
        return label
    }()

//    lazy var repoNameButton: UIButton = {
//        let button = UIButton()
//        button.contentHorizontalAlignment = .leading
//        return button
//    }()

    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 15)
        return label
    }()

    lazy var assistLabel: UILabel = {
        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        return label2
    }()
    
    lazy var longPressGesture: UILongPressGestureRecognizer = {
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
        return gesture
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc func onRepoNameClick() {
        self.delegate?.onClickPullRequestRepoFullName()
    }

    func setUpUI() {

        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear

        self.contentView.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }

        containerView.addSubview(statusTag)
        statusTag.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }

        containerView.addSubview(repoNameTitleLabel)
        repoNameTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(statusTag.snp.right).offset(10)
            make.centerY.equalTo(statusTag)
            make.right.equalToSuperview().offset(-15)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(repoNameTitleLabel)
            make.top.equalTo(repoNameTitleLabel.snp.bottom).offset(10)
        }

        containerView.addSubview(assistLabel)
        assistLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(repoNameTitleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        containerView.addGestureRecognizer(longPressGesture)
    }

    func fillWithData(data: ZLPullRequestTableViewCellDelegate) {

        self.delegate = data
        
        longPressGesture.isEnabled = data.hasLongPressAction()

        self.titleLabel.text = data.getPullRequestTitle()
        self.assistLabel.text = data.getPullRequestAssistInfo()

        let title = NSMutableAttributedString(string: data.getPullRequestRepoFullName() ?? "",
                                       attributes: [.foregroundColor: ZLRawLabelColor(name: "ZLLabelColor1"),
                                                    .font: UIFont.zlMediumFont(withSize: 15)])
        title.yy_setTextHighlight(NSRange(location: 0, length: title.length),
                                  color: nil,
                                  backgroundColor: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor)) { [weak self] _, _, _, _ in
            self?.onRepoNameClick()
        }
        self.repoNameTitleLabel.attributedText = title

        self.statusTag.text = ZLIconFont.PR.rawValue
        if data.getPullRequestState() == .open {
            self.statusTag.textColor = UIColor(named: "ICON_PROpenedColor")
        } else if data.isPullRequestMerged() {
            self.statusTag.textColor = UIColor(named: "ICON_PRMergedColor")
        } else {
            self.statusTag.textColor = UIColor(named: "ICON_PRCloseColor")
        }

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
    
    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        delegate?.longPressAction(view: self)
    }

}
