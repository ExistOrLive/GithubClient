//
//  ZLMyDiscussionsBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/2.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import SnapKit

protocol ZLMyDiscussionsBaseViewDelegateAndDataSource: NSObjectProtocol {
    // DataSource
    var cellDatas: [ZLGithubItemTableViewCellData] { get }
    
    var isLastPage: Bool { get }
    
    // Delegate
    func loadNewData()
    
    func loadMoreData()
}


class ZLMyDiscussionsBaseView: ZLBaseView {
    
    weak var delegate: ZLMyDiscussionsBaseViewDelegateAndDataSource?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(itemView)
        
        itemView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func startLoad() {
        itemView.beginRefresh()
    }
    
    func reloadData() {
        if let viewData = delegate {
            itemView.setCellDatas(cellDatas: viewData.cellDatas, lastPage: viewData.isLastPage)
        }
    }
    
    
    // MARK: View
    lazy var itemView: ZLGithubItemListView = {
       let view = ZLGithubItemListView()
        view.delegate = self
        view.setTableViewHeader()
        view.setTableViewFooter()
        return view
    }()

}

extension ZLMyDiscussionsBaseView: ZLGithubItemListViewDelegate {
    func githubItemListViewRefreshDragDown(pullRequestListView: ZLGithubItemListView) {
        delegate?.loadNewData()
    }
    
    func githubItemListViewRefreshDragUp(pullRequestListView: ZLGithubItemListView) {
        delegate?.loadMoreData()
    }
}


extension ZLMyDiscussionsBaseView: ViewUpdatable {
    func fillWithData(viewData: ZLMyDiscussionsBaseViewDelegateAndDataSource) {
        delegate = viewData
        itemView.setCellDatas(cellDatas: viewData.cellDatas, lastPage: viewData.isLastPage)
    }
}
