//
//  ZLReleaseInfoDescriptionCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/5/11.
//  Copyright © 2025 ZM. All rights reserved.
//

import UIKit
import YYText
import SnapKit
import ZLUIUtilities
import ZLBaseExtension
import ZLUtilities
import ZMMVVM
import ZLGitRemoteService

protocol ZLReleaseInfoDescriptionCellDelegate: NSObjectProtocol {
    
    var webView: ZLReportHeightWebView { get }
    
    var reactions: [ReactionContent: Int] { get }
}

class ZLReleaseInfoDescriptionCell: UITableViewCell {
    
    var delegate: ZLReleaseInfoDescriptionCellDelegate? {
        zm_viewModel as? ZLReleaseInfoDescriptionCellDelegate
    }
    
    func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear 
        contentView.backgroundColor = .clear
        contentView.addSubview(backView)
        backView.addSubview(webViewContainer)
        backView.addSubview(upvoteAndReactView)
        
        backView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(10)
        }
        
        webViewContainer.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        upvoteAndReactView.snp.makeConstraints { make in
            make.top.equalTo(webViewContainer.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.bottom.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
    }
    
    // MARK: View
    private lazy var backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLIssueCommentCellColor")
        return view
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
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupUI()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
}



extension ZLReleaseInfoDescriptionCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLReleaseInfoDescriptionCellDelegate) {
  
        let subViews = webViewContainer.subviews
        subViews.forEach { $0.removeFromSuperview() }
        webViewContainer.addSubview(viewData.webView)
        viewData.webView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        let subView = upvoteAndReactStackView.subviews
        subView.forEach( { $0.removeFromSuperview() })
            
        for (content, num) in viewData.reactions {
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



