//
//  ZLRepositoryTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2019/7/30.
//  Copyright © 2019 ZM. All rights reserved.
//

import UIKit


@objc protocol ZLRepositoryTableViewCellDelegate : NSObjectProtocol
{
    func onRepoAvaterClicked() -> Void
    
    func getOwnerAvatarURL() -> String?

    func getRepoFullName() -> String?
    
    func getRepoName() -> String?
    
    func getOwnerName() -> String?
    
    func getRepoMainLanguage() -> String?
    
    func getRepoDesc() -> String?
    
    func isPriva() -> Bool
    
    func starNum() -> Int
    
    func forkNum() -> Int
}

class ZLRepositoryTableViewCell: UITableViewCell {

    var avatarButton: UIButton!
    @IBOutlet weak var containerView: UIView!
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
        
        self.avatarButton = UIButton(type: .custom)
        self.avatarButton.cornerRadius = 25
        self.containerView.addSubview(self.avatarButton)
        self.avatarButton.snp_makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        self.avatarButton.addTarget(self, action: #selector(onAvatarSingleTapAction), for: .touchUpInside)
        
        self.containerView.cornerRadius = 8.0
        
        self.repostitoryNameLabel.adjustsFontSizeToFitWidth = true
        
        self.justUpdate()
        self.headImageView.cornerRadius = 25.0
        
        self.privateLabel.layer.cornerRadius = 2.0
        self.privateLabel.layer.borderColor = UIColor.lightGray.cgColor
        self.privateLabel.layer.borderWidth = 1.0
                
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    
    func justUpdate(){
        self.starLabel.text = ZLLocalizedString(string: "star :", comment: "标星")
        self.forkLabel.text = ZLLocalizedString(string: "fork :", comment: "拷贝");
        self.privateLabel.text = ZLLocalizedString(string: "private", comment: "私有")
    }
    
}

extension ZLRepositoryTableViewCell
{
    func fillWithData(data : ZLRepositoryTableViewCellDelegate) -> Void
    {
        self.delegate = data
        self.avatarButton.sd_setBackgroundImage(with: URL.init(string: data.getOwnerAvatarURL() ?? ""),
                                                for: .normal,
                                                placeholderImage: UIImage.init(named: "default_avatar"))
        self.repostitoryNameLabel.text = data.getRepoName()
        self.languageLabel.text = data.getRepoMainLanguage()
        self.descriptionLabel.text = data.getRepoDesc()
        self.forkNumLabel.text = "\(data.forkNum())"
        self.starNumLabel.text = "\(data.starNum())"
        self.ownerNameLabel.text = data.getOwnerName()
        self.privateLabel.isHidden = !data.isPriva()
    }
}


extension ZLRepositoryTableViewCell
{
    @objc func onAvatarSingleTapAction()
    {
        if self.delegate?.responds(to: #selector(ZLRepositoryTableViewCellDelegate.onRepoAvaterClicked)) ?? false
        {
            self.delegate?.onRepoAvaterClicked()
        }
    }
}
