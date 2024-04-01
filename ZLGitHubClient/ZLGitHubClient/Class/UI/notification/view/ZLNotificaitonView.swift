//
//  ZLNotificaitonView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/7.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUtilities
import ZLUIUtilities

protocol ZLNotificationViewDataSourceAndDelagate: ZLGithubItemListViewDelegate {
    // delagate
    func onFilterTypeChange(_ showAllNotification: Bool)

    // datasource
    var showAllNotification: Bool {get}
}

class ZLNotificationView: ZLBaseView {

   private weak var delegate: ZLNotificationViewDataSourceAndDelagate?

    private lazy var filterBackView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.back(withName: "ZLSubBarColor")
        return view
    }()

    private lazy var filterButton: UIButton = {
        let button = UIButton(type: .custom)
        button.setTitle(ZLIconFont.Filter.rawValue, for: .normal)
        button.setTitleColor(UIColor.label(withName: "ICON_Common"), for: .normal)
        button.titleLabel?.font = UIFont.zlIconFont(withSize: 18)
        return button
    }()

    private lazy var filterLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.zlSemiBoldFont(withSize: 14)
        label.textColor = UIColor.label(withName: "ZLLabelColor3")
        label.text = "unread"
        return label
    }()

    lazy var githubItemListView: ZLGithubItemListView = {
       let view = ZLGithubItemListView()
        view.setTableViewHeader()
        view.setTableViewFooter()
        return view
    }()

    private var showAllNotification: Bool = false

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.addSubview(filterBackView)
        filterBackView.addSubview(filterLabel)
        filterBackView.addSubview(filterButton)

        self.addSubview(githubItemListView)

        filterBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        filterLabel.snp.makeConstraints { make in
            make.left.equalTo(30)
            make.centerY.equalToSuperview()
        }
        filterButton.snp.makeConstraints { make in
            make.top.bottom.right.equalToSuperview()
            make.width.equalTo(50)
        }

        githubItemListView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(filterBackView.snp.bottom)
        }

        filterButton.addTarget(self, action: #selector(onFilterButtonClicked), for: .touchUpInside)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func fillWithViewModel(viewModel: ZLNotificationViewDataSourceAndDelagate) {
        self.delegate = viewModel
        self.githubItemListView.delegate = viewModel

        self.showAllNotification  = viewModel.showAllNotification
        self.filterLabel.text = viewModel.showAllNotification ? "all" : "unread"
    }

    @objc private func onFilterButtonClicked() {
        
        guard let view = ZLMainWindow else { return }
        ZMSingleSelectTitlePopView
            .showCenterSingleSelectTickBox(to: view,
                                           title: ZLLocalizedString(string: "Filter",
                                                                    comment: ""),
                                           selectableTitles: ["all", "unread"],
                                           selectedTitle: showAllNotification ? "all" : "unread")
        { [weak self](index, result) in
            
            self?.showAllNotification = index == 0
            self?.filterLabel.text = index == 0 ? "all" : "unread"
            
            self?.delegate?.onFilterTypeChange(index == 0)
        }
    }
}
