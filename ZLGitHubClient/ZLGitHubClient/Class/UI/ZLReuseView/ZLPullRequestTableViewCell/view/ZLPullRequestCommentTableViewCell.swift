//
//  ZLPullRequestCommentTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/26.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZMMVVM
import ZLUtilities

protocol ZLPullRequestCommentTableViewCellDelegate: NSObjectProtocol {
    
    var webView: ZLReportHeightWebView { get }
    func getActorAvatarUrl() -> String
    func getActorName() -> String
    func getTime() -> String
    func getCommentHtml() -> String
    func getCommentText() -> String
    var showReportButton: Bool { get }

    func onAvatarButtonClicked()
    func didClickLink(url: URL)
    func onReportButtonClicked()
}

class ZLPullRequestCommentTableViewCell: UITableViewCell {

    var delegate: ZLPullRequestCommentTableViewCellDelegate? {
        zm_viewModel as? ZLPullRequestCommentTableViewCellDelegate
    }

    private var cacheHtml: String?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setUpUI() {

        self.selectionStyle = .none

        self.contentView.backgroundColor = UIColor.clear
        self.backgroundColor = UIColor.clear

        self.contentView.addSubview(backView)

        backView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0))
        }

        backView.addSubview(avatarButton)
        avatarButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(20)
            make.left.equalToSuperview().offset(15)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }

        backView.addSubview(actorLabel)
        actorLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.top.equalTo(avatarButton)
        }

        backView.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(avatarButton.snp.right).offset(10)
            make.bottom.equalTo(avatarButton)
        }
        
        backView.addSubview(reportButton)
        reportButton.snp.makeConstraints { make in
            make.centerY.equalTo(avatarButton)
            make.right.equalTo(-15)
            make.width.equalTo(45)
            make.height.equalTo(30)
        }

        backView.addSubview(webViewContainer)
        webViewContainer.snp.makeConstraints { make in
            make.top.equalTo(avatarButton.snp.bottom).offset(20)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
        }

        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSeperatorLineColor")
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.bottom.equalTo(backView.snp.top)
            make.left.equalToSuperview().offset(40)
            make.width.equalTo(1)
        }
    }

    // MARK: View

    private lazy var backView: UIView = {
        let backView = UIView()
        backView.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        return backView
    }()

    private lazy var avatarButton: UIButton = {
        let tmpAvatarButton = UIButton(type: .custom)
        tmpAvatarButton.cornerRadius = 20
        tmpAvatarButton.addTarget(self, action: #selector(onAvatarButtonClicked), for: .touchUpInside)
        return tmpAvatarButton
    }()

    private lazy var actorLabel: UILabel = {
        let label1 = UILabel()
        label1.textColor = UIColor(named: "ZLLabelColor1")
        label1.font = UIFont(name: Font_PingFangSCMedium, size: 15)
        return label1
    }()

    private lazy var timeLabel: UILabel = {
        let label2 = UILabel()
        label2.textColor = UIColor(named: "ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        return label2
    }()
    
    
    private lazy var reportButton: UIButton = {
        let button = UIButton.init(type: .custom)
        button.addTarget(self, action: #selector(onReportButtonClicked), for: .touchUpInside)
        let str = NSAttributedString(string: ZLIconFont.More.rawValue, attributes: [.font: UIFont.zlIconFont(withSize: 30),
                                                                                    .foregroundColor: UIColor.label(withName: "ICON_Common")])
        button.setAttributedTitle(str, for: .normal)
        return button
    }()

    lazy var webViewContainer: UIView = {
        let view = UIView()
        return view
    }()

}

extension ZLPullRequestCommentTableViewCell {
    @objc func onAvatarButtonClicked() {
        self.delegate?.onAvatarButtonClicked()
    }
    
    @objc func onReportButtonClicked() {
        self.delegate?.onReportButtonClicked()
    }
}


extension ZLPullRequestCommentTableViewCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData data: ZLPullRequestCommentTableViewCellDelegate) {
        avatarButton.loadAvatar(login: data.getActorName(),
                                avatarUrl: data.getActorAvatarUrl())
        actorLabel.text = data.getActorName()
        timeLabel.text = data.getTime()
        reportButton.isHidden = !data.showReportButton
        let subViews = webViewContainer.subviews
        subViews.forEach { $0.removeFromSuperview() }
        webViewContainer.addSubview(data.webView)
        data.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
