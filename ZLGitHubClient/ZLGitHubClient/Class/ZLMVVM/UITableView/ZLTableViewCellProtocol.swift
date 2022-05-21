//
//  ZLTableViewCellProtocol.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/5/15.
//  Copyright © 2022 ZM. All rights reserved.
//

import Foundation
import UIKit

// 未协议中的方法失去动态性，请勿在非final class的extension中实现协议或在协议扩展中提供默认实现

protocol ZLTableViewSectionProtocol {
    
    var cellDatas: [ZLTableViewCellProtocol] { get }
    
    var sectionHeaderHeight: CGFloat { get }
    
    var sectionFooterHeight: CGFloat { get }
        
    var sectionHeaderReuseIdentifier: String? { get }
   
    var sectionFooterReuseIdentifier: String? { get }
    
    func resetCellDatas(cellDatas: [ZLTableViewCellProtocol])

    func appendCellDatas(cellDatas: [ZLTableViewCellProtocol])
}


protocol ZLTableViewCellProtocol {
    
    var cellReuseIdentifier: String { get }
    
    var cellHeight: CGFloat { get }
    
    var cellSwipeActions: UISwipeActionsConfiguration? { get }
    
    func onCellSingleTap()
    
    func setCellIndexPath(indexPath: IndexPath)
    
    func clearCache() 
}

