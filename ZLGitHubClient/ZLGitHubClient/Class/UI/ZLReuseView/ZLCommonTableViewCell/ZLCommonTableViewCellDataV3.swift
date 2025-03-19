//
//  ZLCommonTableViewCellDataV3 2.swift
//  ZLGitHubClient
//
//  Created by admin on 3/19/25.
//  Copyright © 2025 ZM. All rights reserved.
//


import UIKit
import ZLUIUtilities
import ZMMVVM

class ZLCommonTableViewCellDataV3: ZMBaseTableViewCellViewModel {

    private var _canClick: Bool = false
    private var _titleBlock: () -> String = { "" }
    private var _infoBlock: () -> String = { "" }
    private var _showSeparateLine: Bool = false
    private var _actionBlock: (() -> Void)?
    private var _cellHeight: CGFloat

    init(canClick: Bool,
         title: @escaping () -> String,
         info: @escaping () -> String,
         cellHeight: CGFloat,
         showSeparateLine:Bool = false,
         actionBlock:(() -> Void)? = nil) {
        _canClick = canClick
        _titleBlock = title
        _infoBlock = info
        _showSeparateLine = showSeparateLine
        _actionBlock = actionBlock
        _cellHeight = cellHeight
        super.init()
    }

    override var zm_cellReuseIdentifier: String{
        "ZLCommonTableViewCell"
    }
    
    override func zm_onCellSingleTap() {
       _actionBlock?()
    }
    
    override var zm_cellHeight: CGFloat {
        _cellHeight
    }
}

extension ZLCommonTableViewCellDataV3: ZLCommonTableViewCellDataSourceAndDelegate {

    var canClick: Bool {
        _canClick
    }

    var title: String {
        _titleBlock()
    }

    var info: String {
        _infoBlock()
    }
    
    var showSeparateLine: Bool {
        _showSeparateLine
    }

}
