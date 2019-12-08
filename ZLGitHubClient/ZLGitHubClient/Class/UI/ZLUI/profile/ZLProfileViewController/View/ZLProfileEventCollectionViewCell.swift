//
//  ZLMyEventCollectionViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/12/3.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit

class ZLProfileEventCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var eventInfoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 5.0
    }

    func fillWithData(data : ZLProfileEventCollectionViewCellData?)
    {
        self.timeLabel.text = data?.timeText
        self.eventInfoLabel.text = data?.eventInfo
    }
    
    
}
