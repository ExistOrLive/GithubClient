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
import ZLBaseExtension

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
            make.right.equalTo(filterButton.snp.left).offset(-10)
        }
        stateButton.addTarget(self,
                              action: #selector(ZLMyPullRequestsView.onStateButtonClicked),
                              for: .touchUpInside)

        self.addSubview(githubItemListView)
        githubItemListView.snp.makeConstraints { (make) in
            make.right.bottom.left.equalToSuperview()
            make.top.equalTo(view.snp.bottom)
        }
    }

    @objc func onFilterButtonClicked() {
        
        guard let view = viewController?.view else { return }
        let titles = ["Created", "Assigned", "Mentioned"]
        var selectedTitle = "Created"
        if self.stateIndex.rawValue < titles.count {
            selectedTitle = titles[Int(self.filterIndex.rawValue)]
        }
        ZMSingleSelectTitlePopView
            .showCenterSingleSelectTickBox(to: view,
                                           title:  ZLLocalizedString(string: "Filter",
                                                                     comment: ""),
                                           selectableTitles: titles,
                                           selectedTitle: selectedTitle)
        { [weak self] (index, result) in
            guard let self =  self else { return }
            
            let str = titles[index]
            let title = NSASCContainer(
                ZLIconFont.DownArrow.rawValue
                    .asMutableAttributedString()
                    .font(.zlIconFont(withSize: 12))
                    .foregroundColor(.iconColor(withName: "ICON_Common")),
                
                " ",
                
                str
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 12))
                    .foregroundColor(.label(withName: "ZLLabelColor3"))
            )
                .asAttributedString()
            
            self.filterButton.setAttributedTitle(title, for: .normal)
            
            self.filterIndex = ZLIssueFilterType.init(rawValue: NSInteger(index)) ?? .created
            self.delegate?.onFilterTypeChange(type: self.filterIndex)
        }
        
    }

    @objc func onStateButtonClicked() {
        guard let view = viewController?.view else { return }
        let titles = ["Open", "Closed"]
        var selectedTitle = "Open"
        if self.stateIndex.rawValue < titles.count {
            selectedTitle = titles[Int(self.stateIndex.rawValue)]
        }
        ZMSingleSelectTitlePopView
            .showCenterSingleSelectTickBox(to: view,
                                           title:  ZLLocalizedString(string: "Filter",
                                                                     comment: ""),
                                           selectableTitles: titles,
                                           selectedTitle: selectedTitle)
        { [weak self] (index, result) in
            guard let self =  self else { return }
            
            let str = titles[index]
            let title = NSASCContainer(
                ZLIconFont.DownArrow.rawValue
                    .asMutableAttributedString()
                    .font(.zlIconFont(withSize: 12))
                    .foregroundColor(.iconColor(withName: "ICON_Common")),
                
                " ",
                
                str
                    .asMutableAttributedString()
                    .font(.zlMediumFont(withSize: 12))
                    .foregroundColor(.label(withName: "ZLLabelColor3"))
            )
                .asAttributedString()
            
            self.stateButton.setAttributedTitle(title, for: .normal)
            self.stateIndex = ZLGithubIssueState.init(rawValue: UInt(index)) ?? .open
            self.delegate?.onStateChange(state: self.stateIndex)
        }
    }
}
