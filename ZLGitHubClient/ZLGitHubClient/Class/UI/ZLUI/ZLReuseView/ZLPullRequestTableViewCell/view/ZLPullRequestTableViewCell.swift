//
//  ZLPullRequestTableViewCell.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2020/3/10.
//  Copyright © 2020 ZM. All rights reserved.
//

import UIKit

@objc protocol ZLPullRequestTableViewCellDelegate : NSObjectProtocol {
    
    func getIssueRepoFullName() -> String?
    
    func getTitle() -> String?
    
    func getAssistInfo() -> String?
    
    func getState() -> ZLGithubPullRequestState
    
    func isMerged() -> Bool
    
    func onClickRepoFullName()
}

class ZLPullRequestTableViewCell: UITableViewCell {
    
    weak var  delegate : ZLPullRequestTableViewCellDelegate?
    
    var statusTag: UIImageView!
    var containerView: UIView!
    var repoNameButton: UIButton!
    var titleLabel: UILabel!
    var assistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containerView.layer.cornerRadius = 8.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setUpUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func onRepoNameClick(){
        self.delegate?.onClickRepoFullName()
    }
    
    
    func setUpUI() {
        
        self.backgroundColor = UIColor.clear
        
        let view = UIView()
        view.backgroundColor = UIColor(named: "ZLCellBack")
        view.cornerRadius = 8.0
        self.contentView.addSubview(view)
        view.snp.makeConstraints { (make) in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10))
        }
        containerView = view
        
        let imageView = UIImageView()
        containerView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.top.equalToSuperview().offset(10)
            make.size.equalTo(CGSize(width: 20, height: 20))
        }
        statusTag = imageView
        
        let button = UIButton()
        button.contentHorizontalAlignment = .leading
        containerView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.left.equalTo(statusTag.snp_right).offset(10)
            make.centerY.equalTo(statusTag)
            make.right.equalToSuperview().offset(-15)
        }
        button.addTarget(self, action: #selector(onRepoNameClick), for: .touchUpInside)
        repoNameButton = button
        
        let label = UILabel()
        label.numberOfLines = 0
        label.textColor = UIColor(named:"ZLLabelColor3")
        label.font = UIFont(name: Font_PingFangSCRegular, size: 15)
        containerView.addSubview(label)
        label.snp.makeConstraints{ (make) in
            make.left.equalTo(statusTag.snp_right).offset(10)
            make.top.equalTo(repoNameButton.snp.bottom).offset(10)
            make.right.equalToSuperview().offset(-15)
        }
        titleLabel = label
            
        let label2 = UILabel()
        label2.textColor = UIColor(named:"ZLLabelColor2")
        label2.font = UIFont(name: Font_PingFangSCRegular, size: 12)
        containerView.addSubview(label2)
        label2.snp.makeConstraints{ (make) in
            make.left.equalTo(statusTag.snp_right).offset(10)
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview().offset(-10)
        }
        assistLabel = label2
        
    }
    
    

    func fillWithData(data : ZLPullRequestTableViewCellDelegate){
       
        self.delegate = data
        
        self.titleLabel.text = data.getTitle()
        self.assistLabel.text = data.getAssistInfo()
        
        self.repoNameButton.setAttributedTitle(NSAttributedString(string: data.getIssueRepoFullName() ?? "",attributes: [NSAttributedString.Key.foregroundColor:UIColor(named: "ZLLabelColor1")!,NSAttributedString.Key.font:UIFont(name: Font_PingFangSCMedium, size: 15)!]), for: .normal)
        
        if data.getState() == .open {
            self.statusTag?.image = UIImage.init(named: "pr_opened")
        } else if data.isMerged() {
            self.statusTag?.image = UIImage.init(named: "pr_merged")
        } else {
            self.statusTag?.image = UIImage.init(named: "pr_closed")
        }
        
    }
    
}
