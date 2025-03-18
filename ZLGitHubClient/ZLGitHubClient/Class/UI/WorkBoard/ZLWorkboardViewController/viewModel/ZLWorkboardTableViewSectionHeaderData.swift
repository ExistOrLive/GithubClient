//
//  ZLWorkboardTableViewSectionHeaderData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/18.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZMMVVM

enum ZLWorkboardClassicType: ZMBaseSectionUniqueIDProtocol {
    case work
    case fixRepo
    
    var zm_ID: String {
        switch self {
        case .work:
            return "work"
        case .fixRepo:
            return "fixRepo"
        }
    }
}

class ZLWorkboardTableViewSectionHeaderData: ZMBaseTableViewReuseViewModel {
    
    private let classicType: ZLWorkboardClassicType
    
    init(classicType: ZLWorkboardClassicType) {
        self.classicType = classicType
        super.init()
    }
    
    override var zm_sectionID: any ZMBaseSectionUniqueIDProtocol {
        classicType
    }

    override var zm_viewReuseIdentifier: String {
        return "ZLWorkboardTableViewSectionHeader"
    }

    override var zm_viewHeight: CGFloat {
        60
    }
}



extension ZLWorkboardTableViewSectionHeaderData {
    var title: String {
        switch classicType {
        case .fixRepo:
            return ZLLocalizedString(string: "Fixed Repos", comment: "")
        case .work:
            return ZLLocalizedString(string: "My Work", comment: "")
        }
    }
    
    var showEditButton: Bool {
        switch classicType {
        case .fixRepo:
            return true
        case .work:
            return false
        }
    }
    
    var editButtonTitle: String {
        ZLLocalizedString(string: "Edit", comment: "")
    }
    
    func onEditAction() {
        if let vc = ZLUIRouter.getEditFixedRepoController() {
            vc.hidesBottomBarWhenPushed = true
            zm_viewController?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
