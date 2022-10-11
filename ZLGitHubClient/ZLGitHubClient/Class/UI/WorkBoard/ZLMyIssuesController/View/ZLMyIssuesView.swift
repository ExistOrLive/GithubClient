//
//  ZLMyIssuesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/23.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLGitRemoteService
import ZLBaseUI

protocol ZLMyIssuesViewDelegate: NSObjectProtocol {
    func onFilterTypeChange(type: ZLIssueFilterType)
    func onStateChange(state: ZLGithubIssueState)
}

class ZLMyIssuesView: ZLBaseView {

    private var filterIndex: ZLIssueFilterType = .created
    private var stateIndex: ZLGithubIssueState = .open

    lazy var githubItemListView: ZLGithubItemListView = {
        let itemListView = ZLGithubItemListView()
        itemListView.setTableViewFooter()
        itemListView.setTableViewHeader()
        return itemListView
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = NSMutableAttributedString()
        title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                        attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                     .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
        title.append(NSAttributedString(string: " "))
        title.append(NSAttributedString(string: "Created",
                                        attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                     .font: UIFont.zlMediumFont(withSize: 12)]))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    private lazy var stateButton: UIButton = {
        let button = UIButton(type: .custom)
        let title = NSMutableAttributedString()
        title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                        attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                     .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
        title.append(NSAttributedString(string: " "))
        title.append(NSAttributedString(string: "Open",
                                        attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                     .font: UIFont.zlMediumFont(withSize: 12)]))
        button.setAttributedTitle(title, for: .normal)
        return button
    }()

    weak var delegate: ZLMyIssuesViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setUpUI()
    }

    func setUpUI() {
        self.backgroundColor = UIColor.clear

        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLSubBarColor")
        self.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalTo(self.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(self.safeAreaLayoutGuide.snp.right)
            make.height.equalTo(30)
        }

        view.addSubview(filterButton)
        filterButton.snp.makeConstraints { (make) in
            make.width.equalTo(100)
            make.top.bottom.equalToSuperview()
            make.right.equalToSuperview().offset(-10)
        }
        filterButton.addTarget(self,
                               action: #selector(ZLMyPullRequestsView.onFilterButtonClicked),
                               for: .touchUpInside)

        view.addSubview(stateButton)
        stateButton.snp.makeConstraints { (make) in
            make.width.equalTo(80)
            make.top.bottom.equalToSuperview()
            make.right.equalTo(filterButton.snp_left).offset(-10)
        }
        stateButton.addTarget(self,
                              action: #selector(ZLMyPullRequestsView.onStateButtonClicked),
                              for: .touchUpInside)

        self.addSubview(githubItemListView)
        githubItemListView.snp.makeConstraints { (make) in
            make.right.bottom.left.equalToSuperview()
            make.top.equalTo(view.snp_bottom)
        }
    }

    @objc func onFilterButtonClicked() {
        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""),
                                                            withInitIndex: UInt(self.filterIndex.rawValue),
                                                            withDataArray: ["Created", "Assigned", "Mentioned"]) { (index: UInt) in

            let str = ["Created", "Assigned", "Mentioned"][Int(index)]
            let title = NSMutableAttributedString()
            title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                            attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                         .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
            title.append(NSAttributedString(string: " "))
            title.append(NSAttributedString(string: str,
                                            attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                         .font: UIFont.zlMediumFont(withSize: 12)]))
            self.filterButton.setAttributedTitle(title, for: .normal)

            self.filterIndex = ZLIssueFilterType.init(rawValue: Int(index)) ?? .created
            self.delegate?.onFilterTypeChange(type: self.filterIndex)
        }
    }

    @objc func onStateButtonClicked() {

        CYSinglePickerPopoverView.showCYSinglePickerPopover(withTitle: ZLLocalizedString(string: "Filter", comment: ""),
                                                            withInitIndex: UInt(self.stateIndex.rawValue),
                                                            withDataArray: ["Open", "Closed"]) { (index: UInt) in
            let str = ["Open", "Closed"][Int(index)]
            let title = NSMutableAttributedString()
            title.append(NSAttributedString(string: ZLIconFont.DownArrow.rawValue,
                                            attributes: [.font: UIFont.zlIconFont(withSize: 12),
                                                         .foregroundColor: UIColor.iconColor(withName: "ICON_Common")]))
            title.append(NSAttributedString(string: " "))
            title.append(NSAttributedString(string: str,
                                            attributes: [.foregroundColor: UIColor.label(withName: "ZLLabelColor3"),
                                                         .font: UIFont.zlMediumFont(withSize: 12)]))
            self.stateButton.setAttributedTitle(title, for: .normal)
            self.stateIndex = ZLGithubIssueState.init(rawValue: index) ?? .open
            self.delegate?.onStateChange(state: self.stateIndex)
        }

    }
}
