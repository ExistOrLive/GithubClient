//
//  ZLSearchFilterViewForUser.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/10/27.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit



class ZLSearchFilterViewForUser: UIView {
    
    static let minWidth : CGFloat = 300.0

    @IBOutlet private weak var orderLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var createTimeLabel: UILabel!
    @IBOutlet private weak var starLabel: UILabel!
    @IBOutlet private weak var forkLabel: UILabel!
    @IBOutlet private weak var sizeLabel: UILabel!
    
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!

}
