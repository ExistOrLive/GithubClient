//
//  ZLDiscussionTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/2.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import YYText
import SnapKit
import ZLUIUtilities
import ZLBaseExtension
import ZLUtilities
import ZMMVVM

protocol ZLDiscussionTableViewCellDataSourceAndDelegate: AnyObject {
    
    var repositoryFullName: String { get }
    
    var title: String { get }
        
    var updateOrCreateTime: String { get }
    
    var upvoteNumber: Int { get }
    
    var commentNumber: Int { get }
    
    func onClickRepoFullName()
    
    func hasLongPressAction() -> Bool

    func longPressAction(view: UIView)
    
}


class ZLDiscussionTableViewCell: ZLBaseCardTableViewCell {
    
    var delegate: ZLDiscussionTableViewCellDataSourceAndDelegate? {
        zm_viewModel as? ZLDiscussionTableViewCellDataSourceAndDelegate
    }
    
    @objc func onRepoNameClick() {
        self.delegate?.onClickRepoFullName()
    }
    
    override func setupUI() {
        super.setupUI()
        
        containerView.addSubview(iconTag)
        containerView.addSubview(repoNameTitleLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(bottomView)
        containerView.addGestureRecognizer(longPressGesture)
        
        bottomView.addSubview(thumbsUpLabel)
        bottomView.addSubview(thumbsUpNumLabel)
        bottomView.addSubview(commentLabel)
        bottomView.addSubview(commentNumLabel)
        bottomView.addSubview(timeLabel)
        
        iconTag.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 25, height: 25))
        }
        
        repoNameTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(10)
            make.left.equalTo(iconTag.snp.right).offset(10)
            make.centerY.equalTo(iconTag)
            make.right.equalToSuperview().offset(-15)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.equalTo(repoNameTitleLabel)
            make.top.equalTo(repoNameTitleLabel.snp.bottom).offset(10)
        }
        
        
        bottomView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.left.equalTo(repoNameTitleLabel)
            make.bottom.equalToSuperview().offset(-10)
            make.right.equalToSuperview().offset(-20)
        }
        
        thumbsUpLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        
        thumbsUpNumLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
            make.left.equalTo(thumbsUpLabel.snp.left).offset(30)
        }
        
        commentLabel.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 20, height: 20))
            make.centerY.equalToSuperview()
            make.left.equalTo(thumbsUpNumLabel.snp.left).offset(50)
        }
        
        commentNumLabel.snp.makeConstraints { make in
            make.left.equalTo(commentLabel.snp.left).offset(30)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        timeLabel.snp.makeConstraints { (make) in
            make.top.bottom.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
    }
    
    // MARK: View
    private lazy var iconTag: UILabel = {
        let label = UILabel()
        label.font = .zlIconFont(withSize: 20)
        label.text = ZLIconFont.Discussion.rawValue 
        return label
    }()
    
    private lazy var repoNameTitleLabel: YYLabel = {
       let label = YYLabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ZLKeyWindowWidth - 90
        return label
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 4
        label.textColor = UIColor(named: "ZLLabelColor3")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 15)
        return label
    }()
    
    private lazy var bottomView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        return label
    }()
    
    lazy var thumbsUpLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.ThumbsUP.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
    
    lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = ZLIconFont.Comment.rawValue
        label.font = UIFont.zlIconFont(withSize: 15)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
    
    lazy var thumbsUpNumLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.zlMediumFont(withSize: 12)
        label.textColor = UIColor(named: "ZLLabelColor2")
        return label
    }()
    
    lazy var commentNumLabel: UILabel = {
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
    
}

extension ZLDiscussionTableViewCell: ZMBaseViewUpdatableWithViewData {
    
    func zm_fillWithViewData(viewData: ZLDiscussionTableViewCellDataSourceAndDelegate) {
        
        let title = NSMutableAttributedString(string: viewData.repositoryFullName ,
                                              attributes: [.foregroundColor:ZLRawLabelColor(name: "ZLLabelColor1"),
                                                           .font: UIFont.zlMediumFont(withSize: 15)])
        title.yy_setTextHighlight(NSRange(location: 0, length: title.length),
                                  color: nil,
                                  backgroundColor: UIColor(cgColor: UIColor.linkColor(withName: "ZLLinkLabelColor1").cgColor)) { [weak self]_, _, _, _ in
            self?.onRepoNameClick()
        }
        
        repoNameTitleLabel.attributedText = title
        titleLabel.text = viewData.title
        timeLabel.text = viewData.updateOrCreateTime
        
        thumbsUpNumLabel.text = viewData.upvoteNumber < 1000 ? "\(viewData.upvoteNumber)" : String(format: "%.1f", Double(viewData.upvoteNumber)/1000.0) + "k"
        commentNumLabel.text = viewData.commentNumber < 1000 ? "\(viewData.commentNumber)" : String(format: "%.1f", Double(viewData.commentNumber)/1000.0) + "k"
        
        longPressGesture.isEnabled = viewData.hasLongPressAction()
    }
}

extension ZLDiscussionTableViewCell {

    @objc func longPressAction(gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else { return }
        delegate?.longPressAction(view: self)
    }
}
