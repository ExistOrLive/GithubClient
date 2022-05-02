//
//  ZLMyDiscussionsController.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/2.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit
import ZLBaseUI
import SnapKit
import ZLGitRemoteService

class ZLMyDiscussionsController: ZLBaseViewController {
    
    // Model
    private var _after: String?
    
    private var _cellDatas: [ZLGithubItemTableViewCellData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        contentView.showProgressHUD()
        loadData(isLoadNewData: true)
    }
    
    private func setupUI() {
        title = ZLLocalizedString(string: "Discussions", comment: "")
        contentView.addSubview(discussionsView)
        discussionsView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        discussionsView.fillWithData(viewData: self)
    }

    // MARK: view
    
    private lazy var discussionsView: ZLMyDiscussionsBaseView = {
        let view = ZLMyDiscussionsBaseView()
        return view
    }()

}

// MARK: ZLMyDiscussionsBaseViewDelegateAndDataSource
extension ZLMyDiscussionsController: ZLMyDiscussionsBaseViewDelegateAndDataSource {
    // DataSource
    var cellDatas: [ZLGithubItemTableViewCellData] {
        _cellDatas
    }
    
    var isLastPage: Bool {
        _after == nil
    }
    
    // Delegate
    func loadNewData() {
        loadData(isLoadNewData: true)
    }
    
    func loadMoreData() {
        loadData(isLoadNewData: false)
    }
}

// MARK: Request
extension ZLMyDiscussionsController {
    func loadData(isLoadNewData: Bool) {
        ZLViewerServiceShared()?.getMyDiscussions(key: nil,
                                                  filter: .created,
                                                  after: isLoadNewData ? nil : _after,
                                                  serialNumber: NSString.generateSerialNumber(),
                                                  completeHandle: { [weak self] resultModel in
            guard let self = self else { return }
            self.contentView.dismissProgressHUD()
            
            if resultModel.result {
                
                guard let data = resultModel.data as? SearchItemQuery.Data else {
                    self.discussionsView.reloadData()
                    return
                }
                var cellDatas: [ZLDiscussionTableViewCellData] = []
                for node in data.search.nodes ?? [] {
                    if let discussionData = node?.asDiscussion {
                        let cellData = ZLDiscussionTableViewCellData(data: discussionData)
                        cellDatas.append(cellData)
                    }
                }
                self.addSubViewModels(cellDatas)
                if isLoadNewData {
                    self._cellDatas = cellDatas
                } else {
                    self._cellDatas.append(contentsOf: cellDatas)
                }
                self._after = data.search.pageInfo.endCursor
                self.discussionsView.reloadData()
                
            } else {
                self.discussionsView.reloadData()
                guard let errorModel = resultModel.data as? ZLGithubRequestErrorModel else {
                    return
                }
                ZLToastView.showMessage(errorModel.message)
            }
        })
    }
}


