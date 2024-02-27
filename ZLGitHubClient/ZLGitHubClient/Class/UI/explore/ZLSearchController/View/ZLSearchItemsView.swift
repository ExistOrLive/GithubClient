//
//  ZLSearchItemsView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit
import JXSegmentedView
import ZLBaseExtension
import ZLGitRemoteService
import ZLBaseUI
import ZLUtilities

@objc protocol ZLSearchItemsViewDelegate: NSObjectProtocol {
    func onFilterButtonClicked(button: UIButton)

    func onSearchTypeChanged(searchType: ZLSearchType)
}


extension ZLSearchType {
    var searchTypeTitle: String {
        switch self {
        case .repositories:do {
            return ZLLocalizedString(string: "repositories", comment: "")
        }
        case .users:do {
            return ZLLocalizedString(string: "users", comment: "")
        }
        case .organizations:do {
            return ZLLocalizedString(string: "organizations", comment: "")
        }
        case .issues:do {
            return ZLLocalizedString(string: "issues", comment: "")
        }
        case .pullRequests:do {
            return ZLLocalizedString(string: "pull requests", comment: "")
        }
        @unknown default:
            return ""
        }
    }
}

class ZLSearchItemsView: ZLBaseView {

    static let ZLSearchItemsTypes: [ZLSearchType] = [.repositories, .users, .organizations, .issues, .pullRequests]

    weak var delegate: ZLSearchItemsViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        backgroundColor = .clear
        addSubview(topBackView)
        topBackView.addSubview(segmentedView)
        topBackView.addSubview(filterButton)
        addSubview(segmentedListContainerView)
        
        topBackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(60)
        }
        segmentedView.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview()
        }
        filterButton.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.top.right.bottom.equalToSuperview()
            make.left.equalTo(segmentedView.snp.right).offset(10)
        }
        segmentedListContainerView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(topBackView.snp.bottom)
        }
    }

    @objc func onFilterViewClicked(sender: Any) {
        if self.delegate?.responds(to: #selector(ZLSearchItemsViewDelegate.onFilterButtonClicked(button:))) ?? false {
            self.delegate?.onFilterButtonClicked(button: sender as! UIButton)
        }
    }
    
    // MARK: Lazy View
    lazy var topBackView: UIView = {
       let view = UIView()
        view.backgroundColor = UIColor(named:"ZLCellBack")
        return view
    }()
    
    lazy var filterButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(UIColor(named: "ICON_Common"), for: .normal)
        button.setTitle(ZLIconFont.Filter.rawValue, for: .normal)
        button.titleLabel?.font = .zlIconFont(withSize: 18)
        button.addTarget(self, action: #selector(onFilterViewClicked(sender:)), for: .touchUpInside)
        return button
    }()
    
    lazy var segmentedView: JXSegmentedView = {
        let segmentedView = JXSegmentedView()
        segmentedView.delegate = self
        segmentedView.dataSource = segmentedViewDatasource
        segmentedView.indicators = [indicator]
        segmentedView.listContainer = segmentedListContainerView
        return segmentedView
    }()
    
    lazy var indicator: JXSegmentedIndicatorLineView = {
        let indicator = JXSegmentedIndicatorLineView()
        indicator.indicatorColor =  UIColor.init(named: "ZLExploreUnderlineColor") ?? UIColor.black
        indicator.indicatorHeight = 1.0
        return indicator
    }()

    lazy var segmentedViewDatasource: JXSegmentedTitleDataSource = {
        let datasource = JXSegmentedTitleDataSource()
        datasource.titles = titles
        datasource.itemWidthIncrement = 10
        datasource.titleNormalColor = .label(withName: "ZLLabelColor2")
        datasource.titleSelectedColor = .label(withName: "ZLLabelColor1")
        datasource.titleNormalFont =  .zlRegularFont(withSize: 14)
        datasource.titleSelectedFont = .zlSemiBoldFont(withSize: 16)
        return datasource
    }()
    
    lazy var titles: [String] = {
        ZLSearchItemsView.ZLSearchItemsTypes.map { $0.searchTypeTitle }
    }()
    
    lazy var segmentedListContainerView: JXSegmentedListContainerView = {
        let containerView = JXSegmentedListContainerView(dataSource: self)
        return containerView
    }()
    
    lazy var githubItemListViewArray: [ZLGithubItemListView] = {
        ZLSearchItemsView.ZLSearchItemsTypes.map { _ in ZLGithubItemListView() }
    }()

}

// MARK: - JXSegmentedViewDelegate
extension ZLSearchItemsView: JXSegmentedViewDelegate {

    func segmentedView(_ segmentedView: JXSegmentedView, didSelectedItemAt index: Int) {
        let searchType = ZLSearchItemsView.ZLSearchItemsTypes[index]
        if self.delegate?.responds(to: #selector(ZLSearchItemsViewDelegate.onSearchTypeChanged(searchType:))) ?? false {
            self.delegate?.onSearchTypeChanged(searchType: searchType)
        }
    }

    func segmentedView(_ segmentedView: JXSegmentedView, canClickItemAt index: Int) -> Bool {
        return true
    }
}

// MARK: - JXSegmentedListContainerViewDataSource
extension ZLSearchItemsView: JXSegmentedListContainerViewDataSource {

    /// 返回list的数量
    func numberOfLists(in listContainerView: JXSegmentedListContainerView) -> Int {
        return ZLSearchItemsView.ZLSearchItemsTypes.count
    }

    func listContainerView(_ listContainerView: JXSegmentedListContainerView, initListAt index: Int) -> JXSegmentedListContainerViewListDelegate {
        return self.githubItemListViewArray[index]
    }
}

extension ZLSearchItemsView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}

extension ZLGithubItemListView: JXSegmentedListContainerViewListDelegate {
    func listView() -> UIView {
        return self
    }
}
