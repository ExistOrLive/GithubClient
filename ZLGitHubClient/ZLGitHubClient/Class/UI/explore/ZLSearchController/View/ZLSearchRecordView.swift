//
//  ZLSearchRecordView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLSearchRecordViewDelegate: NSObjectProtocol {
    func clearRecord()
}

class ZLSearchRecordView: ZLBaseView {

    weak var delegate: ZLSearchRecordViewDelegate?

    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var recordLabel: UILabel!

    @IBOutlet weak var clearButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.recordLabel.text = ZLLocalizedString(string: "SearchRecord", comment: "")
        self.clearButton.setTitle(ZLLocalizedString(string: "ClearSearchRecord", comment: ""), for: .normal)

        self.tableView.backgroundColor = UIColor.clear
        self.tableView.register(UINib.init(nibName: "ZLSearchRecordTableViewCell", bundle: nil), forCellReuseIdentifier: "ZLSearchRecordTableViewCell")
    }

    @IBAction func onClearButtonClicked(_ sender: Any) {
        if self.delegate?.responds(to: #selector(ZLSearchRecordViewDelegate.clearRecord)) ?? false {
            self.delegate?.clearRecord()
        }

    }
}
