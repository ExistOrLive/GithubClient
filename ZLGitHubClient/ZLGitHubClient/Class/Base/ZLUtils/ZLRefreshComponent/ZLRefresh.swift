//
//  ZLRefreshHeader.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/16.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRefresh: NSObject {

    static func refreshHeader(refreshingBlock:@escaping MJRefreshComponentAction) -> MJRefreshHeader
    {
        let header = MJRefreshNormalHeader.init(refreshingBlock:refreshingBlock)
        header.lastUpdatedTimeLabel?.isHidden = true
        return header
    }
    
    
    static func refreshFooter(refreshingBlock:@escaping MJRefreshComponentAction) -> MJRefreshFooter
      {
          let footer = MJRefreshAutoStateFooter.init(refreshingBlock:refreshingBlock)
          footer.setTitle("", for: .idle)
          return footer
      }

}
