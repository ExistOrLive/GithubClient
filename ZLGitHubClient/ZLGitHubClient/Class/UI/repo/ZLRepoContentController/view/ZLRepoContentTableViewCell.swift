//
//  ZLRepoContentTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/22.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

class ZLRepoContentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeImageView: UIImageView!
    
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCellData(cellData : ZLGithubContentModel?)
    {
        if cellData?.type == "dir"
        {
            self.typeImageView.image = UIImage.init(named: "dir")
        }
        else if cellData?.type == "file"
        {
            self.typeImageView.image = UIImage.init(named: "file")
        }
        
        self.titleLabel.text = cellData?.name
    }
    
    
}
