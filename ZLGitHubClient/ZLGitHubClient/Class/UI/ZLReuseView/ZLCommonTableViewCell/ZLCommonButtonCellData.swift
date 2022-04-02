//
//  ZLCommonButtonCellData.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2022/3/30.
//  Copyright © 2022 ZM. All rights reserved.
//

import UIKit

class ZLCommonButtonCellData: ZLGithubItemTableViewCellData {
    
    private var _clickBlock: ((UIButton) -> Void)?
    private var _relayoutBlock: ((UIButton) -> Void)?
    
    init(clickBlock: ((UIButton) -> Void)? = nil, relayoutBlock:  ((UIButton) -> Void)? = nil) {
        super.init()
        self._clickBlock = clickBlock
        self._relayoutBlock = relayoutBlock
    }
    
    override func getCellReuseIdentifier() -> String {
        return "ZLCommonButtonCell"
    }
}

extension ZLCommonButtonCellData: ZLCommonButtonCellDelegate {
    var relayoutBlock: ((UIButton) -> Void)? {
        _relayoutBlock
    }
    
    var clickBlock: ((UIButton) -> Void)? {
        _clickBlock
    }
}
