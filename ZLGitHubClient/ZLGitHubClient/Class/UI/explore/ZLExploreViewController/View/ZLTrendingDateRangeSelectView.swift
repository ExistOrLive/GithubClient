//
//  ZLTrendingDateRangeSelectView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/25.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FFPopup
import ZLGitRemoteService
import ZLUIUtilities
import ZLBaseExtension

extension ZLDateRange {
    var title: String {
        switch self {
        case ZLDateRangeDaily:
            return ZLLocalizedString(string: "Today", comment: "")
        case ZLDateRangeWeakly:
            return ZLLocalizedString(string: "This Week", comment: "")
        case ZLDateRangeMonthly:
            return ZLLocalizedString(string: "This Month", comment: "")
        default:
            return ZLLocalizedString(string: "Today", comment: "")
        }
    }
}

class ZLTrendingFilterManager {
    
    /// 时间范围列表
    let dateRangeArray: [ZLDateRange] = [ZLDateRangeDaily,
                                         ZLDateRangeWeakly,
                                         ZLDateRangeMonthly]

    /// 选择时间范围
    lazy var dateRangeSelectView: ZMSingleSelectTitlePopView = {
        let dateRangeSelectView = ZMSingleSelectTitlePopView()
        dateRangeSelectView.frame = UIScreen.main.bounds
        dateRangeSelectView.textFieldBackView.isHidden = true
        dateRangeSelectView.contentWidth = 280
        dateRangeSelectView.contentHeight = 195
        dateRangeSelectView.collectionView.lineSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.interitemSpacing = .leastNonzeroMagnitude
        dateRangeSelectView.collectionView.itemSize = CGSize(width: 280, height: 50)
        dateRangeSelectView.popDelegate = ZMPopContainerViewDelegate_Center.shared
        return dateRangeSelectView
    }()
}

/// show/dismiss
extension ZLTrendingFilterManager {
   
    /// 弹出时间范围弹出选择框
    func showTrendingDateRangeSelectView(to: UIView,
                                         initDateRange: ZLDateRange,
                                         resultBlock : @escaping ((ZLDateRange) -> Void)) {
        let titles = dateRangeArray.map({ $0.title })
        let selectedIndex = dateRangeArray.firstIndex(of: initDateRange) ?? 0
        dateRangeSelectView.titleLabel.text = ZLLocalizedString(string: "DateRange", comment: "")
        dateRangeSelectView.frame = UIScreen.main.bounds
        dateRangeSelectView.showSingleSelectTitleBox(to,
                                                     contentPoition: .center,
                                                     animationDuration: 0.1,
                                                     titles: titles,
                                                     selectedIndex: selectedIndex,
                                                     cellType: ZMInputCollectionViewSelectTickCell.self)
        { [weak self] index, title in
            guard let self = self else { return }
            resultBlock(self.dateRangeArray[index])
        }
    }
}


