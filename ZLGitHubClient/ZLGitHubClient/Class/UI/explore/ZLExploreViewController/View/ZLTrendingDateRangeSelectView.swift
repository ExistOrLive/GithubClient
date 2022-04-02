//
//  ZLTrendingDateRangeSelectView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/25.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit
import FFPopup

class ZLTrendingDateRangeSelectView: ZLBaseView {

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var tableView: UITableView!

    weak var popup: FFPopup?

    var resultBlock: ((ZLDateRange) -> Void)?
    var initDateRange: ZLDateRange = ZLDateRangeDaily

    let dataSource: [ZLDateRange] = [ZLDateRangeDaily,
                                      ZLDateRangeWeakly,
                                      ZLDateRangeMonthly]

    override func awakeFromNib() {
        super.awakeFromNib()

        self.titleLabel.text = ZLLocalizedString(string: "DateRange", comment: "")

        self.tableView.register(UINib.init(nibName: "ZLTrendingDateRangeTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLTrendingDateRangeTableViewCell")
        self.tableView.dataSource = self
        self.tableView.delegate = self

    }

    static func showTrendingDateRangeSelectView(initDateRange: ZLDateRange, resultBlock : @escaping ((ZLDateRange) -> Void)) {

        guard let view: ZLTrendingDateRangeSelectView = Bundle.main.loadNibNamed("ZLTrendingDateRangeSelectView", owner: nil, options: nil)?.first as? ZLTrendingDateRangeSelectView else {
            return
        }
        view.resultBlock = resultBlock
        view.initDateRange = initDateRange
        view.tableView.reloadData()

        view.frame = CGRect.init(x: 0, y: 0, width: 280, height: 200)
        let popup = FFPopup(contentView: view, showType: .bounceIn, dismissType: .bounceOut, maskType: FFPopup.MaskType.dimmed, dismissOnBackgroundTouch: true, dismissOnContentTouch: false)
        view.popup = popup
        popup.show(layout: .Center)

    }

}

extension ZLTrendingDateRangeSelectView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ZLTrendingDateRangeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "ZLTrendingDateRangeTableViewCell", for: indexPath) as? ZLTrendingDateRangeTableViewCell else {
            return UITableViewCell.init()
        }

        let dateRange = self.dataSource[indexPath.row]

        var title = ZLLocalizedString(string: "Today", comment: "")
        switch dateRange {
        case ZLDateRangeDaily : title = ZLLocalizedString(string: "Today", comment: "")
            break
        case ZLDateRangeWeakly : title = ZLLocalizedString(string: "This Week", comment: "")
            break
        case ZLDateRangeMonthly : title = ZLLocalizedString(string: "This Month", comment: "")
            break
        default:
            break
        }
        cell.titleLabel.text = title

        if initDateRange == dateRange {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
        return cell
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dateRange = self.dataSource[indexPath.row]
        self.resultBlock?(dateRange)
        self.popup?.dismiss(animated: true)
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.endEditing(true)
    }
}
