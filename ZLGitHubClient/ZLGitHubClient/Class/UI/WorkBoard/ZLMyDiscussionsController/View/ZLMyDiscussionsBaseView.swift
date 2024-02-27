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
import SwiftUI
import ZLUIUtilities
import ZLBaseUI
import ZLBaseExtension

protocol ZLMyDiscussionsBaseViewDelegateAndDataSource: NSObjectProtocol {
    // DataSource
    var cellDatas: [ZLTableViewCellDataProtocol] { get }
    
    var hasMoreData: Bool { get }
    
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
            make.edges.equalTo(UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0))
        }
    }
    
    func startLoad() {
        itemView.startLoad()
    }
    
    func reloadData() {
        if let viewData = delegate {
            itemView.resetCellDatas(cellDatas: viewData.cellDatas, hasMoreData: viewData.hasMoreData)
        }
    }
    
    
    // MARK: View
    lazy var itemView: ZLTableContainerView = {
       let view = ZLTableContainerView()
        view.setTableViewHeader()
        view.setTableViewFooter()
        view.delegate = self
        view.register(ZLDiscussionTableViewCell.self, forCellReuseIdentifier: "ZLDiscussionTableViewCell")
        return view
    }()

}

extension ZLMyDiscussionsBaseView: ZLTableContainerViewDelegate {
    
    func zlLoadNewData() {
        delegate?.loadNewData()
    }
    func zlLoadMoreData() {
        delegate?.loadMoreData()
    }
}


extension ZLMyDiscussionsBaseView: ZLViewUpdatableWithViewData {
    func justUpdateView() {
        
    }
    
    func fillWithViewData(viewData: ZLMyDiscussionsBaseViewDelegateAndDataSource) {
        delegate = viewData
        itemView.resetCellDatas(cellDatas: viewData.cellDatas, hasMoreData: viewData.hasMoreData)
    }
}
