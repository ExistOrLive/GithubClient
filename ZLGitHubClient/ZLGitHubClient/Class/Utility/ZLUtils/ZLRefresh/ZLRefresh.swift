//
//  ZLRefreshHeader.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import MJRefresh

enum ZLRefreshViewType: Int {
    case header
    case footer
}

protocol ZLRefreshProtocol: NSObjectProtocol {
    
    var scrollView: UIScrollView { get }
    
    func setRefreshView(type: ZLRefreshViewType)
    
    func hiddenRefreshView(type: ZLRefreshViewType)
    
    func showRefreshView(type: ZLRefreshViewType)
    
    
    func beginRefreshView(type: ZLRefreshViewType)
    
    func endRefreshView(type: ZLRefreshViewType)
    
    func endRefreshFooterWithNoMoreData()
    
    func resetRefreshFooter()
    
    
    func refreshLoadNewData()
    
    func refreshLoadMoreData()
}

extension ZLRefreshProtocol {
   
    func setRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer = ZLRefresh.refreshFooter { [weak self] in
                self?.refreshLoadMoreData()
            }
        } else if type == .header {
            scrollView.mj_header = ZLRefresh.refreshHeader { [weak self] in
                self?.refreshLoadNewData()
            }
        }
    }
    
    func hiddenRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.isHidden = true
        } else if type == .header {
            scrollView.mj_header?.isHidden = true
        }
    }
    
    func showRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.isHidden = false
        } else if type == .header {
            scrollView.mj_header?.isHidden = false
        }
    }
    
    func beginRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.beginRefreshing()
        } else if type == .header {
            scrollView.mj_header?.beginRefreshing()
        }
    }
    
    func endRefreshView(type: ZLRefreshViewType) {
        if type == .footer {
            scrollView.mj_footer?.endRefreshing()
        } else if type == .header {
            scrollView.mj_header?.endRefreshing()
        }
    }
    
    func endRefreshFooterWithNoMoreData() {
        scrollView.mj_footer?.endRefreshingWithNoMoreData()
    }
    
    func resetRefreshFooter() {
        scrollView.mj_footer?.resetNoMoreData()
    }
    
}






@objcMembers class ZLRefresh: NSObject {

    static func refreshHeader(refreshingBlock:@escaping MJRefreshComponentAction) -> MJRefreshHeader {
        let header = MJRefreshNormalHeader.init(refreshingBlock: refreshingBlock)
        header.lastUpdatedTimeLabel?.isHidden = true
        header.setTitle(ZLLocalizedString(string: "MJRefreshHeaderIdleText", comment: ""), for: .idle)
        header.setTitle(ZLLocalizedString(string: "MJRefreshHeaderPullingText", comment: ""), for: .pulling)
        header.setTitle(ZLLocalizedString(string: "MJRefreshHeaderRefreshingText", comment: ""), for: .refreshing)
        return header
    }

    static func refreshFooter(refreshingBlock:@escaping MJRefreshComponentAction) -> MJRefreshFooter {
        let footer = MJRefreshAutoStateFooter.init(refreshingBlock: refreshingBlock)
        footer.setTitle("", for: .idle)
        footer.setTitle(ZLLocalizedString(string: "MJRefreshAutoFooterRefreshingText", comment: ""), for: .refreshing)
        footer.setTitle(ZLLocalizedString(string: "MJRefreshAutoFooterNoMoreDataText", comment: ""), for: .noMoreData)
        return footer
    }

    static func justRefreshHeader(header: MJRefreshNormalHeader?) {
        header?.setTitle(ZLLocalizedString(string: "MJRefreshHeaderIdleText", comment: ""), for: .idle)
        header?.setTitle(ZLLocalizedString(string: "MJRefreshHeaderPullingText", comment: ""), for: .pulling)
        header?.setTitle(ZLLocalizedString(string: "MJRefreshHeaderRefreshingText", comment: ""), for: .refreshing)
    }

    static func justRefreshFooter(footer: MJRefreshAutoStateFooter?) {
        footer?.setTitle("", for: .idle)
        footer?.setTitle(ZLLocalizedString(string: "MJRefreshAutoFooterRefreshingText", comment: ""), for: .refreshing)
        footer?.setTitle(ZLLocalizedString(string: "MJRefreshAutoFooterNoMoreDataText", comment: ""), for: .noMoreData)
    }

}
