//
//  ZLRefreshHeader.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import MJRefresh

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
