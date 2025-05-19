//
//  ZLCommonSectionHeaderFooterView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/29.
//

import Foundation
import UIKit
import ZLUIUtilities
import ZMMVVM

class ZLCommonSectionHeaderFooterView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = "ZLCommonSectionHeaderFooterView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ZLCommonSectionHeaderFooterView: ZMBaseViewUpdatableWithViewData {
    func zm_fillWithViewData(viewData: ZLCommonSectionHeaderFooterViewDataV2) {
        contentView.backgroundColor = viewData.backColor
        backgroundColor = viewData.backColor
    }
}
