//
//  ZLLanguageTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/5/19.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLLanguageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var selectedTag: UIImageView!
    
    @IBOutlet weak var languageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            self.selectedTag.isHidden = false
            self.languageLabel.textColor = UIColor.black
        } else {
            self.selectedTag.isHidden = true
            self.languageLabel.textColor = UIColor.init(named: "ZLLabelColor4")
        }
    }
    
}
