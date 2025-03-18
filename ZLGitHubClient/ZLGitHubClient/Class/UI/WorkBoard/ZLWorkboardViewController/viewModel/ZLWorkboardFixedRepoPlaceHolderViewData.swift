//
//  ZLWorkboardFixedRepoPlaceHolderViewData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2025/3/18.
//  Copyright © 2025 ZM. All rights reserved.
//

import Foundation
import ZMMVVM

class ZLWorkboardFixedRepoPlaceHolderViewData: ZMBaseTableViewReuseViewModel {
    
    override var zm_viewReuseIdentifier: String {
        return "ZLWorkboardFixedRepoPlaceHolderView"
    }

    override var zm_viewHeight: CGFloat {
        30
    }
}
