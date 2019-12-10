//
//  ZLRepositoryTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/30.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit


protocol ZLRepositoryTableViewCellDelegate : NSObjectProtocol
{
    func onRepoAvaterButtonClicked(button: UIButton) -> Void
    
    func onRepoContainerViewClicked() -> Void
}

class ZLRepositoryTableViewCell: UITableViewCell {

    @IBOutlet weak var headImageView: UIImageView!
    @IBOutlet weak var repostitoryNameLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var ownerNameLabel: UILabel!
    
    
    @IBOutlet weak var privateLabel: UILabel!
    @IBOutlet weak var starLabel: UILabel!
    @IBOutlet weak var forkLabel: UILabel!
    
    @IBOutlet weak var starNumLabel: UILabel!
    @IBOutlet weak var forkNumLabel: UILabel!
    
    weak var delegate : ZLRepositoryTableViewCellDelegate?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .none
        self.justUpdate()
        self.headImageView.layer.cornerRadius = 25.0
        self.headImageView.layer.masksToBounds = true
        
        self.privateLabel.layer.cornerRadius = 2.0
        self.privateLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.privateLabel.layer.borderWidth = 1.0
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    
    func justUpdate()
    {
        self.starLabel.text = ZLLocalizedString(string: "star :", comment: "标星")
        self.forkLabel.text = ZLLocalizedString(string: "fork :", comment: "拷贝");
        self.privateLabel.text = ZLLocalizedString(string: "private", comment: "私有")
    }
    
}

extension ZLRepositoryTableViewCell
{
    func fillWithData(data : ZLRepositoryTableViewCellData) -> Void
    {
        self.headImageView.sd_setImage(with: URL.init(string: data.getOwnerAvatarURL() ?? ""), placeholderImage: nil);
        self.repostitoryNameLabel.text = data.getRepoName()
        self.languageLabel.text = data.getRepoMainLanguage()
        self.descriptionLabel.text = data.getRepoDesc()
        self.forkNumLabel.text = "\(data.forkNum())"
        self.starNumLabel.text = "\(data.starNum())"
        self.ownerNameLabel.text = data.getOwnerName()
    }
}
