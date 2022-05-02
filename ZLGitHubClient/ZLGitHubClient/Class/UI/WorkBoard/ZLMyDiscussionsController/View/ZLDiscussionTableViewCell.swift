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

protocol ZLDiscussionTableViewCellDataSourceAndDelegate: NSObjectProtocol {
    
    var repositoryFullName: String { get }
    
    var title: String { get }
    
    var createTime: String { get }
    
    var upvoteNumber: Int { get }
    
    var commentNumber: Int { get }
    
    func onClickRepoFullName()
    
    func hasLongPressAction() -> Bool

    func longPressAction(view: UIView)
    
}


class ZLDiscussionTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupUI() {
        selectionStyle = .none
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        contentView.addSubview(containerView)
        containerView.addSubview(iconTag)
        containerView.addSubview(repoNameTitleLabel)
        containerView.addSubview(titleLabel)
        containerView.addSubview(createTimeLabel)
        
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        
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
        
        createTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(repoNameTitleLabel)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    // MARK: View
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()
    
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
    
    private lazy var createTimeLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(named: "ZLLabelColor2")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        return label
    }()
    
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

extension ZLDiscussionTableViewCell: ViewUpdatable {
    
    func fillWithData(viewData: ZLDiscussionTableViewCellDataSourceAndDelegate) {
        repoNameTitleLabel.text = viewData.repositoryFullName
        titleLabel.text = viewData.title
        createTimeLabel.text = viewData.createTime
    }
}
