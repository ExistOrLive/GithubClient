//
//  ZLRepoIssuesView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/7/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import ZLUtilities
import ZLUIUtilities

protocol ZLRepoIssuesViewDelegate: ZLGithubItemListViewDelegate {
    // delagate
    func onFilterTypeChange(_ open: Bool)
}

class ZLRepoIssuesView: UIView {

    private weak var delegate: ZLRepoIssuesViewDelegate?

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
         label.text = "open"
         return label
     }()

     lazy var githubItemListView: ZLGithubItemListView = {
        let view = ZLGithubItemListView()
         view.setTableViewHeader()
         view.setTableViewFooter()
         return view
     }()

     private var filterOpen: Bool = true

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

     func fillWithViewModel(viewModel: ZLRepoIssuesViewDelegate) {
         self.delegate = viewModel
         self.githubItemListView.delegate = viewModel
     }

     @objc private func onFilterButtonClicked() {
         
         guard let view = viewController?.view else { return }
         ZMSingleSelectTitlePopView
             .showCenterSingleSelectTickBox(to: view,
                                            title: ZLLocalizedString(string: "Filter",
                                                                     comment: ""),
                                            selectableTitles: ["open", "closed"],
                                            selectedTitle: self.filterOpen ? "open" : "closed")
         { [weak self](index, result) in
             self?.filterLabel.text = index == 0 ? "open" : "closed"
             self?.filterOpen = index == 0
             self?.delegate?.onFilterTypeChange(index == 0)
         }
     }

}
