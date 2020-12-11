//
//  ZLWorkboardTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/11/20.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

enum ZLWorkboardType {
    case issues
    case pullRequest
    case repos
    case orgs
    case starRepos
    case events
    case fixRepo
}


@objc protocol ZLWorkboardTableViewCellDelegate : NSObjectProtocol{
   
    func onCellClicked() -> Void
    
    var title : String { get }
    
    var avatarURL : String{ get }
    
    var isGithubItem : Bool{ get }
    
}


class ZLWorkboardTableViewCell: UITableViewCell {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var singleLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func fillWithData(cellData : ZLWorkboardTableViewCellDelegate){
        
        if cellData.isGithubItem {
            self.avatarImageView.sd_setImage(with: URL.init(string: cellData.avatarURL), placeholderImage: UIImage(named:"default_avatar"))
        } else {
            self.avatarImageView.image = UIImage.init(named: cellData.avatarURL)
        }
        self.titleLabel.text = cellData.title
         
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.backView.backgroundColor = UIColor.init(named: "ZLCellBackSelected")
        }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.backView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        UIView.animate(withDuration: 0.1) {
            self.backView.backgroundColor = UIColor.init(named: "ZLCellBack")
        }
    }
    
}
