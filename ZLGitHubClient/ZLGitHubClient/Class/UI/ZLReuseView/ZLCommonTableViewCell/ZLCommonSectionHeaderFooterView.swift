//
//  ZLCommonSectionHeaderFooterView.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/29.
//

import Foundation
import UIKit
import ZLUIUtilities

protocol ZLCommonSectionHeaderViewDelegate {
    var headerBackgroundColor: UIColor { get }
}

class ZLCommonSectionHeaderView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = "ZLCommonSectionHeaderView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ZLCommonSectionHeaderView: ZLViewUpdatableWithViewData {
    func justUpdateView() {
        
    }
    func fillWithViewData(viewData data: ZLCommonSectionHeaderViewDelegate) {
        contentView.backgroundColor = data.headerBackgroundColor
    }
}


protocol ZLCommonSectionFooterViewDelegate {
    var footerBackgroundColor: UIColor { get }
}

class ZLCommonSectionFooterView: UITableViewHeaderFooterView {
    
    static let reuseIdentifier: String = "ZLCommonSectionFooterView"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension ZLCommonSectionFooterView: ZLViewUpdatableWithViewData {
    func justUpdateView() {
        
    }
    func fillWithViewData(viewData data: ZLCommonSectionFooterViewDelegate) {
        contentView.backgroundColor = data.footerBackgroundColor
    }
}


