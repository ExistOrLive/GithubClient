//
//  ZLSearchTypeCollectionViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/8/4.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLSearchTypeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var label: UILabel!

    @IBOutlet weak var underlineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override var isSelected: Bool {
        willSet {
            if newValue == true {
                self.underlineView.isHidden = false
                self.label.font = UIFont.init(name: Font_PingFangSCSemiBold, size: 16.0)
                self.label.textColor = UIColor.init(hexString: "1A191F", alpha: 1.0)
            } else {
                self.underlineView.isHidden = true
                self.label.font = UIFont.init(name: Font_PingFangSCRegular, size: 14.0)
                self.label.textColor = UIColor.init(hexString: "999999", alpha: 1.0)
            }
        }
    }

}
