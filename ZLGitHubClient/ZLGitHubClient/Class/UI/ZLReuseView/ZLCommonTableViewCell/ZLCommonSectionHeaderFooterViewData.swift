//
//  ZLCommonSectionHeaderFooterViewData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/29.
//

import Foundation
import ZLUIUtilities
import UIKit
import ZMMVVM

class ZLCommonSectionHeaderFooterViewDataV2: ZMBaseTableViewReuseViewModel {
    
    var viewHeight = CGFloat.leastNonzeroMagnitude
    var backColor: UIColor?
    
    override var zm_viewReuseIdentifier: String {
        return "ZLCommonSectionHeaderFooterView"
    }

    override var zm_viewHeight: CGFloat {
        viewHeight
    }
    
    init(backColor: UIColor? = nil,
         viewHeight: CGFloat = CGFloat.leastNonzeroMagnitude) {
        self.backColor = backColor
        self.viewHeight = viewHeight
        super.init()
    }
}
