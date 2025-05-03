//
//  ZLIssueCommentTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/3/16.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit
import WebKit
import ZMMVVM
import ZLUtilities
import ZLGitRemoteService

protocol ZLDiscussionCommentTableViewCellDelegate: NSObjectProtocol {
    
    var webView: ZLReportHeightWebView { get }
    func getActorAvatarUrl() -> String
    func getActorName() -> String
    func getTime() -> String
    var showReportButton: Bool { get }
    func getCommentHtml() -> String
    func getCommentText() -> String
 
    
    var upvoteNum: Int { get }
    var reactions: [ReactionContent: Int] { get }

    func onAvatarButtonClicked()
    func didClickLink(url: URL)
    func onReportButtonClicked()
}

class ZLDiscussionCommentTableViewCell: UITableViewCell {

    var delegate: ZLDiscussionCommentTableViewCellDelegate? {
        zm_viewModel as? ZLDiscussionCommentTableViewCellDelegate
    }

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
        }
        
        backView.addSubview(upvoteAndReactView)
        upvoteAndReactView.snp.makeConstraints { make in
            make.top.equalTo(webViewContainer.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(40)
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

    private lazy var webViewContainer: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var upvoteAndReactView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(upvoteAndReactStackView)
        upvoteAndReactStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(40)
        }
        return scrollView
    }()
    
    private lazy var upvoteAndReactStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.alignment = .center
        stackView.distribution = .fill
        return stackView
    }()
}

extension ZLDiscussionCommentTableViewCell {
    @objc func onAvatarButtonClicked() {
        self.delegate?.onAvatarButtonClicked()
    }
    
    @objc func onReportButtonClicked() {
        self.delegate?.onReportButtonClicked()
    }
    
}


extension ZLDiscussionCommentTableViewCell: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData data: ZLDiscussionCommentTableViewCellDelegate) {
        avatarButton.loadAvatar(login: data.getActorName(), avatarUrl: data.getActorAvatarUrl())
        actorLabel.text = data.getActorName()
        timeLabel.text = data.getTime()
        reportButton.isHidden = !data.showReportButton
        let subViews = webViewContainer.subviews
        subViews.forEach { $0.removeFromSuperview() }
        webViewContainer.addSubview(data.webView)
        data.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let subView = upvoteAndReactStackView.subviews
        subView.forEach( { $0.removeFromSuperview() })
        
        let upvoteButton = generateButton()
        upvoteButton.image = .iconFontImage(withText: ZLIconFont.ThumbsUP.rawValue, fontSize: 20, color: UIColor.label(withName: "ZLLabelColor2"))
        upvoteButton.title = "\(data.upvoteNum)"
        upvoteAndReactStackView.addArrangedSubview(upvoteButton)
        
        for (content, num) in data.reactions {
            let button = generateButton()
            var emoji = ""
            switch content {
            case .confused:
                emoji = "\u{1F615}"
            case .eyes:
                emoji = "\u{1F440}"
            case .heart:
                emoji = "\u{2764}\u{FE0F}"
            case .hooray:
                emoji = "\u{1F389}"
            case .laugh:
                emoji = "\u{1F604}"
            case .rocket:
                emoji = "\u{1F680}"
            case .thumbsDown:
                emoji = "\u{1F44E}"
            case .thumbsUp:
                emoji = "\u{1F44D}"
            default:
                emoji = ""
            }
            button.image = UIImage.image(with: emoji
                .asMutableAttributedString()
                .font(.zlRegularFont(withSize: 15)),
                                         size: CGSize(width: 20, height: 20))
            button.title = "\(num)"
            upvoteAndReactStackView.addArrangedSubview(button)
        }
    }
    
    func generateButton() -> ZLImageTextButton {
        let button = ZLImageTextButton()
        button.borderColor = .label(withName: "ZLLabelColor2")
        button.borderWidth = 1.0 / UIScreen.main.scale
        button.contentInset = UIEdgeInsets(top: 2, left: 8, bottom: 2, right: 8)
        button.cornerRadius = 6.0
        button.gap = 4.0
        return button
    }
}

