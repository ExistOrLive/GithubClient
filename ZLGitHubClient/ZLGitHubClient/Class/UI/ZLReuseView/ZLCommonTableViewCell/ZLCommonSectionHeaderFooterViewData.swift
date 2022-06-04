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
    
    init(cellDatas: [ZLTableViewCellProtocol],
         headerHeight: CGFloat = CGFloat.leastNonzeroMagnitude ,
         footerHeight: CGFloat = CGFloat.leastNonzeroMagnitude,
         headerColor: UIColor? = nil,
         footerColor: UIColor? = nil,
         headerReuseIdentifier: String? = nil,
         footerReuseIdentifier: String? = nil) {
        super.init(cellDatas: cellDatas)
        self.headerHeight = headerHeight
        self.footerHeight = footerHeight
        self.headerColor = headerColor
        self.footerColor = footerColor
        self.headerReuseIdentifier = headerReuseIdentifier
        self.footerReuseIdentifier = footerReuseIdentifier
    }
    
    override var sectionHeaderHeight: CGFloat {
        headerHeight
    }
    
    override var sectionFooterHeight: CGFloat {
        footerHeight
    }
    
    override  var sectionHeaderReuseIdentifier: String? {
        headerReuseIdentifier
    }
    
    override var sectionFooterReuseIdentifier: String? {
        footerReuseIdentifier
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
