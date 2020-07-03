//
//  ZLGistTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/2/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLGistTableViewCellDelegate : NSObjectProtocol {
    func onCellSingleTap() -> Void
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
    
    var delegate : ZLGistTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        
        self.containerView.layer.cornerRadius = 8.0;
        self.containerView.layer.masksToBounds = true
        
        self.imageButton.layer.cornerRadius = 25.0
        self.imageButton.layer.masksToBounds = true
        
        self.privateLabel.layer.cornerRadius = 2.0
        self.privateLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.privateLabel.layer.borderWidth = 1.0
        
        let singleTagGesture = UITapGestureRecognizer.init(target: self, action: #selector(self.onCellSingleTap(gestureRecognizer:)))
        self.containerView?.addGestureRecognizer(singleTagGesture)
        
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
       
        if cellData.getUpdate_At() != nil {
            self.timeLabel.text = "\(ZLLocalizedString(string: "update at", comment: "更新于"))\((cellData.getUpdate_At()! as NSDate).dateLocalStrSinceCurrentTime())"
        } else if cellData.getCreate_At() != nil {
              self.timeLabel.text = "\(ZLLocalizedString(string: "created at", comment: "创建于"))\((cellData.getCreate_At()! as NSDate).dateLocalStrSinceCurrentTime())"
        }
    
        self.descLabel.text = cellData.getDesc()
    }
}


// MARK : action
extension ZLGistTableViewCell
{
    @objc func onCellSingleTap(gestureRecognizer : UITapGestureRecognizer)
    {
        if self.delegate?.responds(to: #selector(ZLGistTableViewCellDelegate.onCellSingleTap)) ?? false
        {
            self.delegate?.onCellSingleTap()
        }
    }
}
