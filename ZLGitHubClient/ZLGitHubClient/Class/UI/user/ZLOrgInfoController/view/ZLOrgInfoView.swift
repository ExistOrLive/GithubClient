//
//  ZLOrgInfoView.swift
//  ZLGitHubClient
//
//  Created by 朱猛 on 2021/4/9.
//  Copyright © 2021 ZM. All rights reserved.
//

import UIKit

protocol ZLOrgInfoViewDelegateAndDataSource: ZLReadMeViewDelegate{
    
    var login: String? {get}
    var name: String? {get}
    var avatarURL: String? {get}
    var createTimeStr: String? {get}
    var bio: String? {get}
    
    var repositoryNum: Int {get}
    var membersNum: Int {get}
    
    var address: String? {get}
    var email: String? {get}
    var website: String? {get}
    
    
    func onRepositoriesButtonClicked()
    func onMembersButtonClicked()
    
    func onEmailButtonClicked()
    func onWebsiteButtonClicked()
}


class ZLOrgInfoView: ZLBaseView {
    
    private weak var delegate: ZLOrgInfoViewDelegateAndDataSource?
    
    @IBOutlet weak private var headImageView: UIImageView!
    @IBOutlet weak private var nameLabel: UILabel!
    @IBOutlet weak private var createTimeLabel: UILabel!
    @IBOutlet weak private var bioLabel: UILabel!
    
     
    
    @IBOutlet weak private var repoLabel: UILabel!
    @IBOutlet weak private var addrLabel: UILabel!
    @IBOutlet weak private var emailLabel: UILabel!
    @IBOutlet weak private var websiteLabel: UILabel!
    
    @IBOutlet weak private var repoInfoLabel: UILabel!
    @IBOutlet weak private var addressInfoLabel: UILabel!
    @IBOutlet weak private var emailInfoLabel: UILabel!
    @IBOutlet weak private var websiteInfoLabel: UILabel!
    
    @IBOutlet weak var itemStackView: UIStackView!
    
    var readMeView : ZLReadMeView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        guard let readMeView : ZLReadMeView = Bundle.main.loadNibNamed("ZLReadMeView", owner: nil, options: nil)?.first as? ZLReadMeView else {
            return
        }
        self.addSubview(readMeView)
        readMeView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.itemStackView.snp_bottom).offset(10)
        }
        self.readMeView = readMeView
        
        self.justUpdate()
    }
    
    func justUpdate(){
        repoLabel.text = ZLLocalizedString(string: "repositories",comment: "仓库")
        addrLabel.text = ZLLocalizedString(string:"location", comment: "地址")
        emailLabel.text = ZLLocalizedString(string:"email", comment: "邮箱")
        websiteLabel.text = ZLLocalizedString(string: "website", comment: "主页")
     
        createTimeLabel.text = delegate?.createTimeStr
    }
    
    func fillWithData(delegateAndDatasource: ZLOrgInfoViewDelegateAndDataSource){
        delegate = delegateAndDatasource
        self.readMeView?.delegate = delegateAndDatasource
        self.reloadData()
        self.readMeView?.startLoad(fullName: "\(delegateAndDatasource.login ?? "")/\(delegateAndDatasource.login ?? "")", branch: nil)
        
    }
    
    func reloadData(){
        
        headImageView.sd_setImage(with: URL.init(string: delegate?.avatarURL ?? ""), placeholderImage: UIImage.init(named: "default_avatar"));
        nameLabel.text = "\(delegate?.name ?? "")(\(delegate?.login ?? ""))"
        createTimeLabel.text = delegate?.createTimeStr
        bioLabel.text = delegate?.bio
        
        repoInfoLabel.text = "\(delegate?.repositoryNum ?? 0)"
        
        addressInfoLabel.text = delegate?.address
        emailInfoLabel.text = delegate?.email
        websiteInfoLabel.text = delegate?.website
        
    }
    
    
    
    @IBAction func onRepoButtonClicked(_ sender: Any) {
        delegate?.onRepositoriesButtonClicked()
    }
    
    @IBAction func onEmailButtonClicked(_ sender: Any) {
        delegate?.onEmailButtonClicked()
    }
    
    @IBAction func onWebsiteButtonClicked(_ sender: Any) {
        delegate?.onWebsiteButtonClicked()
    }
    
}
