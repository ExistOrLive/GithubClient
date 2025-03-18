//
//  ZLWorkboardBaseView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import ZLBaseExtension
import ZMMVVM

class ZLWorkboardBaseView: UIView, ZMBaseTableViewContainerProtocol {
   
    lazy var tableViewProxy: ZMMVVM.ZMBaseTableViewProxy = {
        let tableViewProxy = ZMBaseTableViewProxy(style: .grouped)
        tableViewProxy.tableView.showsVerticalScrollIndicator = false
        tableViewProxy.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
        tableViewProxy.tableView.register(ZLWorkboardTableViewCell.self, 
                                          forCellReuseIdentifier: "ZLWorkboardTableViewCell")
        tableViewProxy.tableView.register(ZLWorkboardTableViewSectionHeader.self, 
                                          forHeaderFooterViewReuseIdentifier: "ZLWorkboardTableViewSectionHeader")
        tableViewProxy.tableView.register(ZLWorkboardFixedRepoPlaceHolderView.self,
                                          forHeaderFooterViewReuseIdentifier: "ZLWorkboardFixedRepoPlaceHolderView")
        return tableViewProxy
    }()
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: ZLLanguageTypeChange_Notificaiton, object: nil)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
   
        self.backgroundColor = UIColor.clear
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ZLWorkboardBaseView {
    @objc func onNotificationArrived(notification: Notification) {
        if notification.name == ZLLanguageTypeChange_Notificaiton {
            self.tableView.reloadData()
        }
    }
}

extension ZLWorkboardBaseView: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLWorkboardBaseViewModel) {
        self.sectionDataArray = viewData.sectionDataArray
        self.tableView.reloadData()
    }
}
