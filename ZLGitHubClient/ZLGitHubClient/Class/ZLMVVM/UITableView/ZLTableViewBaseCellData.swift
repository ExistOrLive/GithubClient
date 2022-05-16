//
//  ZLTableViewBaseCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import ZLBaseUI

class ZLTableViewBaseCellData: ZLBaseViewModel,ZLTableViewCellProtocol {
   
    var indexPath: IndexPath?
    
    var cellReuseIdentifier: String {
        "UITableViewCell"
    }
    
    var cellHeight: CGFloat {
        UITableView.automaticDimension
    }
    
    var cellSwipeActions: UISwipeActionsConfiguration? {
        nil
    }
    
    func onCellSingleTap() {
        
    }
    
    func setCellIndexPath(indexPath: IndexPath) {
        self.indexPath = indexPath
    }
    
    func clearCache() {
        
    }
}

class ZLTableViewBaseSectionData: ZLBaseViewModel,ZLTableViewSectionProtocol {
    
    private var _cellDatas: [ZLTableViewCellProtocol]
    
    init(cellDatas: [ZLTableViewCellProtocol]) {
        self._cellDatas = cellDatas
        super.init()
    }
    
    var cellDatas: [ZLTableViewCellProtocol] {
        _cellDatas
    }
    
    var sectionHeaderHeight: CGFloat {
        0
    }
    
    var sectionFooterHeight: CGFloat {
        0
    }
    
    var sectionHeaderReuseIdentifier: String? {
        nil
    }
    
    var sectionFooterReuseIdentifier: String? {
        nil
    }
    
    func resetCellDatas(cellDatas: [ZLTableViewCellProtocol]) {
        _cellDatas = cellDatas
    }

    func appendCellDatas(cellDatas: [ZLTableViewCellProtocol]) {
        _cellDatas.append(contentsOf: cellDatas)
    }
    
    
}






