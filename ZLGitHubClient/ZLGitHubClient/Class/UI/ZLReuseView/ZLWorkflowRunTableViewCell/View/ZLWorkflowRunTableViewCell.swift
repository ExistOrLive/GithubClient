//
//  ZLWorkflowRunTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/11.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import YYText
import ZLUtilities

@objc protocol ZLWorkflowRunTableViewCellDelegate: NSObjectProtocol {
    func onMoreButtonClicked(button: UIButton)
}

class ZLWorkflowRunTableViewCell: UITableViewCell {

    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        return view
    }()

    private lazy var workflowRunStatusTag: UILabel = {
        let label = UILabel()
        label.font = UIFont.zlIconFont(withSize: 20)
        return label
    }()

    private lazy var workflowRunTitleLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 15)
        label.textColor = UIColor.label(withName: "ZLLabelColor1")
        label.numberOfLines = 1
        return label
    }()

    private lazy var workflowDescLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.zlRegularFont(withSize: 14)
        label.textColor = UIColor.label(withName: "ZLLabelColor4")
        label.numberOfLines = 4
        return label
    }()

    private lazy var timeLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.zlRegularFont(withSize: 13)
        label.textColor = UIColor.label(withName: "ZLLabelColor3")
        return label
    }()

    private lazy var branchLabel: YYLabel = {
       let label = YYLabel()
        label.numberOfLines = 0
        label.preferredMaxLayoutWidth = ZLScreenWidth - 180
        return label
    }()

    weak var delegate: ZLWorkflowRunTableViewCellDelegate?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        self.backgroundColor = .clear
        self.selectionStyle = .none

        contentView.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }

        containerView.addSubview(workflowRunStatusTag)
        containerView.addSubview(workflowRunTitleLabel)
        containerView.addSubview(workflowDescLabel)
        containerView.addSubview(timeLabel)
        containerView.addSubview(branchLabel)

        workflowRunStatusTag.snp.makeConstraints { make in
            make.left.equalTo(10)
            make.size.equalTo(CGSize(width: 30, height: 30))
        }

        workflowRunTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(15)
            make.left.equalTo(workflowRunStatusTag.snp.right).offset(10)
            make.centerY.equalTo(workflowRunStatusTag)
            make.right.equalTo(-10)
        }

        workflowDescLabel.snp.makeConstraints { make in
            make.left.right.equalTo(workflowRunTitleLabel)
            make.top.equalTo(workflowRunTitleLabel.snp.bottom).offset(15)
        }

        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(workflowRunTitleLabel)
            make.top.equalTo(workflowDescLabel.snp.bottom).offset(15)
        }

        branchLabel.snp.makeConstraints { make in
            make.top.equalTo(timeLabel)
            make.left.equalTo(timeLabel.snp.right).offset(20)
            make.bottom.equalTo(-20)
        }

    }

    func fillWithData(data: ZLWorkflowRunTableViewCellData) {

        self.workflowRunTitleLabel.text = data.getWorkflowRunTitle()
        self.workflowDescLabel.text = data.getWorkflowRunDesc()
        self.timeLabel.text = data.getTimeStr()
        self.branchLabel.attributedText = data.getBranchStr()

        if data.getStatus() == "completed" {
            if data.getConclusion() == "success" {
                workflowRunStatusTag.text = ZLIconFont.GithubRunSuccess.rawValue
                workflowRunStatusTag.textColor = UIColor(named: "ICON_SuccessColor")
            } else if data.getConclusion() == "failure"  || data.getConclusion() == "startup_failure"{
                workflowRunStatusTag.text = ZLIconFont.GithubRunFail.rawValue
                workflowRunStatusTag.textColor = UIColor(named: "ICON_FailColor")
            } else if data.getConclusion() == "cancelled" {
                workflowRunStatusTag.text = ZLIconFont.GithubRunCancel.rawValue
                workflowRunStatusTag.textColor = UIColor(named: "ICON_Common")
            }

        } else if data.getStatus() == "in_progress" {
            workflowRunStatusTag.text = ZLIconFont.GithubRunInProgress.rawValue
            workflowRunStatusTag.textColor = UIColor(named: "ICON_RunColor")
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

}
