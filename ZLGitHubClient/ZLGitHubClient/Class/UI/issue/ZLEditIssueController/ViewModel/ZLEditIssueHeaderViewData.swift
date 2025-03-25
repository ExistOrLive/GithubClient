//
//  ZLEditIssueHeaderViewData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/25.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZMMVVM

class ZLEditIssueHeaderViewData: ZMBaseTableViewReuseViewModel {
    
    let sectionType: ZLEditIssueSectionType
    
    var editIssueVC: ZLEditIssueController? {
        zm_superViewModel as? ZLEditIssueController
    }
    
    init(sectionType: ZLEditIssueSectionType) {
        self.sectionType  = sectionType
    }
    
    
    override var zm_sectionID: any ZMBaseSectionUniqueIDProtocol {
        return sectionType
    }

    override var zm_viewReuseIdentifier: String {
        return "ZLEditIssueHeaderView"
    }

    override var zm_viewHeight: CGFloat {
        50
    }
    
    var title: String {
        switch sectionType {
        case .assignees:
            return ZLLocalizedString(string: "Assignee", comment: "")
        case .label:
            return ZLLocalizedString(string: "Label", comment: "")
        case .project:
            return ZLLocalizedString(string: "Project", comment: "")
        case .milestone:
            return ZLLocalizedString(string: "Milestone", comment: "")
        default:
            return ""
        }
    }
    
    var showEditButton: Bool {
        switch sectionType {
        case .assignees:
            return editIssueVC?.viewerCanUpdate ?? false
        default:
            return false
        }
    }
    
    func onEditButtonAction() {
        switch sectionType {
        case .assignees:
            editIssueVC?.onEditAssigneeAction()
        default:
            break
        }
        
    }
}
