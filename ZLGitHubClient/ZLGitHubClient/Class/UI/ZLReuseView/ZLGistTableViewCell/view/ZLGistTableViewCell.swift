//
//  ZLGistTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLGistTableViewCellDelegate : NSObjectProtocol {
   
}


class ZLGistTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var gistNameLabel: UILabel!
    @IBOutlet weak var fileLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var privateLabel: UILabel!
    
    weak var delegate : ZLGistTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.containerView.layer.cornerRadius = 8.0;
        self.containerView.layer.masksToBounds = true
        
        self.imageButton.layer.cornerRadius = 25.0
        self.imageButton.layer.masksToBounds = true
        
        self.privateLabel.layer.cornerRadius = 2.0
        self.privateLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.privateLabel.layer.borderWidth = 1.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    func fillWithData(cellData : ZLGistTableViewCellData){
        
        self.imageButton.sd_setBackgroundImage(with: URL.init(string: cellData.getOwnerAvatar()), for: .normal, placeholderImage: UIImage.init(named: "default_avatar"), options: .refreshCached, context: nil)
        
        let firstFileName = cellData.getFirstFileName()
        self.gistNameLabel.text = NSString.init(format: "%@/%@", cellData.getOwnerName(),firstFileName ?? "") as String
        self.fileLabel.text = "\(String(describing: cellData.getFileCount()))\(ZLLocalizedString(string: "gistFiles", comment: "条代码片段"))"
        self.commentLabel.text = "\(String(describing:cellData.getCommentsCount()))\(ZLLocalizedString(string: "comments", comment: "条评论"))"
        
        self.privateLabel.isHidden = cellData.isPub()
       
        if let update_at = cellData.getUpdate_At() {
            self.timeLabel.text = "\(ZLLocalizedString(string: "update at", comment: "更新于"))\((update_at as NSDate).dateLocalStrSinceCurrentTime())"
        } else if let create_at = cellData.getCreate_At() {
              self.timeLabel.text = "\(ZLLocalizedString(string: "created at", comment: "创建于"))\((create_at as NSDate).dateLocalStrSinceCurrentTime())"
        }
    
        self.descLabel.text = cellData.getDesc()
    }
}

