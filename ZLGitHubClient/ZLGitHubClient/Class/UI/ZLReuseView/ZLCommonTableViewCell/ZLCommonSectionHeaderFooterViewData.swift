//
//  ZLCommonSectionHeaderFooterViewData.swift
//  ZLGiteeClient
//
//  Created by 朱猛 on 2022/5/29.
//

import Foundation
import ZLUIUtilities
import UIKit

class ZLCommonSectionHeaderFooterViewData: ZLTableViewBaseSectionData {
    
    private var headerHeight = CGFloat.leastNonzeroMagnitude
    private var footerHeight = CGFloat.leastNonzeroMagnitude
    private var headerColor: UIColor?
    private var footerColor: UIColor?
    private var headerReuseIdentifier: String?
    private var footerReuseIdentifier: String?
    
    init(cellDatas: [ZLTableViewCellDataProtocol],
         headerHeight: CGFloat = CGFloat.leastNonzeroMagnitude ,
         footerHeight: CGFloat = CGFloat.leastNonzeroMagnitude,
         headerColor: UIColor? = nil,
         footerColor: UIColor? = nil,
         headerReuseIdentifier: String? = nil,
         footerReuseIdentifier: String? = nil) {
        super.init(cellDatas: cellDatas)
        
        if let headerReuseIdentifier {
            let view = ZLTableViewBaseSectionViewData()
            view.sectionViewReuseIdentifier = headerReuseIdentifier
            view.sectionViewHeight = headerHeight
            sectionHeaderViewData = view
        }
        
        if let footerReuseIdentifier {
            let view = ZLTableViewBaseSectionViewData()
            view.sectionViewReuseIdentifier = footerReuseIdentifier
            view.sectionViewHeight = footerHeight
            sectionFooterViewData = view
        }
    }
}

extension ZLCommonSectionHeaderFooterViewData: ZLCommonSectionHeaderViewDelegate {
    var headerBackgroundColor: UIColor {
        headerColor ?? .clear
    }
}

extension ZLCommonSectionHeaderFooterViewData: ZLCommonSectionFooterViewDelegate {
    var footerBackgroundColor: UIColor {
        footerColor ?? .clear
    }
}
